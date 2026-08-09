import 'dart:async';

import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/widgets/app_skeleton.dart';
import 'package:eodaego/features/auth/domain/entities/auth_result_entity.dart';
import 'package:eodaego/features/auth/presentation/providers/auth_provider.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/user/presentation/pages/my_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// [Finding 2] 로그인 사용자의 수집 통계 카드 — 로딩/에러/데이터 3상태를 구분한다.
/// `valueOrNull ?? 0`이 로딩과 에러를 모두 0으로 뭉개던 버그의 회귀 테스트.

const _summary = CatalogSummaryEntity(
  totalCount: 80,
  collectedCount: 24,
  collectionRate: 30.5,
  collectedByCategory: {
    DogamCategory.animal: 8,
    DogamCategory.plant: 8,
    DogamCategory.place: 8,
  },
);

// authNotifierProvider의 실 build()는 Firebase 초기화가 안 된 테스트 환경에서
// 즉시 예외를 던진다(my_page_delete_account_test.dart와 동일한 shape).
class _TestAuthNotifier extends AuthNotifier {
  @override
  Future<AuthResultEntity?> build() async => const AuthResultEntity(
    userId: 'test-user-uuid',
    nickname: '탐험가123',
    isNewUser: false,
    requiresAgreement: false,
  );
}

Widget _wrap(Override summaryOverride) => ProviderScope(
  overrides: [
    authNotifierProvider.overrideWith(() => _TestAuthNotifier()),
    summaryOverride,
  ],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (context, _) => const MaterialApp(home: MyPage()),
  ),
);

void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('MyPage 수집 통계 카드', () {
    testWidgets('로딩 중에는 숫자 대신 스켈레톤을 보여준다', (tester) async {
      _useDesignViewport(tester);
      final gate = Completer<CatalogSummaryEntity>();

      await tester.pumpWidget(
        _wrap(catalogSummaryProvider.overrideWith((ref) => gate.future)),
      );
      // pumpAndSettle을 쓰지 않는다 — gate가 안 열려 영원히 끝나지 않는다.
      await tester.pump();

      expect(find.byType(AppSkeleton), findsNWidgets(2));
      expect(find.text('0.0%'), findsNothing);
      expect(find.text('0'), findsNothing);

      gate.complete(_summary);
      await tester.pumpAndSettle();
    });

    testWidgets('조회에 실패하면 0을 사실처럼 보여주지 않고 짧은 안내를 보여준다', (tester) async {
      _useDesignViewport(tester);

      await tester.pumpWidget(
        _wrap(
          catalogSummaryProvider.overrideWith(
            (ref) async => throw StateError('network down'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('수집 현황을 불러오지 못했어요'), findsOneWidget);
      expect(find.text('0.0%'), findsNothing);
      expect(find.text('0'), findsNothing);
      expect(find.byType(AppSkeleton), findsNothing);
    });

    testWidgets('조회에 성공하면 수집률을 소수점 한 자리까지 보여준다', (tester) async {
      _useDesignViewport(tester);

      await tester.pumpWidget(
        _wrap(catalogSummaryProvider.overrideWith((ref) async => _summary)),
      );
      await tester.pumpAndSettle();

      expect(find.text('30.5%'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);
    });
  });
}
