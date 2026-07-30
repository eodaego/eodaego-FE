import '../../../../core/mock/mock_asset_loader.dart';
import '../../../../core/utils/kst_clock.dart';
import '../models/weather_model.dart';
import 'weather_remote_datasource.dart';

/// 목 날씨 데이터소스
///
/// `assets/mock/weather_current.json`을 읽어 오늘 날짜로 옮긴 뒤 돌려준다.
/// `EnvConfig.useMockData`가 켜졌을 때 [WeatherRemoteDataSource] 대신 쓰인다
/// (분기는 `weather_provider.dart`에서 한다).
class WeatherMockDataSource implements WeatherRemoteDataSource {
  static const _asset = 'assets/mock/weather_current.json';

  @override
  Future<WeatherModel> getCurrentWeather() async {
    final json = await loadMockJson(_asset);
    return WeatherModel.fromJson(_shiftToToday(json));
  }

  /// 픽스처의 모든 시각 필드를 오늘 기준으로 민다.
  ///
  /// 앵커는 `hourlyForecast[0].datetime`의 날짜다. 슬롯이 비어 있으면
  /// 앵커를 구할 수 없으므로 시프트 없이 원본을 그대로 돌려준다(방어).
  Map<String, dynamic> _shiftToToday(Map<String, dynamic> json) {
    final forecast = json['hourlyForecast'] as List? ?? const [];
    if (forecast.isEmpty) return json;

    final anchorIso =
        (forecast.first as Map<String, dynamic>)['datetime'] as String?;
    final anchor = DateTime.tryParse(anchorIso ?? '');
    if (anchor == null) return json;

    final days = dayShiftFrom(anchor: anchor, today: nowKst());

    return {
      ...json,
      'hourlyForecast': [
        for (final slot in forecast)
          {
            ...slot as Map<String, dynamic>,
            'datetime': shiftIsoDays(slot['datetime'] as String?, days),
          },
      ],
      'observedAt': shiftIsoDays(json['observedAt'] as String?, days),
      'collectedAt': shiftIsoDays(json['collectedAt'] as String?, days),
    };
  }
}
