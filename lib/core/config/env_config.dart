/// 환경 변수 설정. 사용: `await EnvConfig.initialize(); final url = EnvConfig.apiBaseUrl;`
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  /// .env 파일 초기화 (main()에서 호출 필수)
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }

  /// 백엔드 API 기본 URL. 미설정 시 `http://localhost:8080`.
  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080';
  }

  /// 목 데이터 사용 여부. 미설정 시 false(실 데이터) — CI/프로덕션 안전 기본값.
  /// true일 때: 날씨·도감이 assets/mock/*.json에서 읽고, 게스트 브라우징 제한이 해제된다.
  /// false일 때: 실 API를 호출한다. 퀴즈·코스·즐겨찾기는 플래그와 무관하다.
  static bool get useMockData {
    return dotenv.env['USE_MOCK_DATA']?.toLowerCase() == 'true';
  }
}
