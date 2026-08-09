import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_message_keys.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_exception_handler.dart';
import '../../../../core/utils/kst_clock.dart';
import '../../domain/entities/congestion_entity.dart';
import '../../domain/entities/weather_condition.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

/// Weather Repository 구현체
///
/// [WeatherRemoteDataSource]를 통해 백엔드 날씨 API를 호출한다.
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _dataSource;

  WeatherRepositoryImpl(this._dataSource);

  @override
  Future<WeatherEntity> getCurrentWeather() async {
    try {
      final dto = await _dataSource.getCurrentWeather();

      final forecast = <HourlyForecastEntity>[];
      // Slots whose timestamp cannot be read have no place on the list.
      // 시각을 못 읽은 예보는 목록에 놓을 자리가 없다. 개수만 모아 한 번 찍는다.
      var unreadable = 0;
      for (final hour in dto.hourlyForecast) {
        final at = parseKstDateTime(hour.datetime);
        if (at == null) {
          unreadable++;
          continue;
        }
        forecast.add(
          HourlyForecastEntity(
            dateTime: at,
            temperature: hour.temperature,
            precipitationProbability: hour.precipitationProbability,
            skyLabel: hour.skyCondition,
            precipitationLabel: hour.precipitationType,
            sky: WeatherSky.fromServer(hour.skyCondition),
            precipitation: WeatherPrecipitation.fromServer(
              hour.precipitationType,
            ),
          ),
        );
      }

      if (unreadable > 0) {
        debugPrint('[Weather] ⚠️ 예보 시각을 읽지 못해 $unreadable건 제외');
      }

      if (kDebugMode) {
        debugPrint(
          '[Weather] ✅ 현재 ${dto.skyCondition} ${dto.temperature}° '
          '/ 예보 ${forecast.length}건',
        );
      }

      return WeatherEntity(
        temperature: dto.temperature,
        humidity: dto.humidity,
        windSpeed: dto.windSpeed,
        skyLabel: dto.skyCondition,
        precipitationLabel: dto.precipitationType,
        sky: WeatherSky.fromServer(dto.skyCondition),
        precipitation: WeatherPrecipitation.fromServer(dto.precipitationType),
        observedAt: parseKstDateTime(dto.observedAt),
        hourlyForecast: forecast,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '날씨를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorWeatherUnexpected,
        originalException: e,
      );
    }
  }

  @override
  Future<CongestionEntity> getCurrentCongestion() async {
    try {
      final dto = await _dataSource.getCurrentCongestion();
      final level = CongestionLevel.fromServer(dto.level);

      if (level == null && dto.level != null) {
        debugPrint('[Congestion] ⚠️ 알 수 없는 등급: ${dto.level} — 라벨만 표시');
      }

      if (kDebugMode) {
        debugPrint('[Congestion] ✅ ${dto.label} (${dto.level})');
      }

      return CongestionEntity(
        level: level,
        label: dto.label,
        collectedAt: parseKstDateTime(dto.collectedAt),
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '혼잡도를 불러오지 못했어요.',
        messageKey: AppMessageKeys.errorCongestionUnexpected,
        originalException: e,
      );
    }
  }
}
