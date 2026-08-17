# Firebase 초기 설정 — 연동 · Crashlytics · FCM · Remote Config

### 📌 작업 개요

앱에 Firebase 플랫폼을 초기 연동하고 Crashlytics · FCM · Remote Config를 배선했다. Android/iOS 네이티브 설정과 Google/Apple 소셜 로그인 구성을 포함한다. Remote Config는 버전 게이트·점검 모드 파라미터를 서버에서 원격 제어하도록 구성했으며, AdMob은 미사용으로 전 구간에서 제외했다.

### ✅ 구현 내용

#### 1. FlutterFire 초기화 (Dart)

- `lib/firebase_options.dart` 신규 — FlutterFire CLI 생성 플랫폼별 옵션 (Android/iOS)
  - `projectId`: `eodaego-6e6fe`, `messagingSenderId`: `294662201113`
  - `apiKey`: `{FIREBASE_API_KEY}` (클라이언트 식별용 공개 키)
- `lib/main.dart` — `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` + 10초 타임아웃, 실패해도 앱 실행 계속 (fail-safe)

#### 2. Android 빌드 설정

- `android/settings.gradle.kts` — `com.google.gms.google-services` 4.4.2, `com.google.firebase.crashlytics` 3.0.2 (`apply false`)
- `android/app/build.gradle.kts` — 위 두 플러그인 적용

#### 3. iOS 네이티브 설정

- `ios/Runner/Runner.entitlements` 신규 — `aps-environment: development`(푸시), `com.apple.developer.applesignin`(Apple 로그인)
- `ios/Runner.xcodeproj/project.pbxproj` — 3개 빌드 구성에 `CODE_SIGN_ENTITLEMENTS` 연결
- `ios/Runner/Info.plist` — Google 로그인 URL 스킴(`CFBundleURLTypes`) + `GIDClientID`, 인코딩 미사용 선언 등

#### 4. Crashlytics

- `lib/main.dart` — `FlutterError.onError` + `PlatformDispatcher.onError` → `recordError`(릴리스 전용), 디버그 빌드는 수집 off. gradle 플러그인 등록 포함.

#### 5. Remote Config 초기화 배선 + ads 제거·상수화 (#2)

- `lib/core/services/remote_config/remote_config_keys.dart` 신규 — `RemoteConfigKeys`(키 5종) + `RemoteConfigDefaults`(fail-safe 기본값)
- `lib/core/services/remote_config/remote_config_service.dart` — 매직스트링 → 상수 참조, `ads_enabled` 파라미터·게터·디버그 로그·문서 전부 제거
- `lib/main.dart` — 부팅 시퀀스(FCM 다음)에 `unawaited(RemoteConfigService.instance.initialize())` 비차단 fetch 배선 (`isFirebaseInitialized` 가드)
- `lib/features/auth/presentation/pages/splash_page.dart` — 버전 게이트 TODO 정정 (initialize는 배선 완료, check→라우팅만 미배선)

### 🔧 주요 변경사항 상세

#### Remote Config 파라미터 (콘솔 = 코드 상수 5종)

`minimum_version`(String) / `latest_version`(String) / `force_update`(bool) / `maintenance`(bool) / `maintenance_message`(String).
fetch 간격: 릴리스 1시간 / 디버그 0초, 타임아웃 10초. fetch 실패 시 `RemoteConfigDefaults.values`로 fail-safe 진행(앱 미차단).

**특이사항**:

- `unawaited` 비차단 배선 — 첫 프레임/스플래시를 막지 않는다. 버전 게이트 라우팅(`AppVersionChecker.check()` → maintenance/force-update 페이지)은 다음 사이클로 분리.
- AdMob 미사용 — `google_mobile_ads`는 pubspec 주석 처리, Remote Config `ads_enabled`도 제거.

### 📌 참고사항 / 확인 필요

- **Firebase 콘솔**: 파라미터 5종 생성 완료 — 단 **"변경사항 게시(Publish)"** 를 눌러야 라이브 적용됨. `maintenance_message`의 테스트 문구는 실서비스 전 실제 문구로 교체하거나 비운다.
- **Android API 키 제한에 Remote Config API 포함 확인** — 누락 시 fetch forbidden → 서버값 미수신(조용한 실패). 원인이 코드가 아닌 Cloud Console 키 제한.
- **iOS `aps-environment`는 `development`** — 배포 빌드 전 `production` 여부 확인.
- `google-services.json` / `GoogleService-Info.plist`는 저장소 미포함, CI Secret 주입 (07_CICD_GUIDE 준수).
- **Analytics**: 네이티브 자동수집만 유지 — 커스텀 이벤트용 Dart 서비스는 미도입.
- `firebase_options.dart`의 `apiKey`는 클라이언트 식별용 공개 키로 커밋 대상 포함(표준 FlutterFire 관행). 실제 접근 제어는 Firebase 보안 규칙에서 수행.
