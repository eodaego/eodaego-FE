import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_summary_entity.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/user/presentation/pages/my_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

// 게스트는 닉네임 변경도, 약관 조회도, 탈퇴도 할 수 없는 계정이 없는 상태다.
// isGuest가 false로 짧은 회로되는 authNotifierProvider는 게스트 경로에서
// 아예 watch되지 않으므로 별도 override가 필요 없다.
//
// MyPage가 watch하는 catalogSummaryProvider용 고정값 — 실 Dio 호출(네트워크 경계)을
// 막는다. 실패 폴백(0)과 구분되도록 0이 아닌 값을 쓴다.
const _fakeCatalogSummary = CatalogSummaryEntity(
  totalCount: 80,
  collectedCount: 24,
  collectionRate: 30,
  collectedByCategory: {
    DogamCategory.animal: 8,
    DogamCategory.plant: 8,
    DogamCategory.place: 8,
  },
  totalByCategory: {
    DogamCategory.animal: 27,
    DogamCategory.plant: 27,
    DogamCategory.place: 26,
  },
);

Widget _wrapGuest() => ProviderScope(
  overrides: [
    guestModeProvider.overrideWith((ref) => true),
    catalogSummaryProvider.overrideWith((ref) => _fakeCatalogSummary),
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
  group('MyPage 게스트 모드', () {
    testWidgets('닉네임 바꾸기, 약관 및 정책, 탈퇴하기를 숨기고 로그인하러 가기만 보여준다', (tester) async {
      _useDesignViewport(tester);
      await tester.pumpWidget(_wrapGuest());
      await tester.pumpAndSettle();

      expect(find.text('닉네임 바꾸기'), findsNothing);
      expect(find.text('약관 및 정책'), findsNothing);
      expect(find.text('탈퇴하기'), findsNothing);
      expect(find.text('로그인하러 가기'), findsOneWidget);
    });
  });
}
