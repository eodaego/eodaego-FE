import 'package:dio/dio.dart';
import 'package:eodaego/core/providers/guest_mode_provider.dart';
import 'package:eodaego/features/map/data/datasources/facility_remote_datasource.dart';
import 'package:eodaego/features/map/data/models/facility_model.dart';
import 'package:eodaego/features/map/presentation/providers/facility_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크.
class _FakeFacilityDataSource implements FacilityRemoteDataSource {
  _FakeFacilityDataSource({this.result = const [], this.error});

  final List<FacilityModel> result;
  final Object? error;
  var calls = 0;

  @override
  Future<List<FacilityModel>> getFacilities() async {
    calls++;
    if (error != null) throw error!;
    return result;
  }

  @override
  Future<FacilityDetailModel> getFacility(int facilityId) =>
      throw UnimplementedError();
}

ProviderContainer _container(
  _FakeFacilityDataSource source, {
  bool guest = false,
}) {
  final container = ProviderContainer(
    overrides: [
      facilityRemoteDataSourceProvider.overrideWithValue(source),
      guestRestrictedProvider.overrideWithValue(guest),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('mapFacilities_returns_empty_without_calling_api_for_guest', () async {
    final source = _FakeFacilityDataSource(
      result: const [FacilityModel(id: 1, name: '고객안내센터', category: '편의시설')],
    );

    final result = await _container(
      source,
      guest: true,
    ).read(mapFacilitiesProvider.future);

    expect(result, isEmpty);
    expect(source.calls, 0);
  });

  test('mapFacilities_excludes_gates', () async {
    final source = _FakeFacilityDataSource(
      result: const [
        FacilityModel(id: 1, name: '정문', category: '출입문'),
        FacilityModel(id: 2, name: '고객안내센터', category: '편의시설'),
      ],
    );

    final result = await _container(
      source,
    ).read(mapFacilitiesProvider.future);

    expect(result.map((f) => f.id), [2]);
  });

  test('mapFacilities_returns_empty_when_request_fails', () async {
    final source = _FakeFacilityDataSource(
      error: DioException(requestOptions: RequestOptions(path: '/')),
    );

    final result = await _container(
      source,
    ).read(mapFacilitiesProvider.future);

    expect(result, isEmpty);
  });
}
