# Firebase/FlutterFire 연동 및 iOS 푸시·소셜 로그인 네이티브 설정

### 📌 작업 개요

FlutterFire 설정 파일을 추가해 앱 초기화에 반영하고, Android/iOS 양 플랫폼에 Firebase(FCM 푸시·Crashlytics)와 Google/Apple 소셜 로그인을 위한 네이티브 설정을 구성했다.

### ✅ 구현 내용

**1. FlutterFire 초기화 (Dart)**

- `lib/firebase_options.dart` 신규 — FlutterFire CLI가 생성한 플랫폼별 옵션 (Android/iOS)
  - `projectId`: `eodaego-6e6fe`, `messagingSenderId`: `294662201113`
  - `apiKey`: `{FIREBASE_API_KEY}` (클라이언트 식별용 공개 키)
- `lib/main.dart` — `Firebase.initializeApp()`에 `DefaultFirebaseOptions.currentPlatform` 적용 (기존 10초 타임아웃 유지)

**2. Android 빌드 설정**

- `android/settings.gradle.kts` — `com.google.gms.google-services` 4.4.2, `com.google.firebase.crashlytics` 3.0.2 플러그인 선언 (`apply false`)
- `android/app/build.gradle.kts` — 위 두 플러그인 적용

**3. iOS 네이티브 설정**

- `ios/Runner/Runner.entitlements` 신규 — `aps-environment: development`(푸시), `com.apple.developer.applesignin`(Apple 로그인)
- `ios/Runner.xcodeproj/project.pbxproj` — 3개 빌드 구성에 `CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements` 연결
- `ios/Runner/Info.plist`
  - Google 로그인용 URL 스킴(`CFBundleURLTypes`) 및 `GIDClientID` 추가
  - `ITSAppUsesNonExemptEncryption=false`, `CADisableMinimumFrameDurationOnPhone`, `UIApplicationSupportsIndirectInputEvents` 키 위치 정리

### ⚠️ 참고 사항

- `firebase_options.dart`의 `apiKey`는 Firebase 클라이언트 식별용 공개 키로 커밋 대상에 포함(표준 FlutterFire 관행). 실제 접근 제어는 Firebase 보안 규칙에서 수행.
- `google-services.json` / `GoogleService-Info.plist`는 저장소에 포함하지 않고 CI Secret으로 주입 (07_CICD_GUIDE 준수).
- iOS entitlements의 `aps-environment`는 `development` — 배포 빌드 전 `production` 여부 확인 필요.
