import 'dart:io';

/// 앱 외부 링크 URL. TODO(eodaego): 스토어 App ID·약관 URL 확정 시 교체.
class AppUrls {
  AppUrls._();

  /// 스토어 다운로드 URL (플랫폼별 분기)
  static String get storeUrl {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=com.elipair.eodaego';
    }
    // TODO(eodaego): iOS App Store ID 확정 시 교체
    return 'https://apps.apple.com/app/idTODO';
  }

  // TODO(eodaego): 어대GO 약관/정책 페이지 URL로 교체
  static const String privacyPolicy = 'https://example.com/eodaego/privacy';
  static const String termsOfService = 'https://example.com/eodaego/terms';
  static const String locationTerms = 'https://example.com/eodaego/location';
  static const String marketingConsent = 'https://example.com/eodaego/marketing';
}
