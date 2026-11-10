import 'dart:async';

import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/quiz/domain/entities/quiz_entity.dart';
import 'package:eodaego/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:eodaego/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:eodaego/features/quiz/presentation/quiz_messages.dart';
import 'package:eodaego/features/scan/presentation/pages/scan_page.dart';
import 'package:eodaego/features/scan/presentation/providers/scan_camera_provider.dart';
import 'package:eodaego/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// 퀴즈 생성 API 경계 페이크. [gate]가 있으면 완료될 때까지 응답을 붙든다.
class _FakeQuizRepository implements QuizRepository {
  _FakeQuizRepository({this.gate, this.error});
  final Completer<void>? gate;
  final Object? error;
  var createCalls = 0;
  DogamCategory? lastCategory;

  @override
  Future<QuizEntity> createQuiz({
    required DogamCategory category,
    required String? imagePath,
  }) async {
    createCalls++;
    lastCategory = category;
    await gate?.future;
    if (error != null) throw error!;
    return const QuizEntity(
      quizId: 'q1',
      choices: [QuizChoiceEntity(catalogItemId: 'a', name: '수달')],
    );
  }

  @override
  Future<QuizAnswerEntity> submitAnswer({
    required String quizId,
    required String catalogItemId,
  }) => throw UnimplementedError();
}

const _quizPageText = 'quiz-page';

Future<GoRouter> _pumpScan(
  WidgetTester tester, {
  required _FakeQuizRepository repo,
  bool guest = false,
  DogamCategory? category,
  bool viaGo = false,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const Text('home-page'),
      ),
      GoRoute(
        path: RoutePaths.scan,
        builder: (context, state) =>
            ScanPage(initialCategory: category ?? DogamCategory.animal),
      ),
      GoRoute(
        path: RoutePaths.quiz,
        builder: (context, state) => const Text(_quizPageText),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // 실 카메라 플러그인을 건드리지 않는다 — 카메라 없는 기기 + 목 모드.
        availableCameraListProvider.overrideWith((ref) async => []),
        scanMockModeProvider.overrideWithValue(true),
        guestRestrictedProvider.overrideWithValue(guest),
        quizRepositoryProvider.overrideWithValue(repo),
        catalogItemsProvider.overrideWith((ref) async => []),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) => MaterialApp.router(routerConfig: router),
      ),
    ),
  );
  viaGo ? router.go(RoutePaths.scan) : router.push(RoutePaths.scan);
  await tester.pumpAndSettle();
  return router;
}

Finder _guide(DogamCategory category) =>
    find.text(scanGuideMessage(category), findRichText: true);

Finder _chip(DogamCategory category) => find.text(category.label);

void main() {
  testWidgets('close_button_goes_home_when_scan_has_no_back_stack', (
    tester,
  ) async {
    await _pumpScan(tester, repo: _FakeQuizRepository(), viaGo: true);

    await tester.tap(find.byTooltip('닫기'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('home-page'), findsOneWidget);
  });

  testWidgets('scan_page_starts_with_animal_chip_selected', (tester) async {
    await _pumpScan(tester, repo: _FakeQuizRepository());

    expect(_guide(DogamCategory.animal), findsOneWidget);
    for (final c in DogamCategory.values) {
      expect(_chip(c), findsOneWidget);
    }
  });

  testWidgets('scan_page_starts_with_place_chip_when_opened_from_place_card', (
    tester,
  ) async {
    final repo = _FakeQuizRepository();
    await _pumpScan(tester, repo: repo, category: DogamCategory.place);

    expect(_guide(DogamCategory.place), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(scanShutterLabel));
    await tester.pumpAndSettle();
    expect(repo.lastCategory, DogamCategory.place);
  });

  testWidgets('selecting_plant_chip_changes_guide_text', (tester) async {
    final repo = _FakeQuizRepository();
    await _pumpScan(tester, repo: repo);

    await tester.tap(_chip(DogamCategory.plant));
    await tester.pumpAndSettle();

    expect(_guide(DogamCategory.plant), findsOneWidget);
    expect(_guide(DogamCategory.animal), findsNothing);

    await tester.tap(find.bySemanticsLabel(scanShutterLabel));
    await tester.pumpAndSettle();
    expect(repo.lastCategory, DogamCategory.plant);
  });

  testWidgets('shutter_for_guest_shows_login_gate', (tester) async {
    final repo = _FakeQuizRepository();
    await _pumpScan(tester, repo: repo, guest: true);

    await tester.tap(find.bySemanticsLabel(scanShutterLabel));
    await tester.pumpAndSettle();

    expect(find.text('로그인하면 사진을 찍고 도감을 모을 수 있어요'), findsOneWidget);
    expect(repo.createCalls, 0);
  });

  testWidgets('shutter_twice_quickly_starts_one_quiz', (tester) async {
    final gate = Completer<void>();
    final repo = _FakeQuizRepository(gate: gate);
    await _pumpScan(tester, repo: repo);

    await tester.tap(find.bySemanticsLabel(scanShutterLabel));
    await tester.pump();
    expect(find.text(scanWaitingMessage), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(scanShutterLabel));
    await tester.pump();

    gate.complete();
    await tester.pumpAndSettle();

    expect(repo.createCalls, 1);
    expect(find.text(_quizPageText), findsOneWidget);
  });

  testWidgets('recognition_failure_stays_on_scan_page_with_message', (
    tester,
  ) async {
    final repo = _FakeQuizRepository(
      error: const ServerException(message: 'x', code: 'RECOGNITION_FAILED'),
    );
    await _pumpScan(tester, repo: repo);

    await tester.tap(find.bySemanticsLabel(scanShutterLabel));
    await tester.pumpAndSettle();

    expect(find.text(scanRecognitionFailedMessage), findsOneWidget);
    expect(find.text(_quizPageText), findsNothing);
    expect(find.byType(ScanPage), findsOneWidget);
  });

  testWidgets('closing_scan_page_during_upload_does_not_open_quiz', (
    tester,
  ) async {
    final gate = Completer<void>();
    final repo = _FakeQuizRepository(gate: gate);
    final router = await _pumpScan(tester, repo: repo);

    await tester.tap(find.bySemanticsLabel(scanShutterLabel));
    await tester.pump();
    await tester.tap(find.byTooltip('닫기'));
    // 닫힘 전환이 도는 동안(화면은 아직 mounted) 응답이 온다.
    await tester.pump();
    gate.complete();
    await tester.pumpAndSettle();

    expect(find.byType(ScanPage), findsNothing);
    expect(find.text(_quizPageText), findsNothing);
    expect(router.state.uri.path, '/home');
  });
}
