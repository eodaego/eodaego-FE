import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_exception_handler.dart';
import '../../domain/entities/facility_entity.dart';
import '../../domain/repositories/facility_repository.dart';
import '../datasources/facility_remote_datasource.dart';

/// Facility Repository 구현체
class FacilityRepositoryImpl implements FacilityRepository {
  final FacilityRemoteDataSource _dataSource;

  FacilityRepositoryImpl(this._dataSource);

  @override
  Future<List<FacilityEntity>> getFacilities() async {
    try {
      final response = await _dataSource.getFacilities();
      return [
        for (final m in response)
          FacilityEntity(
            id: m.id,
            name: m.name,
            category: m.category,
            latitude: m.latitude,
            longitude: m.longitude,
            facilityType: m.facilityType,
          ),
      ];
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '시설 목록을 불러오지 못했어요.',
        originalException: e,
      );
    }
  }

  @override
  Future<FacilityDetailEntity> getFacility(int id) async {
    try {
      final m = await _dataSource.getFacility(id);
      return FacilityDetailEntity(
        summary: FacilityEntity(
          id: m.id,
          name: m.name,
          category: m.category,
          latitude: m.latitude,
          longitude: m.longitude,
          facilityType: m.facilityType,
        ),
        intro: m.intro,
        description: m.description,
        openTime: m.openTime,
        closeTime: m.closeTime,
        operatingNote: m.operatingNote,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '시설 정보를 불러오지 못했어요.',
        originalException: e,
      );
    }
  }
}
