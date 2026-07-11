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
  /// API 연동 시 Repository provider에서 목/실 구현체 분기에 사용한다.
  static bool get useMockData {
    return dotenv.env['USE_MOCK_DATA']?.toLowerCase() == 'true';
  }
}
