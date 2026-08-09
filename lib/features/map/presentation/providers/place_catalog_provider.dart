import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/dogam_category.dart';
import '../../../collection/domain/entities/catalog_item_entity.dart';
import '../../../collection/presentation/providers/catalog_provider.dart';

part 'place_catalog_provider.g.dart';

/// 지도 마커 카드가 그릴 도감 상태.
///
/// 두 필드로 세 갈래를 표현한다 — 별도 sealed 계층을 두지 않는다.
///
/// | [collected] | [inCatalog] | 뜻 |
/// | --- | --- | --- |
/// | 있음 | true | 이미 수집했다 — 실사 이미지·도감 코드를 붙이고 상세로 보낸다 |
/// | null | true | 도감에 있지만 아직 안 모았다 — `?`와 촬영 CTA |
/// | null | false | 도감에 없는 시설 — CTA를 띄우면 거짓말이 된다 |
typedef PlaceCatalogStatus = ({CatalogItemEntity? collected, bool inCatalog});

/// 코스 장소 하나를 도감에서 찾는다.
///
/// 서버는 미수집 항목도 이름으로 찾아주되 응답의 `name`을 null로 가린다. 그래서
/// **이름이 채워져 돌아온 항목만이 수집한 항목**이고, 결과가 비었으면 도감에
/// 없는 시설이다(또는 미수집 + SUSPENDED/RETIRED — 어차피 못 모으니 같이 묶는다).
///
/// **주의**: 조회 카테고리는 코스 장소의 카테고리가 **아니라** 항상 `PLACE`다.
/// 백엔드는 AI 시설을 `(PLACE, externalId)`로만 도감에 동기화하고
/// (`CatalogItemService`), 코스 응답의 `category`는 화면 표시용으로 다시 매긴
/// 값이다(`CourseRecommendationService.mapCategory` — 동물나라→ANIMAL,
/// 자연나라→PLANT). 즉 '맹수마을'은 코스에선 ANIMAL이지만 도감에선 PLACE다.
/// 표시용 카테고리로 조회하면 동물·식물 장소가 전부 "도감에 없음"으로 떨어진다.
///
/// **주의**: 서버 검색은 부분 일치라 "식물원"이 "식물원 카페테리아"까지 물어온다.
/// 그래서 수집 판정은 이름 완전 일치로 한 번 더 조인다. 정확한 키
/// (`facilityId` ↔ 도감 `externalId`)는 앱이 쓰는 API에 없어 못 쓴다.
///
/// **주의**: 인자 이름을 `name`으로 두면 riverpod 생성 코드의 provider `name`
/// 필드와 부딪혀 컴파일이 깨진다. 그래서 [placeName]이다.
@riverpod
Future<PlaceCatalogStatus> placeCatalogStatus(
  Ref ref, {
  required String placeName,
}) async {
  final matches = await ref
      .watch(catalogRepositoryProvider)
      .getCatalogItems(category: DogamCategory.place, name: placeName);

  final collected = matches
      .where((item) => item.collected && item.name == placeName)
      .firstOrNull;

  if (kDebugMode) {
    debugPrint(
      '[Map] 🔍 "$placeName" 도감 조회 — ${matches.length}건 매칭, '
      '${collected != null
          ? '수집함'
          : matches.isEmpty
          ? '도감에 없음'
          : '미수집'}',
    );
  }

  return (collected: collected, inCatalog: matches.isNotEmpty);
}
