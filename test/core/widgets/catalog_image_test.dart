import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/widgets/catalog_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('CatalogImage', () {
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
