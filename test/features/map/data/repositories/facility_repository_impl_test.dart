import 'package:dio/dio.dart';
import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/features/map/data/datasources/facility_remote_datasource.dart';
import 'package:eodaego/features/map/data/models/facility_model.dart';
import 'package:eodaego/features/map/data/repositories/facility_repository_impl.dart';
import 'package:eodaego/features/map/domain/entities/facility_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크. 내부 협력자는 전부 실제 코드다.
class _FakeFacilityDataSource implements FacilityRemoteDataSource {
  _FakeFacilityDataSource({this.list = const [], this.detail, this.error});

  final List<FacilityModel> list;
  final FacilityDetailModel? detail;
  final Object? error;

  @override
  Future<List<FacilityModel>> getFacilities() async {
    if (error != null) throw error!;
    return list;
  }

  @override
  Future<FacilityDetailModel> getFacility(int facilityId) async {
    if (error != null) throw error!;
    return detail!;
  }
}

void main() {
  test('getFacilities_maps_all_fields_including_null_coordinates', () async {
    final repository = FacilityRepositoryImpl(
      _FakeFacilityDataSource(
        list: const [
          FacilityModel(
            id: 12,
            category: '편의시설',
            name: '꿈마루',
            latitude: 37.5501,
            longitude: 127.0798,
            facilityType: '문화',
          ),
          FacilityModel(id: 13, category: '출입문', name: '정문'),
        ],
      ),
    );

    final result = await repository.getFacilities();

    expect(result.length, 2);
    expect(result[0].id, 12);
    expect(result[0].name, '꿈마루');
    expect(result[0].latitude, 37.5501);
    expect(result[0].longitude, 127.0798);
    expect(result[0].facilityType, '문화');
    expect(result[0].isGate, isFalse);
    expect(result[1].latitude, isNull);
    expect(result[1].longitude, isNull);
    expect(result[1].isGate, isTrue);
  });

  test('getFacility_maps_intro_and_hours', () async {
    final repository = FacilityRepositoryImpl(
      _FakeFacilityDataSource(
        detail: const FacilityDetailModel(
          id: 12,
          category: '편의시설',
          name: '꿈마루',
          intro: '소개',
          description: '설명',
          openTime: '10:00',
          closeTime: '17:00',
          operatingNote: '매주 월요일 휴관',
        ),
      ),
    );

    final FacilityDetailEntity result = await repository.getFacility(12);

    expect(result.summary.name, '꿈마루');
    expect(result.intro, '소개');
    expect(result.description, '설명');
    expect(result.hoursLabel, '운영 10:00 ~ 17:00');
    expect(result.operatingNote, '매주 월요일 휴관');
  });

  test('getFacilities_converts_dio_error_via_handler', () async {
    final request = RequestOptions(path: '/api/1/facilities');
    final repository = FacilityRepositoryImpl(
      _FakeFacilityDataSource(
        error: DioException(
          requestOptions: request,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: request, statusCode: 404),
        ),
      ),
    );

    expect(repository.getFacilities(), throwsA(isA<AppException>()));
  });
}
