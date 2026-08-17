import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/course/domain/entities/course_options.dart';
import 'package:flutter_test/flutter_test.dart';

CourseEntity _course({
  List<DogamCategory> places = const [],
  int minutes = 60,
  List<String> tagLabels = const ['동물듬뿍'],
}) {
  return CourseEntity(
    id: 'c1',
    title: '동물 만나러 가는 길',
    tagLabels: tagLabels,
    estimatedDurationMinutes: minutes,
    entrance: ParkGate.mainGate,
    exit: ParkGate.southGate,
    favorite: false,
    places: [
      for (var i = 0; i < places.length; i++)
        CoursePlaceEntity(
          visitOrder: i + 1,
          name: '장소${i + 1}',
          category: places[i],
        ),
    ],
  );
}

void main() {
  group('dominantCategory', () {
    test('picks_the_most_frequent_place_category', () {
      final course = _course(
        places: [
          DogamCategory.animal,
          DogamCategory.place,
          DogamCategory.animal,
        ],
      );
      expect(course.dominantCategory, DogamCategory.animal);
    });

    test('picks_the_earliest_visited_category_when_counts_tie', () {
      // 동률이면 방문 순서가 빠른 쪽 — 코스의 첫인상을 색으로 쓴다.
      final course = _course(
        places: [DogamCategory.plant, DogamCategory.animal],
      );
      expect(course.dominantCategory, DogamCategory.plant);
    });

    test('falls_back_to_place_when_there_are_no_places', () {
      expect(_course().dominantCategory, DogamCategory.place);
    });
  });

  group('durationLabel', () {
    test('renders_whole_hours_without_minutes', () {
      expect(_course(minutes: 120).durationLabel, '약 2시간');
    });

    test('renders_hours_and_minutes', () {
      expect(_course(minutes: 90).durationLabel, '약 1시간 30분');
    });

    test('renders_minutes_only_under_an_hour', () {
      expect(_course(minutes: 40).durationLabel, '약 40분');
    });

    test('renders_minutes_only_when_zero', () {
      expect(_course(minutes: 0).durationLabel, '약 0분');
    });
  });

  group('badgeLabel', () {
    test('uses_the_first_ai_tag', () {
      expect(_course(tagLabels: const ['동물듬뿍', '산책']).badgeLabel, '동물듬뿍');
    });

    test('falls_back_to_the_category_label_when_tags_are_empty', () {
      final course = _course(
        tagLabels: const [],
        places: [DogamCategory.animal],
      );
      expect(course.badgeLabel, DogamCategory.animal.label);
    });
  });

  group('gateLabel', () {
    test('renders_entrance_to_exit', () {
      expect(_course().gateLabel, '정문 → 남문');
    });
  });

  group('copyWith', () {
    test('flips_favorite_without_touching_other_fields', () {
      final course = _course(places: [DogamCategory.animal]);
      final flipped = course.copyWith(favorite: true);
      expect(flipped.favorite, isTrue);
      expect(flipped.id, course.id);
      expect(flipped.places, course.places);
    });
  });

  group('markCollected', () {
    // 코스 응답의 수집 여부는 추천 시점 스냅숏이고 추천은 POST라 다시 못 받는다.
    // 앱 안에서 도감을 모았을 때 지도가 계속 '아직'을 그리지 않게 하는 자리다.
    const linked = CoursePlaceEntity(
      visitOrder: 1,
      name: '음악분수',
      category: DogamCategory.place,
      catalogItemId: 'catalog-1',
    );
    const other = CoursePlaceEntity(
      visitOrder: 2,
      name: '맹수마을',
      category: DogamCategory.animal,
      catalogItemId: 'catalog-2',
    );
    const outsideCatalog = CoursePlaceEntity(
      visitOrder: 3,
      name: '바다동물관',
      category: DogamCategory.animal,
    );

    CourseEntity courseOf(List<CoursePlaceEntity> places) => CourseEntity(
      id: 'c1',
      title: '코스',
      tagLabels: const [],
      estimatedDurationMinutes: 60,
      entrance: ParkGate.mainGate,
      exit: ParkGate.southGate,
      favorite: true,
      places: places,
    );

    test('marks_only_the_place_linked_to_the_collected_catalog_item', () {
      final course = courseOf([linked, other, outsideCatalog]);

      final updated = course.markCollected('catalog-1');

      expect(updated.places[0].collected, isTrue);
      expect(updated.places[1].collected, isFalse);
      expect(updated.places[2].collected, isFalse);
      // 원본은 건드리지 않는다.
      expect(course.places[0].collected, isFalse);
    });

    test('keeps_every_other_field_of_the_marked_place', () {
      final updated = courseOf([linked]).markCollected('catalog-1');
      final place = updated.places.single;

      expect(place.visitOrder, linked.visitOrder);
      expect(place.name, linked.name);
      expect(place.category, linked.category);
      expect(place.catalogItemId, linked.catalogItemId);
      expect(updated.favorite, isTrue);
    });

    test('returns_the_same_course_when_no_place_is_linked_to_it', () {
      // 마커 비트맵은 코스 인스턴스가 바뀌면 전부 다시 굽는다. 퀴즈로 모은
      // 도감이 지금 코스와 무관할 때가 대부분이라 헛돌면 안 된다.
      final course = courseOf([linked, outsideCatalog]);

      expect(identical(course.markCollected('catalog-9'), course), isTrue);
    });

    test('returns_the_same_course_when_the_place_is_already_collected', () {
      final course = courseOf([linked.copyWith(collected: true)]);

      expect(identical(course.markCollected('catalog-1'), course), isTrue);
    });
  });
}
