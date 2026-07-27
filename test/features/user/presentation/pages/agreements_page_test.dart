import 'dart:async';

import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/core/widgets/pages/legal_document_page.dart';
import 'package:eodaego/features/user/domain/entities/agreement_status_entity.dart';
import 'package:eodaego/features/user/domain/repositories/user_repository.dart';
import 'package:eodaego/features/user/presentation/pages/agreements_page.dart';
import 'package:eodaego/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUserRepository implements UserRepository {
  _FakeUserRepository({
    this.marketing = false,
    this.updateFailure,
    this.getFailure,
    this.updateGate,
  });

  final bool marketing;
  final AppException? updateFailure;
  final AppException? getFailure;

  /// non-null이면 updateAgreements가 이 Completer가 완료될 때까지 멈춰
  /// 있는다 — 저장이 "진행 중"인 상태를 테스트에서 붙잡아 두기 위함.
  final Completer<void>? updateGate;

  final List<bool> updateCalls = [];

  @override
  Future<AgreementStatusEntity> getAgreements() async {
    if (getFailure != null) throw getFailure!;
    return AgreementStatusEntity(
      termsOfService: true,
      privacyPolicy: true,
      locationTerms: true,
      marketing: marketing,
      termsAgreedAt: '2026-07-12T10:00:00+09:00',
      marketingAgreedAt: marketing ? '2026-07-20T09:30:00+09:00' : null,
    );
  }

  @override
  Future<void> updateAgreements({required bool marketing}) async {
    updateCalls.add(marketing);
    if (updateGate != null) await updateGate!.future;
    if (updateFailure != null) throw updateFailure!;
  }

  @override
  Future<String> updateNickname(String nickname) async => nickname;

  @override
  Future<bool> isNicknameAvailable(String nickname) async => true;

  @override
  Future<void> deleteAccount() async {}
}

Widget _wrap(_FakeUserRepository repo) => ProviderScope(
  overrides: [userRepositoryProvider.overrideWith((ref) => repo)],
  child: ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (context, _) => const MaterialApp(home: AgreementsPage()),
  ),
);

void _useDesignViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('AgreementsPage', () {
    testWidgets('약관 4종과 필수 동의 일시를 보여준다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeUserRepository()));
      await tester.pumpAndSettle();

      expect(find.text('서비스 이용약관'), findsOneWidget);
      expect(find.text('개인정보 처리방침'), findsOneWidget);
      expect(find.text('위치기반 서비스 약관'), findsOneWidget);
      expect(find.text('마케팅 정보 수신'), findsOneWidget);
      expect(find.textContaining('2026.07.12'), findsWidgets);
    });

    testWidgets('약관 행을 누르면 전문 페이지가 열린다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrap(_FakeUserRepository()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('서비스 이용약관'));
      await tester.pumpAndSettle();

      expect(find.byType(LegalDocumentPage), findsOneWidget);
    });

    testWidgets('마케팅을 켜면 서버에 true를 저장한다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository(marketing: false);
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(repo.updateCalls, [true]);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
      expect(find.byType(LegalDocumentPage), findsNothing);
    });

    testWidgets('마케팅 저장에 실패하면 토글이 이전 값으로 돌아간다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository(
        marketing: false,
        updateFailure: const NetworkException(message: '연결 실패'),
      );
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(repo.updateCalls, [true]);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
      expect(find.byType(LegalDocumentPage), findsNothing);

      // 실패 시 뜨는 스낵바의 3초 자동 dismiss 타이머를 흘려보내
      // "Timer is still pending" 프레임워크 assertion을 피한다.
      // (test/features/user/presentation/pages/my_page_delete_account_test.dart와 동일한 shape)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('마케팅 저장이 진행 중일 때 스위치를 다시 눌러도 약관 전문이 열리지 않는다', (tester) async {
      _useDesignViewport(tester);
      final gate = Completer<void>();
      final repo = _FakeUserRepository(marketing: false, updateGate: gate);
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // 첫 탭 — 저장을 시작하지만 gate가 열리기 전까지 완료되지 않는다.
      await tester.tap(find.byType(Switch));
      await tester.pump();

      // 저장이 "진행 중"인 동안 같은 스위치를 다시 탭한다. 예전엔 비활성화된
      // Switch가 제스처를 흡수하지 못해 조상 InkWell로 새어나가 전문이 열렸다.
      // (라우트 전환은 pump() 한 번으로 트리에 반영되지 않아 pumpAndSettle 필요)
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.byType(LegalDocumentPage), findsNothing);

      gate.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('약관 조회에 실패하면 에러 화면과 다시 시도 버튼을 보여준다', (tester) async {
      _useDesignViewport(tester);
      final repo = _FakeUserRepository(
        getFailure: const NetworkException(message: '연결 실패'),
      );
      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.text('약관을 불러오지 못했어요'), findsOneWidget);
      expect(find.text('다시 시도'), findsOneWidget);
      expect(find.text('서비스 이용약관'), findsNothing);
    });
  });
}
