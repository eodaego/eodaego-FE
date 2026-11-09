import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/dogam_category.dart';
import '../../../../core/providers/selected_course_provider.dart';
import '../../../collection/presentation/providers/catalog_provider.dart';
import '../../../course/presentation/providers/course_provider.dart';
import '../../domain/entities/quiz_entity.dart';
import 'quiz_provider.dart';

part 'quiz_session_provider.g.dart';

/// 지금 풀고 있는 사진 퀴즈 한 판의 상태.
class QuizSessionState {
  const QuizSessionState({
    required this.quiz,
    required this.category,
    required this.imagePath,
    this.lockedChoiceIds = const {},
    this.result,
    this.alreadyCollected = false,
    this.collectedBeforeIds = const {},
  });

  final QuizEntity quiz;
  final DogamCategory category;
  final String? imagePath;

  /// 오답으로 눌러 더 못 누르는 선택지 id
  final Set<String> lockedChoiceIds;

  /// 정답을 맞힌 뒤의 결과. 풀이 중에는 null
  final QuizAnswerEntity? result;

  /// 퀴즈 시작 시점에 이미 수집돼 있던 항목인지 (보상 화면 문구 분기용)
  final bool alreadyCollected;

  /// 퀴즈 시작 시점의 수집 완료 id 스냅숏. 도감이 아직 안 불러와졌으면 비어 있다.
  final Set<String> collectedBeforeIds;

  QuizSessionState copyWith({
    Set<String>? lockedChoiceIds,
    QuizAnswerEntity? result,
    bool? alreadyCollected,
  }) => QuizSessionState(
    quiz: quiz,
    category: category,
    imagePath: imagePath,
    lockedChoiceIds: lockedChoiceIds ?? this.lockedChoiceIds,
    result: result ?? this.result,
    alreadyCollected: alreadyCollected ?? this.alreadyCollected,
    collectedBeforeIds: collectedBeforeIds,
  );
}

@Riverpod(keepAlive: true)
class QuizSession extends _$QuizSession {
  Future<QuizAnswerEntity>? _inFlight;

  @override
  QuizSessionState? build() => null;

  /// 퀴즈를 만든다. 실패는 그대로 던진다.
  Future<void> start({
    required DogamCategory category,
    required String? imagePath,
  }) async {
    final quiz = await ref
        .read(quizRepositoryProvider)
        .createQuiz(category: category, imagePath: imagePath);
    // 도감이 안 불러와졌으면 빈 집합 — 새로 모은 것으로 안내한다.
    final items = ref.read(catalogItemsProvider).valueOrNull ?? const [];
    final collected = {
      for (final item in items)
        if (item.collected) item.id,
    };
    _inFlight = null;
    state = QuizSessionState(
      quiz: quiz,
      category: category,
      imagePath: imagePath,
      collectedBeforeIds: collected,
    );
  }

  /// 선택지를 제출한다. 진행 중이면 같은 Future를 돌려줘 요청을 한 번만 보낸다.
  Future<QuizAnswerEntity> answer(String catalogItemId) {
    final running = _inFlight;
    if (running != null) return running;
    late final Future<QuizAnswerEntity> future;
    future = _submit(catalogItemId).whenComplete(() {
      // 오래된 제출이 새 제출의 가드를 풀지 않게 자기 자신일 때만 비운다.
      if (identical(_inFlight, future)) _inFlight = null;
    });
    return _inFlight = future;
  }

  Future<QuizAnswerEntity> _submit(String catalogItemId) async {
    final session = state;
    if (session == null) throw StateError('퀴즈가 시작되지 않았어요');

    final QuizAnswerEntity result;
    try {
      result = await ref
          .read(quizRepositoryProvider)
          .submitAnswer(
            quizId: session.quiz.quizId,
            catalogItemId: catalogItemId,
          );
    } catch (e) {
      debugPrint('[Quiz] ❌ 정답 제출 실패: $e');
      rethrow;
    }

    // 기다리는 사이 clear()/start()로 세션이 바뀌었으면 늦은 응답은 버린다.
    if (!identical(state, session)) return result;

    if (!result.correct) {
      state = session.copyWith(
        lockedChoiceIds: {...session.lockedChoiceIds, catalogItemId},
      );
      return result;
    }

    final collectedId = result.collectedCatalogItemId;
    state = session.copyWith(
      result: result,
      alreadyCollected:
          collectedId != null &&
          session.collectedBeforeIds.contains(collectedId),
    );
    if (collectedId == null) return result;
    // 선택 코스의 수집 표시를 맞추고, 도감 캐시를 다시 받게 한다.
    ref
        .read(selectedCourseProvider.notifier)
        .update((course) => course?.markCollected(collectedId));
    ref.invalidate(catalogItemsProvider);
    ref.invalidate(catalogSummaryProvider);
    // 서버 기준 코스 상태 동기화는 기다리지 않는다.
    unawaited(ref.read(selectedCourseSyncProvider.notifier).sync());
    debugPrint('[Quiz] ✅ 정답 — 수집 처리: $collectedId');
    return result;
  }

  void clear() {
    _inFlight = null;
    state = null;
  }
}
