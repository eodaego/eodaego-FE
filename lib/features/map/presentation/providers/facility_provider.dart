import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/guest_mode_provider.dart';
import '../../data/datasources/facility_mock_datasource.dart';
import '../../data/datasources/facility_remote_datasource.dart';
import '../../data/repositories/facility_repository_impl.dart';
import '../../domain/entities/facility_entity.dart';
import '../../domain/repositories/facility_repository.dart';

part 'facility_provider.g.dart';

/// FacilityRemoteDataSource Provider (Retrofit)
///
/// `EnvConfig.useMockData`가 켜지면 [FacilityMockDataSource]로 바뀐다.
@Riverpod(keepAlive: true)
FacilityRemoteDataSource facilityRemoteDataSource(Ref ref) {
  if (EnvConfig.useMockData) {
    debugPrint('[Mock] ✅ 시설 목 데이터 사용');
    return FacilityMockDataSource();
  }
  return FacilityRemoteDataSource(ref.watch(dioProvider));
}

/// FacilityRepository Provider
@Riverpod(keepAlive: true)
FacilityRepository facilityRepository(Ref ref) {
  return FacilityRepositoryImpl(ref.watch(facilityRemoteDataSourceProvider));
}

/// 지도에 그릴 시설 목록.
///
/// 게스트는 API를 부르지 않고 빈 목록이다. 출입문은 제외하며,
/// 실패해도 지도는 떠야 하므로 로그만 남기고 빈 목록을 돌려준다.
@riverpod
Future<List<FacilityEntity>> mapFacilities(Ref ref) async {
  if (ref.watch(guestRestrictedProvider)) return const [];
  try {
    final all = await ref.watch(facilityRepositoryProvider).getFacilities();
    return all.where((f) => !f.isGate).toList();
  } catch (e) {
    debugPrint('[Facility] ❌ 시설 목록 조회 실패: $e');
    return const [];
  }
}

/// 시설 상세. 게스트이거나 실패하면 null.
@riverpod
Future<FacilityDetailEntity?> facilityDetail(Ref ref, int id) async {
  if (ref.watch(guestRestrictedProvider)) return null;
  try {
    return await ref.watch(facilityRepositoryProvider).getFacility(id);
  } catch (e) {
    debugPrint('[Facility] ❌ 시설 상세 조회 실패($id): $e');
    return null;
  }
}
