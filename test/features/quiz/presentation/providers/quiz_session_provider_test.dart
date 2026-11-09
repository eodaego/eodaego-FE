import 'dart:async';

import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/core/providers/selected_course_provider.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/quiz/domain/entities/quiz_entity.dart';
import 'package:eodaego/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:eodaego/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:eodaego/features/quiz/presentation/providers/quiz_session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 정답은 'a'. [gate]가 있으면 완료될 때까지 제출을 붙든다.
class _FakeQuizRepository implements QuizRepository {
  _FakeQuizRepository({this.gate});
  final Completer<void>? gate;
  var submitCalls = 0;

  @override
  Future<QuizEntity> createQuiz({
    required DogamCategory category,
    required String? imagePath,
  }) async => const QuizEntity(
    quizId: 'q1',
    choices: [
      QuizChoiceEntity(catalogItemId: 'a', name: '수달'),
      QuizChoiceEntity(catalogItemId: 'b', name: '너구리'),
      QuizChoiceEntity(catalogItemId: 'c', name: '오소리'),
    ],
  );

  @override
  Future<QuizAnswerEntity> submitAnswer({
    required String quizId,
    required String catalogItemId,
  }) async {
    submitCalls++;
    await gate?.future;
    return catalogItemId == 'a'
        ? const QuizAnswerEntity(correct: true, collectedCatalogItemId: 'a')
        : const QuizAnswerEntity(correct: false);
  }
}

CatalogItemEntity _item(String id, {required bool collected}) =>
    CatalogItemEntity(
      id: id,
      category: DogamCategory.animal,
      collected: collected,
    );

CourseEntity _course() => const CourseEntity(
  id: 'c1',
  title: 'c1',
  tagLabels: [],
  estimatedDurationMinutes: 60,
  entrance: null,
  exit: null,
  favorite: false,
  places: [
    CoursePlaceEntity(
      visitOrder: 1,
      name: '수달',
      category: DogamCategory.animal,
      catalogItemId: 'a',
    ),
  ],
);

ProviderContainer _container(
  _FakeQuizRepository fake, {
  List<CatalogItemEntity>? catalog,
}) {
  final container = ProviderContainer(
    overrides: [
      quizRepositoryProvider.overrideWithValue(fake),
      // 코스 동기화는 이 테스트의 관심사가 아니다 — 게스트로 막아 네트워크를 안 탄다.
      guestRestrictedProvider.overrideWithValue(true),
      if (catalog != null)
        catalogItemsProvider.overrideWith((ref) async => catalog),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _start(ProviderContainer c) => c
    .read(quizSessionProvider.notifier)
    .start(category: DogamCategory.animal, imagePath: 'p.jpg');

void main() {
  test('answer_wrong_locks_only_that_choice', () async {
    final c = _container(_FakeQuizRepository());
    await _start(c);

    final result = await c.read(quizSessionProvider.notifier).answer('b');

    expect(result.correct, isFalse);
    final s = c.read(quizSessionProvider)!;
    expect(s.lockedChoiceIds, {'b'});
    expect(s.result, isNull);
  });

  test('answer_correct_marks_selected_course_place_collected', () async {
    final c = _container(_FakeQuizRepository());
    c.read(selectedCourseProvider.notifier).state = _course();
    await _start(c);

    await c.read(quizSessionProvider.notifier).answer('a');

    expect(c.read(selectedCourseProvider)!.places.single.collected, isTrue);
    expect(c.read(quizSessionProvider)!.result!.correct, isTrue);
  });

  test(
    'answer_correct_reports_already_collected_when_item_was_collected_before_quiz',
    () async {
      final c = _container(
        _FakeQuizRepository(),
        catalog: [_item('a', collected: true)],
      );
      await c.read(catalogItemsProvider.future);
      await _start(c);

      await c.read(quizSessionProvider.notifier).answer('a');

      expect(c.read(quizSessionProvider)!.alreadyCollected, isTrue);
    },
  );

  test(
    'answer_correct_reports_new_when_catalog_list_not_loaded',
    () async {
      final c = _container(
        _FakeQuizRepository(),
        catalog: [_item('a', collected: true)],
      );
      // 도감을 읽지 않았으므로 스냅숏이 없다.
      await _start(c);

      await c.read(quizSessionProvider.notifier).answer('a');

      expect(c.read(quizSessionProvider)!.alreadyCollected, isFalse);
    },
  );

  test('answer_called_twice_quickly_sends_one_request', () async {
    final gate = Completer<void>();
    final fake = _FakeQuizRepository(gate: gate);
    final c = _container(fake);
    await _start(c);
    final notifier = c.read(quizSessionProvider.notifier);

    final first = notifier.answer('b');
    final second = notifier.answer('b');
    gate.complete();
    await Future.wait([first, second]);

    expect(fake.submitCalls, 1);
  });
}
