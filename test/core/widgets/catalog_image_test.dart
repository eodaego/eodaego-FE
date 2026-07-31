import 'package:cached_network_image/cached_network_image.dart';
import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/widgets/catalog_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

// The network tier's placeholder is AppSkeleton, which reads ScreenUtil
// (`.r`) — needs ScreenUtilInit even though CatalogImage itself takes a raw
// `size` in dp.
// 네트워크 단계의 로딩 표시가 ScreenUtil(`.r`)을 쓰는 AppSkeleton이라
// ScreenUtilInit이 필요하다. CatalogImage 자체는 원시 `size`(dp)를 받는다.
Widget _wrap(Widget child) => ScreenUtilInit(
  designSize: const Size(393, 852),
  builder: (context, _) =>
      MaterialApp(home: Scaffold(body: Center(child: child))),
);

void main() {
  group('CatalogImage', () {
    testWidgets('renders_network_tier_when_image_url_is_present', (
      tester,
    ) async {
      // A single pump (no pumpAndSettle) is deliberate: CachedNetworkImage
      // schedules a real HTTP fetch in the background, and letting the test
      // wait for that to resolve would make it depend on real network I/O.
      // This only proves the routing decision — imageUrl present picks the
      // network tier over the asset/icon tiers — not that the image loads.
      await tester.pumpWidget(
        _wrap(
          const CatalogImage(
            imageUrl: 'https://cdn.eodaego.com/animals/squirrel.png',
            code: 'A001',
            category: DogamCategory.animal,
            size: 56,
          ),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(find.byIcon(DogamCategory.animal.icon), findsNothing);
    });

    testWidgets(
      'falls_to_asset_tier_when_image_url_is_null_but_code_is_present',
      (tester) async {
        // Same reasoning: one pump proves the widget picked the asset tier
        // (code) over the network tier (no imageUrl), without depending on
        // whether the asset file actually exists in the test bundle.
        await tester.pumpWidget(
          _wrap(
            const CatalogImage(
              code: 'A999',
              category: DogamCategory.animal,
              size: 56,
            ),
          ),
        );

        expect(find.byType(CachedNetworkImage), findsNothing);
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is Image &&
                w.image is AssetImage &&
                (w.image as AssetImage).assetName ==
                    'assets/images/catalog/A999.png',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders_category_icon_when_code_points_to_a_missing_asset_file',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const CatalogImage(
              code: 'A999',
              category: DogamCategory.animal,
              size: 56,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(DogamCategory.animal.icon), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('renders_category_icon_when_code_is_null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CatalogImage(
            code: null,
            category: DogamCategory.plant,
            size: 56,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(DogamCategory.plant.icon), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'circle_true_clips_the_fallback_icon_to_an_oval_with_category_tint',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const CatalogImage(
              code: null,
              category: DogamCategory.place,
              size: 56,
              circle: true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ClipOval), findsOneWidget);
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.color, DogamCategory.place.tint);
      },
    );
  });
}
