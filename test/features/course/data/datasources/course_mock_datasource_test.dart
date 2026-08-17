import 'package:eodaego/features/course/data/datasources/course_mock_datasource.dart';
import 'package:eodaego/features/course/data/models/course_model.dart';
import 'package:eodaego/features/course/data/models/course_recommendation_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// 목 코스 픽스처가 지도 화면이 기대하는 모양을 갖췄는지 본다.
///
/// `json_serializable`은 모르는 키를 조용히 버린다. 그래서 픽스처에 `catalogItemId`를
/// `catalogItemld`(소문자 L)로 잘못 적어도 어디서도 터지지 않고, 모든 장소가 '도감에
/// 없는 시설'로 주저앉는다. 목 모드로 화면을 열어 보기 전에는 알 수 없는 종류의
/// 고장이라 여기서 못 박는다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final dataSource = CourseMockDataSource();

  Future<List<CoursePlaceModel>> allPlaces() async {
    final courses = await dataSource.recommendCourses(
      const CourseRecommendationRequestModel(
        entrance: 'MAIN_GATE',
        exit: 'SOUTH_GATE',
      ),
    );
    return [for (final course in courses) ...course.places];
  }

  group('목 코스 픽스처', () {
    test('covers_all_three_catalog_states_across_its_places', () async {
      final places = await allPlaces();

      expect(
        places.where((p) => p.collected),
        isNotEmpty,
        reason: '수집한 장소가 없으면 목 모드에서 ① 카드를 볼 수 없다',
      );
      expect(
        places.where((p) => p.catalogItemId != null && !p.collected),
        isNotEmpty,
        reason: '미수집 장소가 없으면 촬영 CTA를 볼 수 없다',
      );
      expect(
        places.where((p) => p.catalogItemId == null),
        isNotEmpty,
        reason: '도감에 없는 장소가 없으면 ③ 짧은 카드를 볼 수 없다',
      );
    });

    test('gives_the_same_place_name_one_catalog_item_id_everywhere', () async {
      // 같은 장소가 코스마다 다른 도감 항목을 가리키면 체크가 코스별로 엇갈린다.
      final byName = <String, Set<String?>>{};
      for (final place in await allPlaces()) {
        byName
            .putIfAbsent(place.name, () => <String?>{})
            .add(place.catalogItemId);
      }

      final inconsistent = byName.entries.where((e) => e.value.length > 1);
      expect(inconsistent.map((e) => e.key), isEmpty);
    });

    test('puts_at_least_one_collected_place_on_the_real_map', () async {
      // 좌표 없는 장소는 실제 지도에 마커가 뜨지 않는다(서버도 null을 줄 수 있어
      // 정상이다). 다만 수집 체크를 실제 지도에서 확인하려면 좌표까지 갖춘
      // 수집 장소가 최소 하나는 있어야 한다 — 예전엔 픽스처 전체에 좌표가 없어
      // 실제 지도 모드에 코스 마커가 단 하나도 뜨지 않았다.
      final places = await allPlaces();

      expect(
        places.where(
          (p) => p.collected && p.latitude != null && p.longitude != null,
        ),
        isNotEmpty,
      );
    });
  });
}
