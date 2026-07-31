import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/catalog_item_detail_model.dart';
import '../models/catalog_list_response_model.dart';
import '../models/catalog_summary_model.dart';

part 'catalog_remote_datasource.g.dart';

/// 도감 백엔드 API 클라이언트
///
/// **엔드포인트**:
/// - `GET /api/1/catalog` - 도감 목록 조회 (JWT 필요)
/// - `GET /api/1/catalog/{catalogItemId}` - 도감 상세 조회 (JWT 필요)
/// - `GET /api/1/catalog/summary` - 수집 현황 요약 (JWT 필요)
/// - `POST /api/1/catalog/{catalogItemId}/collect` - 도감 항목 수집 (JWT 필요)
@RestApi()
abstract class CatalogRemoteDataSource {
  factory CatalogRemoteDataSource(Dio dio) = _CatalogRemoteDataSource;

  /// 도감 목록 조회
  ///
  /// 필터 없이 전체를 받는다.
  ///
  /// - 200: 목록 + 수집 개수
  /// - 401: 인증 실패
  @GET(ApiEndpoints.catalog)
  Future<CatalogListResponseModel> getCatalog();

  /// 도감 상세 조회
  ///
  /// - 200: 상세 정보
  /// - 403: 미수집 항목 (앱은 수집한 항목만 호출한다)
  /// - 404: 존재하지 않는 항목
  @GET(ApiEndpoints.catalogDetail)
  Future<CatalogItemDetailModel> getCatalogItem(
    @Path('catalogItemId') String catalogItemId,
  );

  /// 수집 현황 요약 조회
  ///
  /// - 200: 전체·카테고리별 개수와 수집률
  /// - 401: 인증 실패
  @GET(ApiEndpoints.catalogSummary)
  Future<CatalogSummaryModel> getCatalogSummary();

  /// 도감 항목 수집
  ///
  /// - 204: 수집 성공 (본문 없음)
  /// - 404: 존재하지 않는 항목 (CATALOG_ITEM_NOT_FOUND)
  /// - 409: 이미 수집한 항목 (CATALOG_ITEM_ALREADY_COLLECTED)
  @POST(ApiEndpoints.catalogCollect)
  Future<void> collectCatalogItem(@Path('catalogItemId') String catalogItemId);
}
