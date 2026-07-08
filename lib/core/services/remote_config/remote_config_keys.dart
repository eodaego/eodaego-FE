/// Firebase Remote Config 파라미터 키 및 fail-safe 기본값.
///
/// Firebase 콘솔에 아래 5개 파라미터를 동일한 키로 생성해야 한다.
/// (AdMob 미사용 — `ads_enabled` 제외)
class RemoteConfigKeys {
  RemoteConfigKeys._();

  /// 최소 허용 버전 (String)
  static const String minimumVersion = 'minimum_version';

  /// 최신 버전 (String, 권고 업데이트용)
  static const String latestVersion = 'latest_version';

  /// 강제 업데이트 여부 (bool)
  static const String forceUpdate = 'force_update';

  /// 서버 점검 모드 (bool)
  static const String maintenance = 'maintenance';

  /// 점검 안내 메시지 (String)
  static const String maintenanceMessage = 'maintenance_message';
}

/// Remote Config fetch 실패 시 사용하는 fail-safe 기본값.
class RemoteConfigDefaults {
  RemoteConfigDefaults._();

  static const Map<String, Object> values = {
    RemoteConfigKeys.minimumVersion: '1.0.0',
    RemoteConfigKeys.latestVersion: '1.0.0',
    RemoteConfigKeys.forceUpdate: false,
    RemoteConfigKeys.maintenance: false,
    RemoteConfigKeys.maintenanceMessage: '',
  };
}
