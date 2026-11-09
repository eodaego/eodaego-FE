import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/features/course/domain/entities/course_entity.dart';
import 'package:eodaego/features/map/domain/entities/facility_entity.dart';
import 'package:eodaego/features/map/presentation/map_facility_layer.dart';
import 'package:flutter_test/flutter_test.dart';

const _facilities = [
  FacilityEntity(id: 1, name: '꿈마루', category: '시설'),
  FacilityEntity(id: 2, name: '고객안내센터', category: '편의시설'),
];

const _course = CourseEntity(
  id: 'c',
  title: 'c',
  tagLabels: [],
  estimatedDurationMinutes: 60,
  entrance: null,
  exit: null,
  favorite: false,
  places: [
    CoursePlaceEntity(
      visitOrder: 1,
      name: '꿈마루',
      category: DogamCategory.place,
      facilityId: 1,
    ),
  ],
);

void main() {
  test('visibleFacilities_drops_facilities_already_shown_as_course_places', () {
    final result = visibleFacilities(all: _facilities, course: _course);

    expect(result.map((f) => f.id), [2]);
  });

  test('visibleFacilities_returns_all_when_no_course', () {
    final result = visibleFacilities(all: _facilities, course: null);

    expect(result, _facilities);
  });
}
