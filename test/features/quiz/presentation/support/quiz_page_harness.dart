import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/quiz/domain/entities/quiz_entity.dart';
import 'package:eodaego/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:eodaego/features/quiz/presentation/pages/quiz_page.dart';
import 'package:eodaego/features/quiz/presentation/pages/quiz_reward_page.dart';
import 'package:eodaego/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:eodaego/features/quiz/presentation/providers/quiz_session_provider.dart';
import 'package:eodaego/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// 정답은 'a'. [expired]면 제출이 QUIZ_NOT_FOUND로 실패한다.
class FakeQuizRepository implements QuizRepository {
  FakeQuizRepository({this.expired = false});
  final bool expired;
  final submitted = <String>[];

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
    submitted.add(catalogItemId);
    if (expired) {
      throw ServerException(message: 'expired', code: 'QUIZ_NOT_FOUND');
    }
    return catalogItemId == 'a'
        ? const QuizAnswerEntity(correct: true, collectedCatalogItemId: 'a')
        : const QuizAnswerEntity(correct: false);
  }
}

void useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// 퀴즈를 시작한 세션 + 실 GoRouter(scan/quiz/reward/detail)로 앱을 띄운다.
Future<ProviderContainer> pumpQuizApp(
  WidgetTester tester, {
  required FakeQuizRepository repo,
  bool startSession = true,
  String? imagePath,
  List<CatalogItemEntity>? catalog,
  List<Override> extraOverrides = const [],
}) async {
  useDesignViewport(tester);
  final container = ProviderContainer(
    overrides: [
      quizRepositoryProvider.overrideWithValue(repo),
      guestRestrictedProvider.overrideWithValue(true),
      ...extraOverrides,
      catalogItemsProvider.overrideWith((ref) async => catalog ?? const []),
    ],
  );
  addTearDown(container.dispose);
  // 구독을 붙들어 autoDispose 타이머가 테스트 끝에 남지 않게 한다.
  container.listen(catalogItemsProvider, (_, _) {});
  if (catalog != null) await container.read(catalogItemsProvider.future);
  if (startSession) {
    await container
        .read(quizSessionProvider.notifier)
        .start(category: DogamCategory.animal, imagePath: imagePath);
  }
  final router = GoRouter(
    initialLocation: RoutePaths.quiz,
    routes: [
      GoRoute(
        path: RoutePaths.scan,
        builder: (_, _) => const Scaffold(body: Text('SCAN_PAGE')),
      ),
      GoRoute(path: RoutePaths.quiz, builder: (_, _) => const QuizPage()),
      GoRoute(
        path: RoutePaths.quizReward,
        builder: (_, _) => const QuizRewardPage(),
      ),
      GoRoute(
        path: '${RoutePaths.collection}/:id',
        builder: (_, s) =>
            Scaffold(body: Text('DETAIL_${s.pathParameters['id']}')),
      ),
      GoRoute(
        path: RoutePaths.collection,
        builder: (_, _) => const Scaffold(body: Text('COLLECTION')),
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) => MaterialApp.router(routerConfig: router),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  return container;
}
