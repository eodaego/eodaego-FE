# cops_and_robbers → 어대GO 선별 포팅 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** cops_and_robbers의 검증된 인증·네트워크·인프라 코드를 어대GO(빈 스캐폴드)로 선별 포팅하여, 앱이 부팅되어 로그인 화면까지 도달하는 Clean Architecture 기반을 만든다.

**Architecture:** Feature-First + Clean Architecture. `lib/core`(인프라) + `lib/features/{auth,user}`(인증) + `lib/router`(라우팅). 대부분 파일은 소스에서 verbatim 복사 후 패키지명만 치환하고, game/session에 결합된 파일(`auth_provider`, `app_router`, `main`, `route_paths`)만 재작성한다.

**Tech Stack:** Flutter 3.9.2+, Riverpod(코드생성), Freezed, Retrofit/Dio, firebase_auth/messaging/remote_config/crashlytics, flutter_secure_storage, go_router, flutter_screenutil, flutter_dotenv.

## Global Constraints

- **패키지명**: 대상 앱은 `eodaego`. 복사한 모든 파일의 `package:cops_and_robbers/` → `package:eodaego/`로 치환한다. 상대 import(`../`)는 그대로 둔다.
- **소스 경로**: `SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers`. 대상 경로는 `/Users/luca/workspace/Flutter_Project/eodaego`(현재 작업 디렉토리).
- **코드 생성 파일 복사 금지**: `*.g.dart` / `*.freezed.dart`는 절대 복사하지 않는다(소스가 `cops_and_robbers`를 참조함). 소스 `.dart`만 복사 → 패키지명 치환 → `dart run build_runner build --delete-conflicting-outputs`로 재생성한다.
- **디자인 시스템**: 색/타이포/스페이싱은 `.claude/rules/UI_Design_System.md`의 토큰만 사용. `Color(0xFF..)` 하드코딩·`Colors.*`·`withOpacity` 금지.
- **에러 처리**: try-catch + `AppException` 하위 타입. Either/dartz 금지.
- **커밋 규칙**: Co-Authored-By 태그 금지. conventional commit(`feat:`/`chore:`/`refactor:` 등).
- **제외 범위**: STOMP/WebSocket, game/session/chat/lobby/notice/settings/report/bug/credits/tutorial feature, deeplink, analytics, lifecycle, i18n(l10n), ads, app_icon, locale, vibration, `token_provider`. 필요해지면 추후 동일 방식으로 포팅.
- **검증**: 각 Task 종료 시 `flutter analyze`가 **에러 0**(기존 info/warning 무방)이어야 하고, 코드생성 대상이 있으면 build_runner가 성공해야 한다.

---

## 파일 구조 (최종)

```
lib/
├── core/
│   ├── config/env_config.dart
│   ├── constants/{app_colors,text_styles,spacing_and_radius,api_endpoints}.dart
│   ├── errors/app_exception.dart
│   ├── network/{api_error_response,dio_exception_handler,auth_interceptor,dio_client,connectivity_service}.dart
│   ├── services/
│   │   ├── fcm/{firebase_messaging_service,local_notifications_service}.dart
│   │   ├── device/{device_id_manager,device_info_service}.dart
│   │   ├── location/device_location_service.dart
│   │   ├── permission/{location_permission_service,location_permission_messages}.dart
│   │   └── remote_config/{remote_config_service,app_version_checker,update_dialog_helper}.dart
│   ├── storage/secure_token_storage.dart
│   └── widgets/
│       ├── dialogs/app_dialog.dart
│       └── pages/{force_update_page,maintenance_page}.dart
├── features/
│   ├── auth/{data,domain}/**  + presentation/{providers/{auth_provider,agreement_provider},pages/*,widgets/*}
│   └── user/{data,domain}/**  + presentation/providers/user_provider.dart
├── router/{app_router,route_paths}.dart
└── main.dart
```

---

## Task 1: 기반 상수 · config · errors · utils · .env

**Files:**
- Create: `lib/core/constants/app_colors.dart`, `lib/core/constants/spacing_and_radius.dart`, `lib/core/constants/text_styles.dart`, `lib/core/constants/api_endpoints.dart`, `lib/core/constants/app_urls.dart`
- Create: `lib/core/config/env_config.dart`, `lib/core/errors/app_exception.dart`, `lib/core/utils/url_launcher_util.dart`
- Create: `.env` (gitignore 대상), 수정: `.env.example`

**Interfaces:**
- Produces: `AppColors.{primary,primaryDark,primaryTint,animal,plant,place,reward,canvas,surface,surfaceDim,ink,muted,disabled,uncollected,onPrimary,line,danger,...}` (모두 `static const Color`); `AppSpacing.{xs,sm,md,base,lg,xl,xxl}`, `AppRadius.{xs,sm,md,lg,xl,full}` (모두 `double`); `AppTextStyles.{display34,display26,display24,display22,display19,display17,display16,body17,body15,label16Semibold,caption14,tag13Bold,tag12Bold}` (모두 `TextStyle get`); `EnvConfig.initialize()`/`EnvConfig.apiBaseUrl`; `AppException`+하위(`NetworkException,AuthException,AuthCancelledException,ValidationException,ServerException,DatabaseException,WebSocketException,LocationException,GameException`); `ApiEndpoints.{baseUrl,login,logout,reissue,myPage,deleteAccount,updateNickname,checkNickname,agreements}`; `AppUrls.{storeUrl,privacyPolicy,termsOfService,locationTerms,marketingConsent}`; `launchExternalUrl(String)→Future<bool>`.

- [ ] **Step 1: app_colors.dart 작성** (디자인 시스템 YAML 그대로 전사)

```dart
import 'package:flutter/painting.dart';

/// 어대GO 색상 팔레트 — `.claude/rules/UI_Design_System.md` 정본.
/// 단일 라이트 테마(웜 아이보리 캔버스). `Color(0xFF..)` 직접 사용 금지, 이 상수만 참조.
class AppColors {
  AppColors._();

  // Brand / Category
  static const Color primary = Color(0xFF3DA35D);
  static const Color primaryDark = Color(0xFF1E6B3C);
  static const Color primaryTint = Color(0xFFE6F4EA);
  static const Color animal = Color(0xFFF58A3C);
  static const Color animalDark = Color(0xFF5C2A08);
  static const Color animalTint = Color(0xFFFEF0E4);
  static const Color plant = Color(0xFF3DA35D);
  static const Color plantDark = Color(0xFF1E6B3C);
  static const Color plantTint = Color(0xFFE6F4EA);
  static const Color place = Color(0xFF4A9FE8);
  static const Color placeDark = Color(0xFF0A3A63);
  static const Color placeTint = Color(0xFFE8F3FC);
  static const Color reward = Color(0xFFFFC93C);
  static const Color rewardDark = Color(0xFF5F4400);

  // Canvas / Surface
  static const Color canvas = Color(0xFFFAF7F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFF0EDE4);
  static const Color cameraBg = Color(0xFF20241F);

  // Ink / Text
  static const Color ink = Color(0xFF2B2B28);
  static const Color muted = Color(0xFF6B6A64);
  static const Color disabled = Color(0xFF9B998F);
  static const Color uncollected = Color(0xFFB9B6AC);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Border / Semantic
  static const Color line = Color(0xFFEBE7DC);
  static const Color danger = Color(0xFFA32D2D);
}
```

- [ ] **Step 2: spacing_and_radius.dart 작성**

```dart
/// 어대GO 스페이싱/래디우스 스케일 — `.claude/rules/UI_Design_System.md` 정본.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20; // 화면 좌우 기본 패딩
  static const double xl = 24;
  static const double xxl = 32;
}

/// 규칙: 외부 radius = 내부 radius × 2, 패딩 = 내부 radius.
class AppRadius {
  AppRadius._();
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double full = 999;
}
```

- [ ] **Step 3: text_styles.dart 작성** (Cafe24Ssurround = display, Pretendard = body)

```dart
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 어대GO 타이포 — `.claude/rules/UI_Design_System.md` 정본.
/// weight/fontSize/fontFamily는 이 파일에서만 정의. copyWith로 color/decoration만 변경 허용.
class AppTextStyles {
  AppTextStyles._();

  static const String _display = 'Cafe24Ssurround';
  static const String _body = 'Pretendard';

  // Display (Cafe24Ssurround)
  static TextStyle get display34 => TextStyle(fontFamily: _display, fontSize: 34.sp, height: 1.2);
  static TextStyle get display26 => TextStyle(fontFamily: _display, fontSize: 26.sp, height: 1.25);
  static TextStyle get display24 => TextStyle(fontFamily: _display, fontSize: 24.sp, height: 1.35);
  static TextStyle get display22 => TextStyle(fontFamily: _display, fontSize: 22.sp, height: 1.4);
  static TextStyle get display19 => TextStyle(fontFamily: _display, fontSize: 19.sp, height: 1.3);
  static TextStyle get display17 => TextStyle(fontFamily: _display, fontSize: 17.sp, height: 1.0);
  static TextStyle get display16 => TextStyle(fontFamily: _display, fontSize: 16.sp, height: 1.0);

  // Body (Pretendard)
  static TextStyle get body17 => TextStyle(fontFamily: _body, fontWeight: FontWeight.w500, fontSize: 17.sp, height: 1.65, letterSpacing: -0.32);
  static TextStyle get body15 => TextStyle(fontFamily: _body, fontWeight: FontWeight.w500, fontSize: 15.sp, height: 1.6, letterSpacing: -0.32);
  static TextStyle get label16Semibold => TextStyle(fontFamily: _body, fontWeight: FontWeight.w600, fontSize: 16.sp, height: 1.0, letterSpacing: -0.32);
  static TextStyle get caption14 => TextStyle(fontFamily: _body, fontWeight: FontWeight.w500, fontSize: 14.sp, height: 1.4, letterSpacing: -0.32);
  static TextStyle get tag13Bold => TextStyle(fontFamily: _body, fontWeight: FontWeight.w700, fontSize: 13.sp, height: 1.0, letterSpacing: -0.32);
  static TextStyle get tag12Bold => TextStyle(fontFamily: _body, fontWeight: FontWeight.w700, fontSize: 12.sp, height: 1.0, letterSpacing: -0.32);
}
```

- [ ] **Step 4: env_config.dart 작성** (cops 원본에서 `webSocketUrl` getter 제거)

```dart
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
}
```

- [ ] **Step 5: app_exception.dart 복사** (verbatim, cops 원본이 l10n을 import하지 않으므로 그대로)

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/core/errors
cp "$SRC/lib/core/errors/app_exception.dart" lib/core/errors/app_exception.dart
```
(이 파일은 `package:cops_and_robbers`를 import하지 않으므로 치환 불필요.)

- [ ] **Step 6: api_endpoints.dart 작성** (auth + user 엔드포인트만, ws/game 전부 제거)

```dart
/// API 엔드포인트 중앙 관리.
/// TODO(backend): 어대GO 백엔드 API 계약 확정 시 경로/스키마 교체 필요.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String reissue = '/api/auth/reissue';

  // User
  static const String myPage = '/api/user/me';
  static const String deleteAccount = '/api/user/me';
  static const String updateNickname = '/api/user/me/nickname';
  static const String checkNickname = '/api/user/check-nickname';
  static const String agreements = '/api/user/agreements';
}
```

- [ ] **Step 7: url_launcher_util.dart 복사** (verbatim — url_launcher 패키지만 의존, clean)

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/core/utils
cp "$SRC/lib/core/utils/url_launcher_util.dart" lib/core/utils/url_launcher_util.dart
```
(이 파일은 `package:cops_and_robbers`를 import하지 않으므로 치환 불필요.)

- [ ] **Step 8: app_urls.dart 작성** (어대GO 값 — 스토어 URL은 확정 전 TODO)

```dart
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
```

- [ ] **Step 9: 검증**

Run: `flutter analyze lib/core/constants lib/core/config lib/core/errors lib/core/utils`
Expected: `No issues found!` (또는 에러 0)

- [ ] **Step 10: .env / .env.example 정비**

Run:
```bash
printf '# 백엔드 API URL\nAPI_BASE_URL=http://localhost:8080\n' > .env.example
cp .env.example .env
grep -q '^\.env$' .gitignore || printf '\n.env\n' >> .gitignore
```

- [ ] **Step 11: Commit**

```bash
git add lib/core/constants lib/core/config lib/core/errors lib/core/utils .env.example .gitignore
git commit -m "feat: 어대GO 기반 상수·config·errors·utils 포팅 (디자인 토큰 + env + AppException + URL)"
```

---

## Task 2: 네트워크 · 스토리지 계층 + 테스트

**Files:**
- Create(verbatim+rename): `lib/core/network/{api_error_response,dio_exception_handler,auth_interceptor,dio_client,connectivity_service}.dart`, `lib/core/storage/secure_token_storage.dart`
- Create(test verbatim+rename): `test/core/network/{auth_interceptor_retry_test,dio_exception_handler_test,api_error_response_test,network_failure_detector_test,connectivity_service_test}.dart` → 존재하는 것만, `test/core/storage/secure_token_storage_is_new_user_test.dart`

**Interfaces:**
- Consumes: `EnvConfig.apiBaseUrl`, `ApiEndpoints.{login,reissue,checkNickname}`, `AppException` 하위(Task 1).
- Produces: `secureTokenStorageProvider`(keepAlive), `SecureTokenStorage` (메서드: `saveTokens({accessToken,refreshToken})`, `saveUserId(int)`, `saveIsNewUser(bool)`, `getAccessToken()`, `getRefreshToken()`, `getUserId()`, `getIsNewUser()`, `clearTokens()`, `hasTokens()`, `clearTokensIfReinstalled()`); `dioProvider`(keepAlive, `Dio`), `forceLogoutMessageKeyProvider`(StateProvider<String?>), `forceLogoutCallbackNotifierProvider`(+`.register(fn)`/`.unregister()`), `ForceLogoutFn = Future<void> Function({String? messageKey})`; `DioExceptionHandler.handle(DioException)→AppException`; `ApiErrorResponse.tryParse(data)`; `connectivityServiceProvider`(+`.isConnected()`).

- [ ] **Step 1: 소스 파일 복사 + 패키지명 치환**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/core/network lib/core/storage
for f in network/api_error_response network/dio_exception_handler network/auth_interceptor \
         network/dio_client network/connectivity_service network/network_failure_detector \
         storage/secure_token_storage; do
  cp "$SRC/lib/core/$f.dart" "lib/core/$f.dart"
done
# 패키지명 치환 (상대 import는 영향 없음)
grep -rl 'package:cops_and_robbers/' lib/core/network lib/core/storage \
  | xargs sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
```
(참고: `dio_client.dart`/`secure_token_storage.dart`는 `part '*.g.dart'`를 선언하므로 build_runner 필요. `connectivity_service.dart`가 `network_failure_detector.dart`에 의존하므로 함께 복사.)

- [ ] **Step 2: 코드 생성**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `Succeeded` — `lib/core/network/dio_client.g.dart`, `lib/core/storage/secure_token_storage.g.dart` 생성됨.

- [ ] **Step 3: 관련 테스트 복사 + 치환**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p test/core/network test/core/storage
for t in network/auth_interceptor_retry_test network/dio_exception_handler_test \
         network/api_error_response_test network/network_failure_detector_test \
         network/connectivity_service_test storage/secure_token_storage_is_new_user_test; do
  [ -f "$SRC/test/core/$t.dart" ] && cp "$SRC/test/core/$t.dart" "test/core/$t.dart"
done
grep -rl 'package:cops_and_robbers/' test/core 2>/dev/null \
  | xargs -r sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
```

- [ ] **Step 4: 테스트 실행**

Run: `flutter test test/core/network test/core/storage`
Expected: 전부 PASS. (실패 시: 복사한 테스트가 제외 대상 모듈을 import하는지 확인 → 해당 테스트만 제거하고 사유를 커밋 메시지에 기록.)

- [ ] **Step 5: analyze**

Run: `flutter analyze lib/core/network lib/core/storage`
Expected: 에러 0.

- [ ] **Step 6: Commit**

```bash
git add lib/core/network lib/core/storage test/core
git commit -m "feat: 네트워크·스토리지 계층 포팅 (Dio+AuthInterceptor+SecureTokenStorage+테스트)"
```

---

## Task 3: 공용 다이얼로그 · 시스템 상태 페이지(플레이스홀더)

**Files:**
- Create(adapt): `lib/core/widgets/dialogs/app_dialog.dart` (l10n → 한국어)
- Create(placeholder): `lib/core/widgets/pages/maintenance_page.dart`, `lib/core/widgets/pages/force_update_page.dart`

**참고:** cops의 `maintenance_page`/`force_update_page`는 `app_button`·`locale_brand_assets`(i18n)·`remote_config_service`·l10n을 끌어와서 verbatim 복사 불가. 이번엔 외부 의존 없는 최소 플레이스홀더로 만든다(디자인 패스에서 교체). `ForceUpdatePage`는 Task 1의 `AppUrls`/`launchExternalUrl`만 사용.

**Interfaces:**
- Consumes: `AppColors`, `AppTextStyles`(Task 1), `AppUrls`/`launchExternalUrl`(Task 1).
- Produces: `AppDialog`(공개 static API — cops 원본 시그니처 유지, 단 기본 confirm/cancel 라벨을 한국어로), `ForceUpdatePage`(`const ForceUpdatePage({super.key})`), `MaintenancePage`(`const MaintenancePage({super.key})`).

- [ ] **Step 1: app_dialog.dart 복사 + 치환**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/core/widgets/dialogs lib/core/widgets/pages
cp "$SRC/lib/core/widgets/dialogs/app_dialog.dart" lib/core/widgets/dialogs/app_dialog.dart
grep -rl 'package:cops_and_robbers/' lib/core/widgets/dialogs \
  | xargs -r sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
```

- [ ] **Step 2: app_dialog.dart l10n 제거**

`lib/core/widgets/dialogs/app_dialog.dart`에서:
1. `import 'package:eodaego/l10n/app_localizations.dart';` 라인 삭제.
2. `final l10n = AppLocalizations.of(context);` 사용 라인 삭제.
3. `confirmText ?? l10n.buttonConfirm` → `confirmText ?? '확인'`, `cancelText ?? l10n.buttonCancel` → `cancelText ?? '취소'`로 치환.

Run(확인):
```bash
grep -n 'l10n\|AppLocalizations' lib/core/widgets/dialogs/app_dialog.dart || echo "CLEAN"
```
Expected: `CLEAN`. (app_dialog가 다른 제외 모듈을 추가로 import하면 그 부분도 한국어/기본값으로 치환.)

- [ ] **Step 3: maintenance_page.dart 플레이스홀더 작성**

```dart
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';

/// 서버 점검 안내. TODO: 어대GO 점검 화면 디자인으로 교체.
class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('잠시 점검 중이에요', style: AppTextStyles.display24),
                const SizedBox(height: 12),
                Text(
                  '더 나은 서비스를 위해 점검하고 있어요.\n잠시 후 다시 시도해 주세요.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body15.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: force_update_page.dart 플레이스홀더 작성** (스토어 이동 버튼)

```dart
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_urls.dart';
import '../../constants/text_styles.dart';
import '../../utils/url_launcher_util.dart';

/// 강제 업데이트 안내. TODO: 어대GO 디자인 + AppButton 프리셋으로 교체.
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('업데이트가 필요해요', style: AppTextStyles.display24),
                const SizedBox(height: 12),
                Text(
                  '원활한 이용을 위해\n최신 버전으로 업데이트해 주세요.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body15.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => launchExternalUrl(AppUrls.storeUrl),
                  child: Text('지금 업데이트',
                      style: AppTextStyles.label16Semibold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: analyze**

Run: `flutter analyze lib/core/widgets`
Expected: 에러 0.

- [ ] **Step 6: Commit**

```bash
git add lib/core/widgets
git commit -m "feat: 공용 다이얼로그(한국어) + 점검·강제업데이트 플레이스홀더 페이지"
```

---

## Task 4: auth 데이터 · 도메인 계층

**Files:**
- Create(verbatim+rename): `lib/features/auth/data/**`, `lib/features/auth/domain/**` (아래 목록 전체, `*.g.dart`/`*.freezed.dart` 제외)

**Interfaces:**
- Consumes: `SecureTokenStorage`(Task 2), `AppException`(Task 1), `dioProvider`(Task 2).
- Produces: `AuthRemoteDataSource(Dio)` (Retrofit), `FirebaseAuthDataSource` (`signInWithGoogle/Apple`, `signOut`, `currentUser`, `authStateChanges()`), `AuthRepositoryImpl`, `AuthRepository`(인터페이스), `AuthResultEntity({userId,nickname,isNewUser,requiresAgreement})`+`copyWith`, `SignInWithGoogleUseCase/SignInWithAppleUseCase/SignOutUseCase`(각 `.execute()`), `FirebaseAuthErrorHandler.createAuthException(e,{provider})`, `SocialProvider`, 로그인/로그아웃/reissue 요청·응답 모델.

- [ ] **Step 1: 소스 복사 + 치환**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/features/auth
# data/domain 전체를 복사하되 생성 파일은 제외
rsync -a --exclude='*.g.dart' --exclude='*.freezed.dart' \
  "$SRC/lib/features/auth/data/" lib/features/auth/data/
rsync -a --exclude='*.g.dart' --exclude='*.freezed.dart' \
  "$SRC/lib/features/auth/domain/" lib/features/auth/domain/
grep -rl 'package:cops_and_robbers/' lib/features/auth/data lib/features/auth/domain \
  | xargs sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
```

- [ ] **Step 2: 제외 모듈 결합 점검** (data/domain은 앞선 조사에서 clean 확인됨 — 방어)

Run:
```bash
grep -rn "session\|/game\|analytics\|tutorial\|l10n\|active_game\|home_page" \
  lib/features/auth/data lib/features/auth/domain --include='*.dart' || echo "CLEAN"
```
Expected: `CLEAN`. (매치가 나오면 해당 라인이 제외 모듈 import인지 확인 후 제거.)

- [ ] **Step 3: 코드 생성**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `Succeeded` — auth data models의 `*.freezed.dart`/`*.g.dart`, `auth_remote_datasource.g.dart` 생성.

- [ ] **Step 4: analyze**

Run: `flutter analyze lib/features/auth/data lib/features/auth/domain`
Expected: 에러 0.

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/data lib/features/auth/domain
git commit -m "feat: auth 데이터·도메인 계층 포팅 (Firebase/Retrofit 로그인 로직)"
```

---

## Task 5: user 데이터 · 도메인 계층 (game_push 제거)

**Files:**
- Create(verbatim+rename): `lib/features/user/data/**`, `lib/features/user/domain/**`, `lib/features/user/presentation/providers/user_provider.dart` (game_push_agreement 관련 제외)
- Create(test): `test/features/user/**` 중 game 비의존 테스트

**Interfaces:**
- Consumes: `dioProvider`(Task 2), `AppException`.
- Produces: `userRepositoryProvider`(+ `getAgreements()→AgreementStatusEntity`, `updateAgreements({marketing})`, `getMyProfile()→UserProfileEntity`, `updateNickname(...)`, `checkNickname(...)`, `deleteAccount()`), `AgreementStatusEntity`(`hasAllRequired`, `termsOfService/privacyPolicy/locationTerms/marketing`), `UserProfileEntity`(`nickname`), `UserRemoteDataSource`, `DeleteAccountUseCase`.

- [ ] **Step 1: 소스 복사 + 치환 (game_push 모델 제외)**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/features/user
rsync -a --exclude='*.g.dart' --exclude='*.freezed.dart' \
  --exclude='game_push_agreement_model.dart' \
  "$SRC/lib/features/user/data/" lib/features/user/data/
rsync -a --exclude='*.g.dart' --exclude='*.freezed.dart' \
  "$SRC/lib/features/user/domain/" lib/features/user/domain/
mkdir -p lib/features/user/presentation/providers
cp "$SRC/lib/features/user/presentation/providers/user_provider.dart" \
   lib/features/user/presentation/providers/user_provider.dart
grep -rl 'package:cops_and_robbers/' lib/features/user \
  | xargs sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
```

- [ ] **Step 2: game_push 참조 제거**

`user_remote_datasource.dart`와 `user_repository_impl.dart`에서:
1. `import '../models/game_push_agreement_model.dart';` 삭제.
2. `GamePushAgreementModel`을 사용하는 메서드(게임 푸시 동의 조회/업데이트) 전체 삭제. (`ApiEndpoints.agreementsGamePush`는 Task1에서 이미 없으므로 관련 라인도 삭제.)
3. Repository 인터페이스(`user_repository.dart`)에도 동일 메서드 선언이 있으면 삭제.

Run(확인):
```bash
grep -rn "game_push\|GamePushAgreement\|agreementsGamePush\|game-push" lib/features/user || echo "CLEAN"
```
Expected: `CLEAN`

- [ ] **Step 3: user_provider 제외 결합 점검**

Run:
```bash
grep -rn "session\|/game\|analytics\|tutorial\|l10n\|active_game" lib/features/user --include='*.dart' || echo "CLEAN"
```
Expected: `CLEAN`. (매치 시 제거.)

- [ ] **Step 4: 코드 생성**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `Succeeded`.

- [ ] **Step 5: 테스트 복사 (game 비의존만)**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p test/features/user
rsync -a "$SRC/test/features/user/" test/features/user/ 2>/dev/null || true
grep -rl 'package:cops_and_robbers/' test/features/user 2>/dev/null \
  | xargs -r sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
# game_push/제외모듈에 의존하는 테스트 제거
grep -rln "game_push\|GamePushAgreement\|session\|/game" test/features/user 2>/dev/null | xargs -r rm -f
```

- [ ] **Step 6: 테스트 + analyze**

Run: `flutter test test/features/user && flutter analyze lib/features/user`
Expected: 테스트 PASS, analyze 에러 0.

- [ ] **Step 7: Commit**

```bash
git add lib/features/user test/features/user
git commit -m "feat: user 데이터·도메인 계층 포팅 (닉네임/약관/탈퇴, game_push 제외)"
```

---

## Task 6: auth providers (agreement 복사 + auth_provider 재작성)

**Files:**
- Create(verbatim+rename): `lib/features/auth/presentation/providers/agreement_provider.dart`
- Create(rewrite): `lib/features/auth/presentation/providers/auth_provider.dart`
- Create(test): `test/features/auth/presentation/providers/{agreement_provider_test,auth_notifier_agreement_test}.dart` (game 비의존 시)

**Interfaces:**
- Consumes: `dioProvider`, `secureTokenStorageProvider`, `forceLogoutCallbackNotifierProvider`, `forceLogoutMessageKeyProvider`(Task 2); `authRepositoryProvider` 등(Task 4); `userRepositoryProvider`, `connectivityServiceProvider`(Task 5/2).
- Produces: `authNotifierProvider`(`AsyncNotifier<AuthResultEntity?>` — 메서드: `signInWithGoogle()`, `signInWithApple()`, `signOut()`, `updateNicknameCompleted(String)`, `markAgreementCompleted()`, `markNeedsAgreement()`, `cleanupAfterAccountDeletion()`, `forceLogout()`); `authStateProvider`(`Stream<User?>`); `firebaseAuthDataSourceProvider`; `authRepositoryProvider`; `agreementNotifierProvider`(`AgreementState` + `toggleTerms/togglePrivacy/toggleLocation/toggleMarketing/toggleAll(bool)/submit()→AgreementSubmitResult`); `AgreementSubmitResult{success,offline,missingRequired,failure}`; `AgreementState`(`hasAllRequired`, `allAgreed`, `isLoading`, `isSubmitting`, 4개 bool).

- [ ] **Step 1: agreement_provider 복사 + 치환**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/features/auth/presentation/providers
cp "$SRC/lib/features/auth/presentation/providers/agreement_provider.dart" \
   lib/features/auth/presentation/providers/agreement_provider.dart
sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g' \
   lib/features/auth/presentation/providers/agreement_provider.dart
```
(agreement_provider는 `connectivity_service` + `user_provider`만 의존 — 이미 포팅됨.)

- [ ] **Step 2: auth_provider.dart 재작성** (game/session/analytics/tutorial/HomePage/LoginPage 결합 제거)

`lib/features/auth/presentation/providers/auth_provider.dart` 전체를 아래로 작성:

```dart
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_result_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_apple_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/utils/firebase_auth_error_handler.dart';
import '../../../user/presentation/providers/user_provider.dart';

part 'auth_provider.g.dart';

/// FirebaseAuthDataSource Provider (keepAlive — 인터셉터 콜백에서 접근)
@Riverpod(keepAlive: true)
FirebaseAuthDataSource firebaseAuthDataSource(Ref ref) {
  return FirebaseAuthDataSource();
}

/// AuthRemoteDataSource Provider (Retrofit)
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
}

/// AuthRepository Provider
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    firebaseAuthDataSource: ref.watch(firebaseAuthDataSourceProvider),
    authRemoteDataSource: ref.watch(authRemoteDataSourceProvider),
    tokenStorage: ref.watch(secureTokenStorageProvider),
  );
}

@riverpod
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) =>
    SignInWithGoogleUseCase(repository: ref.watch(authRepositoryProvider));

@riverpod
SignInWithAppleUseCase signInWithAppleUseCase(Ref ref) =>
    SignInWithAppleUseCase(repository: ref.watch(authRepositoryProvider));

@riverpod
SignOutUseCase signOutUseCase(Ref ref) =>
    SignOutUseCase(repository: ref.watch(authRepositoryProvider));

/// Firebase Auth State 스트림 (GoRouter refreshListenable 용)
@riverpod
Stream<User?> authState(Ref ref) {
  return ref.watch(firebaseAuthDataSourceProvider).authStateChanges();
}

/// 인증 상태 Notifier. State: `AsyncValue<AuthResultEntity?>` (null = 미로그인)
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<AuthResultEntity?> build() async {
    // 강제 로그아웃 콜백 등록 (core → auth 역전 패턴)
    Future.microtask(() {
      ref.read(forceLogoutCallbackNotifierProvider.notifier).register(({
        String? messageKey,
      }) async {
        final firebaseDataSource = ref.read(firebaseAuthDataSourceProvider);
        await firebaseDataSource.signOut();
        await ref.read(secureTokenStorageProvider).clearTokens();
        if (messageKey != null) {
          ref.read(forceLogoutMessageKeyProvider.notifier).state = messageKey;
        }
        forceLogout();
      });
    });

    ref.onDispose(() {
      ref.read(forceLogoutCallbackNotifierProvider.notifier).unregister();
    });

    // 초기 상태: Firebase + JWT 토큰 모두 있어야 인증
    final dataSource = ref.watch(firebaseAuthDataSourceProvider);
    final tokenStorage = ref.watch(secureTokenStorageProvider);
    final currentUser = dataSource.currentUser;
    if (currentUser == null) return null;

    if (!await tokenStorage.hasTokens()) return null;

    final userId = await tokenStorage.getUserId();
    if (userId == null) {
      try {
        await dataSource.signOut();
      } catch (_) {}
      await tokenStorage.clearTokens();
      return null;
    }

    // cold start: 약관/프로필을 백엔드에서 조회 (각 실패 독립 허용)
    final userRepo = ref.read(userRepositoryProvider);
    bool requiresAgreement = false;
    String nickname = currentUser.displayName ?? '';
    try {
      final status = await userRepo.getAgreements();
      requiresAgreement = !status.hasAllRequired;
    } catch (e) {
      debugPrint('⚠️ [AuthNotifier] 약관 상태 조회 실패: $e');
    }
    try {
      final profile = await userRepo.getMyProfile();
      nickname = profile.nickname;
    } catch (e) {
      debugPrint('⚠️ [AuthNotifier] 프로필 조회 실패: $e');
    }

    final isNewUser = await tokenStorage.getIsNewUser();
    return AuthResultEntity(
      userId: userId,
      nickname: nickname,
      isNewUser: isNewUser,
      requiresAgreement: requiresAgreement,
    );
  }

  Future<void> signInWithGoogle() => _signIn(
        () => ref.read(signInWithGoogleUseCaseProvider).execute(),
        provider: 'Google',
      );

  Future<void> signInWithApple() => _signIn(
        () => ref.read(signInWithAppleUseCaseProvider).execute(),
        provider: 'Apple',
      );

  Future<void> _signIn(
    Future<AuthResultEntity> Function() run, {
    required String provider,
  }) async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await run());
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(
        FirebaseAuthErrorHandler.createAuthException(e, provider: provider),
        StackTrace.current,
      );
      rethrow;
    } catch (e, stack) {
      state = AsyncValue.error(
        e is AppException
            ? e
            : AuthException(
                message: 'unknown auth error',
                messageKey: 'errorUnknown',
                originalException: e,
              ),
        stack,
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(signOutUseCaseProvider).execute();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(
        AuthException(
          message: 'logout failed',
          messageKey: 'errorLogoutFailed',
          originalException: e,
        ),
        stack,
      );
    }
  }

  /// 닉네임 설정 완료 → isNewUser=false 로 갱신 (영속 포함)
  Future<void> updateNicknameCompleted(String nickname) async {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      AuthResultEntity(
        userId: current.userId,
        nickname: nickname,
        isNewUser: false,
        requiresAgreement: current.requiresAgreement,
      ),
    );
    try {
      await ref.read(secureTokenStorageProvider).saveIsNewUser(false);
    } catch (e) {
      debugPrint('⚠️ [AuthNotifier] saveIsNewUser(false) 실패: $e');
    }
  }

  /// 약관 동의 완료 → requiresAgreement=false
  void markAgreementCompleted() {
    final current = state.valueOrNull;
    if (current == null || !current.requiresAgreement) return;
    state = AsyncValue.data(current.copyWith(requiresAgreement: false));
  }

  /// 백엔드 "필수 약관 미동의" 차단 → requiresAgreement=true
  void markNeedsAgreement() {
    final current = state.valueOrNull;
    if (current == null || current.requiresAgreement) return;
    state = AsyncValue.data(current.copyWith(requiresAgreement: true));
  }

  /// 회원 탈퇴 후 로컬 정리 (state는 호출부에서 forceLogout로 초기화)
  Future<void> cleanupAfterAccountDeletion() async {
    final firebaseDataSource = ref.read(firebaseAuthDataSourceProvider);
    try {
      await firebaseDataSource.signOut();
    } finally {
      await ref.read(secureTokenStorageProvider).clearTokens();
    }
  }

  /// 강제 로그아웃 (AuthInterceptor 재발급 실패 시)
  void forceLogout() {
    state = const AsyncValue.data(null);
  }
}
```

- [ ] **Step 3: 코드 생성**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `Succeeded` — `auth_provider.g.dart`, `agreement_provider.{g,freezed}.dart` 생성.

- [ ] **Step 4: 테스트 복사 (game 비의존만)**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p test/features/auth/presentation/providers
for t in agreement_provider_test auth_notifier_agreement_test; do
  [ -f "$SRC/test/features/auth/presentation/providers/$t.dart" ] && \
    cp "$SRC/test/features/auth/presentation/providers/$t.dart" \
       "test/features/auth/presentation/providers/$t.dart"
done
grep -rl 'package:cops_and_robbers/' test/features/auth 2>/dev/null \
  | xargs -r sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
# 제외 모듈(session/game/analytics/tutorial/pages) 의존 테스트 제거
grep -rln "session\|/game\|analytics\|tutorial\|home_page\|login_page\|splash_page" \
  test/features/auth 2>/dev/null | xargs -r rm -f
```

- [ ] **Step 5: 테스트 + analyze**

Run: `flutter test test/features/auth && flutter analyze lib/features/auth/presentation/providers`
Expected: 테스트 PASS, analyze 에러 0. (auth_notifier_agreement_test가 재작성된 auth_provider와 시그니처 불일치로 실패하면, 그 테스트는 삭제하고 사유를 커밋에 기록 — game 복원 로직 제거로 인한 정당한 차이.)

- [ ] **Step 6: Commit**

```bash
git add lib/features/auth/presentation/providers test/features/auth
git commit -m "feat: auth providers 포팅 (agreement 복사 + auth_provider 재작성, game 결합 제거)"
```

---

## Task 7: 라우터 + auth 페이지 뼈대 + 플레이스홀더 홈

**Files:**
- Create(rewrite): `lib/router/route_paths.dart`, `lib/router/app_router.dart`
- Create(skeleton): `lib/features/auth/presentation/pages/{splash_page,login_page,onboarding_page,nickname_setup_page,agreement_page}.dart`
- Create(adapt): `lib/features/auth/presentation/widgets/{agreement_item,agreement_all_checkbox,agreement_checkbox}.dart` (l10n → 한국어; 실제로 필요한 것만)
- Create(placeholder): `lib/features/home/presentation/pages/home_page.dart`

**Interfaces:**
- Consumes: `authNotifierProvider`, `agreementNotifierProvider`(Task 6); `forceLogoutMessageKeyProvider`(Task 2); `AppColors`/`AppTextStyles`(Task 1).
- Produces: `routerProvider`(`GoRouter`); `RoutePaths.{splash,login,onboarding,nicknameSetup,agreement,home,maintenance,forceUpdate,*Name}` + `nicknameSetupWithNickname(String)`; `rootNavigatorKey`; 각 Page 위젯; `HomePage`(플레이스홀더).

- [ ] **Step 1: route_paths.dart 재작성** (인증 플로우 + 시스템 상태 라우트만)

```dart
/// 앱 라우트 경로 상수. (게임 라우트는 이번 포팅 범위 아님)
class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String nicknameSetup = '/nickname-setup';
  static const String agreement = '/agreement';
  static const String home = '/home';
  static const String maintenance = '/maintenance';
  static const String forceUpdate = '/force-update';

  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String onboardingName = 'onboarding';
  static const String nicknameSetupName = 'nicknameSetup';
  static const String agreementName = 'agreement';
  static const String homeName = 'home';
  static const String maintenanceName = 'maintenance';
  static const String forceUpdateName = 'forceUpdate';

  static String nicknameSetupWithNickname(String nickname) =>
      '$nicknameSetup?nickname=${Uri.encodeComponent(nickname)}';
}
```

- [ ] **Step 2: 플레이스홀더 홈 페이지 작성**

`lib/features/home/presentation/pages/home_page.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 임시 홈. TODO: 어대GO 홈(도감/지도/카메라) 구현으로 교체.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('어대GO', style: AppTextStyles.display26),
            const SizedBox(height: 12),
            Text('환영합니다 ${user?.nickname ?? ''}',
                style: AppTextStyles.body15.copyWith(color: AppColors.muted)),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () =>
                  ref.read(authNotifierProvider.notifier).signOut(),
              child: Text('로그아웃',
                  style: AppTextStyles.label16Semibold
                      .copyWith(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: auth 페이지 뼈대 5종 작성**

각 페이지는 `authNotifierProvider`/`agreementNotifierProvider`를 사용하는 최소 UI. TODO로 디자인 재작업 표시. `lib/features/auth/presentation/pages/splash_page.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';

/// 스플래시. redirect가 authState에 따라 자동 이동하므로 로딩만 표시.
/// TODO: 어대GO 스플래시 디자인 + 오프라인 재시도 로직.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Center(
        child: Text('어대GO', style: AppTextStyles.display34),
      ),
    );
  }
}
```

`login_page.dart` (강제 로그아웃 사유 키 → 한국어 스낵바 + 소셜 로그인 트리거):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/network/dio_client.dart';
import '../providers/auth_provider.dart';

/// 강제 로그아웃 사유 키 → 한국어 (i18n 미포팅 대체).
String _forceLogoutMessage(String key) {
  switch (key) {
    case 'errorAuthExpired':
      return '세션이 만료되었어요. 다시 로그인해 주세요.';
    case 'errorTemporaryRetry':
      return '일시적인 오류가 발생했어요. 다시 시도해 주세요.';
    default:
      return '다시 로그인해 주세요.';
  }
}

/// TODO: 어대GO 로그인 디자인 (Google/Apple 소셜 버튼 프리셋).
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 강제 로그아웃 사유 1회 소비 → 스낵바
    ref.listen(forceLogoutMessageKeyProvider, (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_forceLogoutMessage(next))),
        );
        ref.read(forceLogoutMessageKeyProvider.notifier).state = null;
      }
    });

    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final notifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('어대GO', style: AppTextStyles.display34),
                  const SizedBox(height: 32),
                  // TODO: AppButton 소셜 프리셋으로 교체
                  ElevatedButton(
                    onPressed: () => notifier.signInWithGoogle(),
                    child: Text('Google로 시작하기',
                        style: AppTextStyles.label16Semibold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => notifier.signInWithApple(),
                    child: Text('Apple로 시작하기',
                        style: AppTextStyles.label16Semibold),
                  ),
                ],
              ),
      ),
    );
  }
}
```

`onboarding_page.dart` (최소 — 로그인으로 보냄):
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../router/route_paths.dart';

/// TODO: 어대GO 온보딩 (smooth_page_indicator 캐러셀).
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('어대GO에 오신 걸 환영해요', style: AppTextStyles.display24),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.login),
              child: Text('시작하기', style: AppTextStyles.label16Semibold),
            ),
          ],
        ),
      ),
    );
  }
}
```

`nickname_setup_page.dart` (닉네임 입력 → `updateNicknameCompleted`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../providers/auth_provider.dart';

/// TODO: 어대GO 닉네임 설정 디자인 + 중복확인(checkNickname) 연동.
class NicknameSetupPage extends ConsumerStatefulWidget {
  const NicknameSetupPage({super.key, this.initialNickname});
  final String? initialNickname;

  @override
  ConsumerState<NicknameSetupPage> createState() => _NicknameSetupPageState();
}

class _NicknameSetupPageState extends ConsumerState<NicknameSetupPage> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialNickname ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('닉네임을 정해 주세요', style: AppTextStyles.display24),
              const SizedBox(height: 24),
              TextField(controller: _controller),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final nick = _controller.text.trim();
                  if (nick.isEmpty) return;
                  ref
                      .read(authNotifierProvider.notifier)
                      .updateNicknameCompleted(nick);
                },
                child: Text('완료', style: AppTextStyles.label16Semibold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

`agreement_page.dart` (약관 4종 체크 → `submit` → `markAgreementCompleted`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../providers/agreement_provider.dart';
import '../providers/auth_provider.dart';

/// TODO: 어대GO 약관 동의 디자인 (agreement 위젯 재사용).
class AgreementPage extends ConsumerWidget {
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agreementNotifierProvider);
    final notifier = ref.read(agreementNotifierProvider.notifier);

    Widget row(String label, bool value, VoidCallback onTap) => CheckboxListTile(
          value: value,
          onChanged: (_) => onTap(),
          title: Text(label, style: AppTextStyles.body15),
        );

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text('약관에 동의해 주세요', style: AppTextStyles.display24),
            row('[필수] 서비스 이용약관', state.termsOfService, notifier.toggleTerms),
            row('[필수] 개인정보 처리방침', state.privacyPolicy, notifier.togglePrivacy),
            row('[필수] 위치기반 서비스 약관', state.locationTerms, notifier.toggleLocation),
            row('[선택] 마케팅 수신 동의', state.marketing, notifier.toggleMarketing),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: state.hasAllRequired && !state.isSubmitting
                    ? () async {
                        final result = await notifier.submit();
                        if (result == AgreementSubmitResult.success) {
                          ref
                              .read(authNotifierProvider.notifier)
                              .markAgreementCompleted();
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('잠시 후 다시 시도해 주세요.')),
                          );
                        }
                      }
                    : null,
                child: Text('동의하고 시작하기',
                    style: AppTextStyles.label16Semibold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

(참고: cops의 `agreement_item`/`agreement_all_checkbox` 위젯은 l10n 결합이 있고, 위 스켈레톤은 `CheckboxListTile`로 대체하므로 이번엔 복사하지 않는다 — YAGNI. 추후 디자인 작업 시 포팅.)

- [ ] **Step 4: app_router.dart 재작성** (redirect 로직 유지, game 라우트/deeplink/postLoginDestination 제거)

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/pages/agreement_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/nickname_setup_page.dart';
import '../features/auth/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../core/widgets/pages/force_update_page.dart';
import '../core/widgets/pages/maintenance_page.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// auth 상태 변경 시 redirect 재평가를 위한 Listenable
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(this._ref) {
    _ref.listen(authNotifierProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: _AuthRefreshNotifier(ref),
    redirect: (context, state) {
      try {
        final auth = ref.read(authNotifierProvider);
        if (auth.isLoading) return null;

        final user = auth.value;
        final isAuthenticated = user != null;
        final path = state.uri.path;

        final publicPaths = [
          RoutePaths.splash,
          RoutePaths.login,
          RoutePaths.maintenance,
          RoutePaths.forceUpdate,
        ];

        if (!isAuthenticated) {
          return publicPaths.contains(path) ? null : RoutePaths.login;
        }

        if (user.requiresAgreement) {
          return path == RoutePaths.agreement ? null : RoutePaths.agreement;
        }

        if (user.isNewUser) {
          return path == RoutePaths.nicknameSetup
              ? null
              : RoutePaths.nicknameSetupWithNickname(user.nickname);
        }

        if (path == RoutePaths.login) return RoutePaths.home;
        if (path == RoutePaths.agreement) return RoutePaths.home;
        return null;
      } catch (e, stack) {
        debugPrint('🚨 [GoRouter redirect] 예외: $e\n$stack');
        return RoutePaths.login;
      }
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RoutePaths.splashName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RoutePaths.loginName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RoutePaths.onboardingName,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RoutePaths.nicknameSetup,
        name: RoutePaths.nicknameSetupName,
        builder: (context, state) => NicknameSetupPage(
          initialNickname: state.uri.queryParameters['nickname'],
        ),
      ),
      GoRoute(
        path: RoutePaths.agreement,
        name: RoutePaths.agreementName,
        builder: (context, state) => const AgreementPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RoutePaths.homeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.maintenance,
        name: RoutePaths.maintenanceName,
        builder: (context, state) => const MaintenancePage(),
      ),
      GoRoute(
        path: RoutePaths.forceUpdate,
        name: RoutePaths.forceUpdateName,
        builder: (context, state) => const ForceUpdatePage(),
      ),
    ],
  );
}
```
(참고: `MaintenancePage`/`ForceUpdatePage`의 실제 생성자 시그니처를 Task 3 복사본에서 확인하고, 필수 파라미터가 있으면 라우트 builder에서 채운다.)

- [ ] **Step 5: 코드 생성**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `Succeeded` — `app_router.g.dart` 생성.

- [ ] **Step 6: analyze**

Run: `flutter analyze lib/router lib/features/auth/presentation/pages lib/features/home`
Expected: 에러 0.

- [ ] **Step 7: Commit**

```bash
git add lib/router lib/features/auth/presentation/pages lib/features/home
git commit -m "feat: 라우터 재작성 + auth 페이지 뼈대 + 플레이스홀더 홈"
```

---

## Task 8: main.dart 부트스트랩 (앱 부팅 → 로그인 도달)

**Files:**
- Modify(rewrite): `lib/main.dart`

**Interfaces:**
- Consumes: `EnvConfig.initialize()`, `SecureTokenStorage().clearTokensIfReinstalled()`(Task 1/2), `routerProvider`(Task 7).
- Produces: `main()`, `MyApp`(ConsumerWidget, `isFirebaseInitialized`).

- [ ] **Step 1: main.dart 재작성** (Firebase/Crashlytics 부트스트랩 유지, locale/deeplink/pendingInvite/vibration/app_icon 제거. FCM은 Task 9에서 추가)

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/config/env_config.dart';
import 'core/constants/app_colors.dart';
import 'core/storage/secure_token_storage.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 릴리스에서 debugPrint 비활성화 (토큰·위치 등 민감정보 로그 노출 방지)
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  // 재설치 시 이전 토큰 초기화 (iOS Keychain 잔존 대응)
  await SecureTokenStorage().clearTokensIfReinstalled();

  // 환경 변수 로드
  await EnvConfig.initialize();

  // 세로 방향 고정
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Firebase 초기화 (실패해도 앱 실행 계속)
  bool isFirebaseInitialized = false;
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 10));
    isFirebaseInitialized = true;
    debugPrint('✅ Firebase initialized');
  } catch (e, s) {
    debugPrint('❌ Firebase init failed: $e\n$s');
  }

  // Crashlytics (Firebase 성공 시에만)
  if (isFirebaseInitialized) {
    try {
      if (kDebugMode) {
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(false);
      }
      FlutterError.onError = (details) {
        if (kDebugMode) {
          debugPrint('🔥 Flutter Error: ${details.exception}');
        } else {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        }
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        if (kDebugMode) {
          debugPrint('🔥 Async Error: $error');
        } else {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        }
        return true;
      };
    } catch (e) {
      debugPrint('❌ Crashlytics setup failed: $e');
    }
  }

  runApp(
    ProviderScope(child: MyApp(isFirebaseInitialized: isFirebaseInitialized)),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, this.isFirebaseInitialized = true});

  final bool isFirebaseInitialized;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: '어대GO',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.canvas,
            useMaterial3: true,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
```

- [ ] **Step 2: analyze 전체**

Run: `flutter analyze`
Expected: 에러 0.

- [ ] **Step 3: 앱 부팅 스모크** (시뮬레이터/디바이스에서 부팅 → 스플래시 → 로그인 도달)

Run: `flutter run -d <device>` (또는 이미 부팅 가능한 환경에서 hot restart)
Expected: 크래시 없이 부팅. 미인증 상태이므로 redirect가 `/login`으로 이동, 로그인 화면(Google/Apple 버튼) 표시. (Firebase 설정 파일이 없으면 Firebase init 실패 로그가 뜨지만 앱은 계속 실행되어 로그인 화면까지 도달해야 함.)

- [ ] **Step 4: Commit**

```bash
git add lib/main.dart
git commit -m "feat: main.dart 부트스트랩 재작성 (앱 부팅 → 로그인 도달)"
```

---

## Task 9: FCM · 디바이스 서비스

**Files:**
- Create(verbatim+rename): `lib/core/services/fcm/{firebase_messaging_service,local_notifications_service}.dart`, `lib/core/services/device/{device_id_manager,device_info_service}.dart`
- Modify: `lib/main.dart` (FCM/로컬알림 초기화 추가)

**Interfaces:**
- Consumes: (Firebase, 알림 패키지)
- Produces: `FirebaseMessagingService.instance()` (+`init()`), `LocalNotificationsService.instance()` (+`init()`), `DeviceIdManager`, `DeviceInfoService`.

- [ ] **Step 1: 소스 복사 + 치환**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/core/services/fcm lib/core/services/device
cp "$SRC"/lib/core/services/fcm/*.dart lib/core/services/fcm/
cp "$SRC"/lib/core/services/device/*.dart lib/core/services/device/
grep -rl 'package:cops_and_robbers/' lib/core/services/fcm lib/core/services/device \
  | xargs -r sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
```

- [ ] **Step 2: 제외 모듈 결합 점검**

Run:
```bash
grep -rn "session\|/game\|analytics\|l10n\|deeplink\|route_paths\|app_router" \
  lib/core/services/fcm lib/core/services/device --include='*.dart' || echo "CLEAN"
```
Expected: `CLEAN`. (FCM 서비스가 route_paths/deeplink에 결합돼 있으면, 알림 탭 시 네비게이션 부분만 TODO 주석으로 비워두고 초기화 로직은 유지.)

- [ ] **Step 3: main.dart에 FCM/로컬알림 초기화 추가**

`lib/main.dart` 상단 import에 추가:
```dart
import 'core/services/fcm/firebase_messaging_service.dart';
import 'core/services/fcm/local_notifications_service.dart';
```
Crashlytics 블록 다음, `runApp(...)` 직전에 추가:
```dart
  // 로컬 알림 (Firebase 독립)
  try {
    await LocalNotificationsService.instance().init();
    debugPrint('✅ Local notifications initialized');
  } catch (e) {
    debugPrint('❌ Local notifications init failed: $e');
  }

  // FCM (Firebase 의존)
  if (isFirebaseInitialized) {
    try {
      await FirebaseMessagingService.instance().init();
      debugPrint('✅ FCM initialized');
    } catch (e) {
      debugPrint('❌ FCM init failed: $e');
    }
  }
```

- [ ] **Step 4: analyze + 부팅 스모크**

Run: `flutter analyze && flutter run -d <device>`
Expected: analyze 에러 0. 부팅 시 로컬알림/FCM 초기화 로그 출력(Firebase 설정 없으면 FCM은 실패 로그, 앱은 계속). 로그인 화면 도달.

- [ ] **Step 5: Commit**

```bash
git add lib/core/services/fcm lib/core/services/device lib/main.dart
git commit -m "feat: FCM·디바이스 서비스 포팅 + 부트스트랩 연결"
```

---

## Task 10: Remote Config 세트 (강제 업데이트 / 점검)

**Files:**
- Create(verbatim+rename): `lib/core/services/remote_config/{remote_config_service,app_version_checker}.dart`
- Create(adapt): `lib/core/services/remote_config/update_dialog_helper.dart` (l10n → 한국어)

**참고:** `update_dialog_helper`는 `go_router` + `route_paths`(Task 7) + `app_urls`/`url_launcher_util`(Task 1) + `app_dialog`(Task 3) + `app_version_checker`에 의존. 모두 선행 Task에서 확보됨. `remote_config_service`/`app_version_checker`는 `package_info_plus`만 추가 의존(pubspec에 존재) — clean verbatim.

**Interfaces:**
- Consumes: `RemoteConfig`, `AppDialog`(Task 3), `RoutePaths.{maintenance,forceUpdate}`(Task 7), `AppUrls`/`launchExternalUrl`(Task 1).
- Produces: `RemoteConfigService`, `AppVersionChecker`, `UpdateDialogHelper.handleResult(...)`.

- [ ] **Step 1: 소스 복사 + 치환**

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/core/services/remote_config
cp "$SRC"/lib/core/services/remote_config/*.dart lib/core/services/remote_config/
grep -rl 'package:cops_and_robbers/' lib/core/services/remote_config \
  | xargs -r sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
```

- [ ] **Step 2: update_dialog_helper.dart l10n 제거**

`update_dialog_helper.dart`에서:
1. `import 'package:eodaego/l10n/app_localizations.dart';` 삭제.
2. `AppLocalizations.of(context)` 사용부의 각 문자열을 한국어 하드코딩으로 치환(예: 제목 '업데이트가 필요해요', 본문 '원활한 이용을 위해 최신 버전으로 업데이트해 주세요.', 버튼 '지금 업데이트'). (`app_urls`/`url_launcher_util`/`app_dialog`/`route_paths` import는 Task 1/3/7에서 확보됐으므로 유지.)

Run(확인):
```bash
grep -rn "l10n\|AppLocalizations" lib/core/services/remote_config || echo "CLEAN"
```
Expected: `CLEAN`

- [ ] **Step 3: 제외 모듈 결합 점검**

Run:
```bash
grep -rn "session\|/game\|analytics\|deeplink\|locale_brand\|app_button" lib/core/services/remote_config --include='*.dart' || echo "CLEAN"
```
Expected: `CLEAN`. (RoutePaths 참조는 Task 7에서 maintenance/forceUpdate가 있으므로 OK. 없는 상수·모듈을 참조하면 해당 로직만 조정/제거.)

- [ ] **Step 4: analyze**

Run: `flutter analyze lib/core/services/remote_config`
Expected: 에러 0.

- [ ] **Step 5: Commit**

```bash
git add lib/core/services/remote_config
git commit -m "feat: Remote Config 세트 포팅 (버전체크·강제업데이트·점검, l10n → 한국어)"
```

---

## Task 11: 위치 · 권한 서비스

**Files:**
- Create(verbatim+rename): `lib/core/services/location/device_location_service.dart`, `lib/core/services/permission/location_permission_service.dart`
- Create(adapt): `lib/core/services/permission/location_permission_messages.dart` (l10n → 한국어)

**Interfaces:**
- Consumes: `geolocator`, `AppException`(LocationException).
- Produces: `DeviceLocationService`, `LocationPermissionService.ensurePermission()`, `LocationPermissionMessages`.

- [ ] **Step 1: 소스 복사 + 치환** (game_entry_gate는 제외)

Run:
```bash
SRC=/Users/luca/workspace/Flutter_Project/cops_and_robbers
mkdir -p lib/core/services/location lib/core/services/permission
cp "$SRC/lib/core/services/location/device_location_service.dart" lib/core/services/location/
cp "$SRC/lib/core/services/permission/location_permission_service.dart" lib/core/services/permission/
cp "$SRC/lib/core/services/permission/location_permission_messages.dart" lib/core/services/permission/
grep -rl 'package:cops_and_robbers/' lib/core/services/location lib/core/services/permission \
  | xargs -r sed -i '' 's#package:cops_and_robbers/#package:eodaego/#g'
```

- [ ] **Step 2: location_permission_messages.dart l10n 제거**

`location_permission_messages.dart`의 `import '../../../l10n/app_localizations.dart';`를 삭제하고, `AppLocalizations` 기반 메시지를 한국어 하드코딩으로 치환(예: '위치 권한이 필요해요', '설정에서 위치 권한을 허용해 주세요.').

Run(확인):
```bash
grep -rn "l10n\|AppLocalizations" lib/core/services/permission lib/core/services/location || echo "CLEAN"
```
Expected: `CLEAN`

- [ ] **Step 3: 제외 모듈 결합 점검**

Run:
```bash
grep -rn "game_entry_gate\|background_service\|session\|/game\|app_dialog" \
  lib/core/services/location lib/core/services/permission --include='*.dart' || echo "CLEAN"
```
Expected: `CLEAN`. (`location_permission_service`가 `app_dialog`에 결합돼 있으면 app_dialog는 Task 3에서 포팅됐으므로 OK. `background_service`/`game_entry_gate` 참조가 있으면 해당 부분 제거.)

- [ ] **Step 4: analyze**

Run: `flutter analyze lib/core/services/location lib/core/services/permission`
Expected: 에러 0.

- [ ] **Step 5: Commit**

```bash
git add lib/core/services/location lib/core/services/permission
git commit -m "feat: 위치·권한 서비스 포팅 (l10n → 한국어, 게임 게이트 제외)"
```

---

## Task 12: 최종 스모크 검증

**Files:** (없음 — 검증만)

- [ ] **Step 1: 전체 analyze**

Run: `flutter analyze`
Expected: 에러 0.

- [ ] **Step 2: 전체 코드 생성 재확인**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `Succeeded`.

- [ ] **Step 3: 전체 테스트**

Run: `flutter test`
Expected: 전부 PASS.

- [ ] **Step 4: 부팅 → 로그인 도달 확인**

Run: `flutter run -d <device>`
Expected: 크래시 없이 부팅 → 스플래시 → (미인증) 로그인 화면 도달. Google/Apple 버튼 표시.
(실제 로그인 성공/토큰 재발급은 **어대GO 백엔드 API 계약 + Firebase 설정(google-services.json / GoogleService-Info.plist) 확정 후** 별도 검증 — 이번 범위 아님.)

- [ ] **Step 5: 최종 커밋 (필요 시)**

```bash
git add -A
git commit -m "chore: 포팅 최종 스모크 검증 완료 (부팅 → 로그인 도달)" || echo "nothing to commit"
```

---

## 미해결/후속 (이번 범위 밖)

- **API 계약 확정**: `api_endpoints.dart` + auth/user DTO를 어대GO 백엔드 스펙으로 교체 후 로그인 실동작 검증.
- **Firebase 설정 파일**: 어대GO 전용 `google-services.json`(Android) / `GoogleService-Info.plist`(iOS) 추가.
- **UI 디자인 패스**: auth 페이지 5종 + 홈을 디자인 시스템(AppButton 프리셋, 소셜 버튼, agreement 위젯)으로 재작업.
- **후속 포팅**: STOMP/실시간, i18n(l10n), analytics, deeplink, tutorial 등 필요 시 동일 방식.
