import 'dart:async';

import 'package:eodaego/features/map/domain/entities/facility_entity.dart';
import 'package:eodaego/features/map/presentation/providers/facility_provider.dart';
import 'package:eodaego/features/map/presentation/widgets/facility_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

const _a = FacilityEntity(id: 1, name: '쉼터', category: '편의시설');
const _b = FacilityEntity(id: 2, name: '매점', category: '편의시설');

Widget _app(Widget child, Map<int, Future<FacilityDetailEntity?>> details) =>
    ProviderScope(
      overrides: [
        facilityDetailProvider(1).overrideWith((ref) => details[1]!),
        facilityDetailProvider(2).overrideWith(
          (ref) => details[2] ?? Future<FacilityDetailEntity?>.value(null),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
      ),
    );

void main() {
  testWidgets('facility_card_shows_intro_and_hours', (tester) async {
    await tester.pumpWidget(
      _app(const FacilityInfoCard(facility: _a), {
        1: Future.value(
          const FacilityDetailEntity(
            summary: _a,
            intro: '공원 안 쉼터예요.',
            openTime: '10:00',
            closeTime: '18:00',
          ),
        ),
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('쉼터'), findsOneWidget);
    expect(find.text('편의시설'), findsOneWidget);
    expect(find.text('공원 안 쉼터예요.'), findsOneWidget);
    expect(find.text('운영 10:00 ~ 18:00'), findsOneWidget);
  });

  testWidgets('facility_card_omits_hours_line_when_unknown', (tester) async {
    await tester.pumpWidget(
      _app(const FacilityInfoCard(facility: _a), {
        1: Future.value(
          const FacilityDetailEntity(summary: _a, intro: '공원 안 쉼터예요.'),
        ),
      }),
    );
    await tester.pumpAndSettle();

    expect(find.text('공원 안 쉼터예요.'), findsOneWidget);
    expect(find.textContaining('운영'), findsNothing);
  });

  testWidgets('facility_card_shows_name_only_when_detail_fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const FacilityInfoCard(facility: _a), {1: Future.value(null)}),
    );
    await tester.pumpAndSettle();

    expect(find.text('쉼터'), findsOneWidget);
    expect(find.text('편의시설'), findsOneWidget);
    expect(find.textContaining('운영'), findsNothing);
  });

  testWidgets(
    'opening_second_facility_before_first_detail_arrives_shows_second_intro',
    (tester) async {
      final first = Completer<FacilityDetailEntity?>();
      final facility = ValueNotifier<FacilityEntity>(_a);
      await tester.pumpWidget(
        _app(
          ValueListenableBuilder(
            valueListenable: facility,
            builder: (_, f, _) => FacilityInfoCard(facility: f),
          ),
          {
            1: first.future,
            2: Future.value(
              const FacilityDetailEntity(summary: _b, intro: '매점 소개예요.'),
            ),
          },
        ),
      );
      await tester.pump();

      facility.value = _b;
      await tester.pumpAndSettle();
      // 뒤늦게 A의 응답이 도착해도 B 카드에는 나타나지 않는다.
      first.complete(
        const FacilityDetailEntity(summary: _a, intro: '쉼터 소개예요.'),
      );
      await tester.pumpAndSettle();

      expect(find.text('매점 소개예요.'), findsOneWidget);
      expect(find.text('쉼터 소개예요.'), findsNothing);
    },
  );
}
