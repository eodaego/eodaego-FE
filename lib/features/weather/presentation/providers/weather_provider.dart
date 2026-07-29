import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/weather_remote_datasource.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';

part 'weather_provider.g.dart';

// ============================================
// Data Layer Providers
// ============================================

/// WeatherRemoteDataSource Provider (Retrofit)
@riverpod
WeatherRemoteDataSource weatherRemoteDataSource(Ref ref) {
  return WeatherRemoteDataSource(ref.watch(dioProvider));
}

/// WeatherRepository Provider
@riverpod
WeatherRepository weatherRepository(Ref ref) {
  return WeatherRepositoryImpl(ref.watch(weatherRemoteDataSourceProvider));
}

// ============================================
// Presentation Providers (조회)
// ============================================

/// 현재 날씨. 홈 상단 바와 날씨 상세 화면이 함께 본다.
///
/// **주의**: 상세는 홈에서 push라 홈이 스택에 남는다. 같은 provider를 보므로
/// 상세로 들어갈 때 재요청이 나가지 않는다.
@riverpod
Future<WeatherEntity> currentWeather(Ref ref) {
  return ref.watch(weatherRepositoryProvider).getCurrentWeather();
}
