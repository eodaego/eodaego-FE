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
}
