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

  // 약관/정책 페이지 (Google Sites 호스팅)
  static const String privacyPolicy =
      'https://sites.google.com/view/eodaego-pp/%ED%99%88';
  static const String termsOfService =
      'https://sites.google.com/view/eodaego-tos/%ED%99%88';
  static const String locationTerms =
      'https://sites.google.com/view/eodaego-lt/%ED%99%88';

  // TODO(eodaego): 마케팅 수신 동의 페이지 URL 확정 시 교체
  static const String marketingConsent =
      'https://example.com/eodaego/marketing';

  /// 서울어린이대공원 공식 사이트
  static const String parkOfficialSite =
      'https://www.sisul.or.kr/open_content/childrenpark/';
}
