import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/domain/repositories/catalog_repository.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/quiz/domain/entities/quiz_question_entity.dart';
import 'package:eodaego/features/quiz/presentation/pages/quiz_reward_page.dart';
import 'package:eodaego/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// 게스트 경로에서 절대 불려서는 안 되는 요약 API — 호출되면 던져서
/// "요청 자체가 없었다"를 증명한다 (56e947b 회귀 방지).
class _ThrowingCatalogRepository implements CatalogRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);

  @override
  Future<CatalogSummaryEntity> getCatalogSummary() async {
    throw StateError('게스트는 수집 진행률 API를 요청하면 안 된다');
  }
}

class _FakeCatalogRepository implements CatalogRepository {
  _FakeCatalogRepository(this.summary, {this.items = const []});

  final CatalogSummaryEntity summary;
  final List<CatalogItemEntity> items;

  /// collect가 받은 catalogItemId 기록 — 관찰 가능한 경계 상태.
  final collectedIds = <String>[];

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);

  @override
  Future<CatalogSummaryEntity> getCatalogSummary() async => summary;

  @override
  Future<List<CatalogItemEntity>> getCatalogItems() async => items;

  @override
  Future<void> collectCatalogItem(String catalogItemId) async {
    collectedIds.add(catalogItemId);
  }
}

// 실 mock/quiz.json 대신 고정 문항 하나만 쓴다. rootBundle을 거치는 실
// 에셋 로더는 위젯 테스트를 여러 개 연달아 돌릴 때(같은 프로세스에서 엘리먼트
// 트리가 재사용될 때) 두 번째 테스트부터 Future가 정착하지 않는 경우가
// 있었다 — override로 우회해 테스트를 실 에셋 I/O에서 분리한다.
const _questions = [
  QuizQuestionEntity(
    name: '수달',
    category: DogamCategory.animal,
    question: '이 친구 이름이 뭘까요?',
    choices: ['너구리', '수달', '비버'],
    answerIndex: 1,
    code: 'A001',
  ),
];

Widget _wrap({required bool isGuest, required CatalogRepository repository}) {
  return ProviderScope(
    overrides: [
      guestModeProvider.overrideWith((ref) => isGuest),
      catalogRepositoryProvider.overrideWith((ref) => repository),
      quizQuestionsProvider.overrideWith((ref) async => _questions),
    ],
    child: ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, _) => const MaterialApp(home: QuizRewardPage()),
    ),
  );
}

/// 테스트 기본 뷰(800x600)는 ScreenUtil 기준(393x852)과 달라 레이아웃이
/// 오버플로우된다. collection_page_test.dart와 같은 이유로 뷰포트를 맞춘다.
void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('QuizRewardPage', () {
    testWidgets('게스트는 수집 진행률 API를 요청하지 않고 진행률 줄을 숨긴다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(
        _wrap(isGuest: true, repository: _ThrowingCatalogRepository()),
      );
      await tester.pumpAndSettle();

      // 위 override가 던지지 않았다는 것 자체가 "요청하지 않았다"는 증거다.
      expect(tester.takeException(), isNull);
      expect(find.textContaining('모았어요'), findsNothing);
      expect(find.text('수달'), findsOneWidget);
    });

    testWidgets('로그인 사용자는 수집 진행률을 보여준다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(
        _wrap(
          isGuest: false,
          repository: _FakeCatalogRepository(
            const CatalogSummaryEntity(
              totalCount: 24,
              collectedCount: 9,
              collectionRate: 37.5,
              collectedByCategory: {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('9 / 24 모았어요'), findsOneWidget);
    });

    testWidgets('도감·마스코트 에셋이 없어도 화면이 예외 없이 정상 렌더링된다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(
        _wrap(
          isGuest: false,
          repository: _FakeCatalogRepository(
            const CatalogSummaryEntity(
              totalCount: 1,
              collectedCount: 1,
              collectionRate: 100,
              collectedByCategory: {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // assets/images/{catalog,mascot}/ 는 .gitkeep뿐이다. 여기서 예외가
      // 없다는 것이 곧 "에셋이 없어도 화면이 깨지지 않는다"는 증거다.
      expect(tester.takeException(), isNull);
      expect(find.text('정답이에요!'), findsOneWidget);
      expect(find.text('수달'), findsOneWidget);
      expect(find.text('도감 보러 가기'), findsOneWidget);
    });

    testWidgets('보상 화면 진입 시 미수집 항목을 수집 처리한다', (tester) async {
      _useDesignViewport(tester);
      final repository = _FakeCatalogRepository(
        const CatalogSummaryEntity(
          totalCount: 24,
          collectedCount: 9,
          collectionRate: 37.5,
          collectedByCategory: {},
        ),
        items: const [
          CatalogItemEntity(
            id: 'item-a001',
            category: DogamCategory.animal,
            collected: false,
            code: 'A001',
          ),
        ],
      );
      await tester.pumpWidget(_wrap(isGuest: false, repository: repository));
      await tester.pumpAndSettle();

      expect(repository.collectedIds, ['item-a001']);
    });

    testWidgets('게스트는 수집 API를 호출하지 않는다', (tester) async {
      _useDesignViewport(tester);
      final repository = _FakeCatalogRepository(
        const CatalogSummaryEntity(
          totalCount: 24,
          collectedCount: 9,
          collectionRate: 37.5,
          collectedByCategory: {},
        ),
        items: const [
          CatalogItemEntity(
            id: 'item-a001',
            category: DogamCategory.animal,
            collected: false,
            code: 'A001',
          ),
        ],
      );
      await tester.pumpWidget(_wrap(isGuest: true, repository: repository));
      await tester.pumpAndSettle();

      expect(repository.collectedIds, isEmpty);
    });
  });
}
