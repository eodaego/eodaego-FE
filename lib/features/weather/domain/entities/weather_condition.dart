/// 하늘 상태 — 서버가 한글 문자열로 준다.
///
/// **주의**: 실제 응답에서 확인된 값은 `맑음`·`구름많음` 두 개뿐이다.
/// `흐림`은 기상청 SKY 코드 표준 표기를 따른 추정이다. 표기가 다르면
/// [fromServer]가 null을 돌려주고 화면은 서버 원문을 그대로 보여준다.
enum WeatherSky {
  clear('맑음', '맑음'),
  partlyCloudy('구름많음', '구름많음'),
  cloudy('흐림', '흐림');

  const WeatherSky(this.label, this.serverValue);

  final String label;
  final String serverValue;

  /// 서버 하늘 상태 문자열을 enum으로 변환한다.
  ///
  /// Returns: 매칭되는 [WeatherSky], 알 수 없는 값이면 null
  static WeatherSky? fromServer(String? value) {
    for (final sky in WeatherSky.values) {
      if (sky.serverValue == value) return sky;
    }
    return null;
  }
}

/// 강수 형태 — 서버가 한글 문자열로 준다.
///
/// **주의**: 실제 응답에서 확인된 값은 `없음` 하나뿐이다. 나머지는 기상청
/// PTY 코드 표준 표기를 따른 추정이다.
enum WeatherPrecipitation {
  none('없음', '없음'),
  rain('비', '비'),
  sleet('비/눈', '비/눈'),
  snow('눈', '눈'),
  shower('소나기', '소나기');

  const WeatherPrecipitation(this.label, this.serverValue);

  final String label;
  final String serverValue;

  /// 실제로 무언가 내리고 있는지. `없음`만 false다.
  ///
  /// 라벨과 아이콘이 강수에서 하늘 상태로 넘어가는 기준이 된다.
  bool get isFalling => this != WeatherPrecipitation.none;

  /// 서버 강수 형태 문자열을 enum으로 변환한다.
  ///
  /// Returns: 매칭되는 [WeatherPrecipitation], 알 수 없는 값이면 null
  static WeatherPrecipitation? fromServer(String? value) {
    for (final type in WeatherPrecipitation.values) {
      if (type.serverValue == value) return type;
    }
    return null;
  }
}
