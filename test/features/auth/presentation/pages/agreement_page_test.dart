import 'package:eodaego/core/widgets/pages/legal_document_page.dart';
import 'package:eodaego/features/auth/presentation/pages/agreement_page.dart';
import 'package:eodaego/features/user/domain/entities/agreement_status_entity.dart';
import 'package:eodaego/features/user/domain/repositories/user_repository.dart';
import 'package:eodaego/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUserRepository implements UserRepository {
  @override
  Future<AgreementStatusEntity> getAgreements() async =>
      const AgreementStatusEntity(
        termsOfService: false,
        privacyPolicy: false,
        locationTerms: false,
        marketing: false,
      );

  @override
  Future<void> updateAgreements({required bool marketing}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _wrap() => ProviderScope(
  overrides: [
    userRepositoryProvider.overrideWith((ref) => _FakeUserRepository()),
  ],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (context, _) => const MaterialApp(home: AgreementPage()),
  ),
);

/// 체크 상태 = 채워진 아이콘, 미체크 = 외곽선 아이콘.
int _checkedCount(WidgetTester tester) =>
    tester.widgetList<Icon>(find.byIcon(Icons.check_circle_rounded)).length;

/// 테스트 기본 뷰(800x600)는 ScreenUtil 기준(393x852)과 달라 레이아웃이 왜곡된다.
/// 실제 기기 비율로 맞춘다.
void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('AgreementPage', () {
    testWidgets('라벨 영역을 탭하면 동의가 토글되고 약관 전문은 열리지 않는다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(_checkedCount(tester), 0);

      await tester.tap(find.textContaining('서비스 이용약관'));
      await tester.pumpAndSettle();

      expect(_checkedCount(tester), 1);
      expect(find.byType(LegalDocumentPage), findsNothing);
    });

    testWidgets('> 를 탭하면 약관 전문 페이지가 열리고 동의는 토글되지 않는다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.chevron_right_rounded).first);
      await tester.pumpAndSettle();

      expect(find.byType(LegalDocumentPage), findsOneWidget);

      // 뒤로 돌아와도 체크 상태는 그대로.
      Navigator.of(tester.element(find.byType(LegalDocumentPage))).pop();
      await tester.pumpAndSettle();
      expect(_checkedCount(tester), 0);
    });

    testWidgets('전체 동의하기를 탭하면 4개 항목이 모두 켜지고, 다시 탭하면 모두 꺼진다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('전체 동의하기'));
      await tester.pumpAndSettle();
      // 전체 동의 행 1 + 개별 4 = 5
      expect(_checkedCount(tester), 5);

      await tester.tap(find.text('전체 동의하기'));
      await tester.pumpAndSettle();
      expect(_checkedCount(tester), 0);
    });

    testWidgets('개별 4개를 모두 켜면 전체 동의도 함께 켜진다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      for (final label in [
        '서비스 이용약관',
        '개인정보 처리방침',
        '위치기반 서비스 약관',
        '마케팅 정보 수신',
      ]) {
        await tester.tap(find.textContaining(label));
        await tester.pumpAndSettle();
      }

      expect(_checkedCount(tester), 5);
    });

    testWidgets('4개 항목 모두 > 로 전문을 열 수 있다 (마케팅 포함)', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final chevrons = find.byIcon(Icons.chevron_right_rounded);
      expect(chevrons, findsNWidgets(4));

      // 마케팅(마지막) 행의 > 도 전문 페이지로 연결된다.
      await tester.tap(chevrons.last);
      await tester.pumpAndSettle();
      expect(find.text('마케팅 정보 수신 동의'), findsOneWidget);
    });
  });
}
