# cops_and_robbers → 어대GO(eodaego) 선별 포팅 설계

> **작성일**: 2026-07-05
> **대상**: 어대GO(서울어린이대공원 탐방·도감 수집 앱) 프론트엔드 초기 기반 구축
> **소스 프로젝트**: `/Users/luca/workspace/Flutter_Project/cops_and_robbers`
> **대상 프로젝트**: `/Users/luca/workspace/Flutter_Project/eodaego` (패키지명 `com.elipair.eodaego`)

---

## 1. 목표 (Goal)

cops_and_robbers(경찰과 도둑, 위치 기반 실시간 게임)에서 **검증된 인프라·인증 기반 코드**를
어대GO로 선별 포팅한다. 어대GO는 현재 `lib/main.dart`만 있는 빈 Flutter 스캐폴드 상태이며,
Feature-First + Clean Architecture 구조를 그대로 채택한다.

**핵심 원칙**: 게임 전용 코드는 끌고 오지 않는다. 두 앱은 앞으로 독립적으로 진화한다
(게임 앱 vs 도감 수집 앱). 그래서 "전체 복사 후 삭제"가 아닌 **선별 복사 + 적응** 방식을 쓴다.

**이번 범위가 아닌 것**: STOMP/WebSocket, 게임 로직, 채팅, 세션, deeplink, analytics,
lifecycle, i18n(l10n), ads, tutorial, app_icon. 필요해지면 같은 방식으로 추후 포팅한다.

---

## 2. 확정된 결정 사항 (사용자 확인 완료)

| 질문 | 결정 |
| --- | --- |
| 백엔드 상황 | 백엔드는 있지만 **API 계약이 다르거나 미정**. → 구조(interceptor, repository 패턴)는 그대로, 엔드포인트/DTO만 나중에 맞춤 |
| 추가 core 모듈 | **Remote Config 세트** + **위치/권한 서비스** 포함 |
| auth 깊이 | **로직 전체(data/domain/providers) + 페이지 뼈대** (플로우·라우팅 로직만 유지, UI는 어대GO 디자인으로 추후 재작업) |
| user feature | **포함** (닉네임 중복확인, 약관동의, 마이페이지, 계정삭제 로직 — auth 플로우가 의존) |
| 포팅 방식 | **A. 선별 복사 + 적응** (파일 단위 복사 → import/패키지명 수정 → 게임 종속 제거 → 단계별 컴파일 검증) |

---

## 3. 목표 디렉토리 구조

```
lib/
├── core/
│   ├── config/            env_config.dart
│   ├── constants/         api_endpoints.dart (값은 TODO), app_colors.dart,
│   │                      text_styles.dart, spacing_and_radius.dart
│   │                      ※ 파일 패턴은 cops와 동일, 값은 어대GO 디자인 시스템 토큰으로 신규 작성
│   ├── errors/            app_exception.dart
│   ├── network/           dio_client.dart, auth_interceptor.dart,
│   │                      dio_exception_handler.dart, api_error_response.dart
│   ├── services/
│   │   ├── fcm/           firebase_messaging_service.dart, local_notifications_service.dart
│   │   ├── device/        device_id_manager.dart, device_info_service.dart
│   │   ├── location/      device_location_service.dart
│   │   ├── permission/    location_permission_service.dart, location_permission_messages.dart
│   │   └── remote_config/ remote_config_service.dart, app_version_checker.dart,
│   │                      update_dialog_helper.dart
│   ├── storage/           secure_token_storage.dart
│   └── widgets/           app_button.dart, app_dialog.dart, app_text_field.dart,
│                          app_snackbar.dart (어대GO 스타일), force_update_page.dart,
│                          maintenance_page.dart
├── features/
│   ├── auth/
│   │   ├── data/          datasources(auth_remote, firebase_auth), models(login/logout/reissue),
│   │   │                  repositories(auth_repository_impl)
│   │   ├── domain/        constants(social_provider), entities(auth_result),
│   │   │                  repositories(auth_repository), usecases(google/apple/signout),
│   │   │                  utils(firebase_auth_error_handler)
│   │   └── presentation/  providers(auth/agreement/token), pages(splash/onboarding/login/
│   │                      agreement/nickname 뼈대), widgets(agreement 계열)
│   └── user/
│       ├── data/          datasources(user_remote), models(agreement/nickname/mypage/delete)
│       │                  repositories(user_repository_impl)
│       ├── domain/        entities(agreement_status/user_profile), repositories(user_repository),
│       │                  usecases(delete_account)
│       └── presentation/  providers(user_provider)
├── router/                app_router.dart(인증 플로우만), route_paths.dart(인증 라우트만)
└── main.dart              부트스트랩
```

---

## 4. 적응(수정) 사항 — 그대로 복사하면 안 되는 부분

| 항목 | 처리 방침 |
| --- | --- |
| **패키지명** | `package:cops_and_robbers/` → `package:eodaego/` 전 파일 일괄 치환 |
| **l10n/i18n** | cops는 `AppLocalizations`(l10n) + `error_message_mapper` 사용. 어대GO는 이번에 i18n 미포팅 → **한국어 하드코딩 문자열로 치환**. 영향 파일: `app_exception.dart`, `dio_exception_handler.dart`, `location_permission_messages.dart`, auth 페이지들(splash/agreement/login/nickname), agreement 위젯들 |
| **게임 종속 코드** | `permission/game_entry_gate.dart` 제외. user DTO의 게임 푸시 동의(`game_push_agreement_model`) 등 게임 전용 필드는 확인 후 제거 또는 범용화 |
| **디자인 토큰** | `app_colors`/`text_styles`/`spacing_and_radius`를 어대GO 디자인 시스템(`.claude/rules/UI_Design_System.md`) 값으로 **신규 작성**. AppButton은 353×56 / 16.r / label-16-semibold 프리셋 스펙으로 적응 |
| **role_theme** | **미포팅**. cops는 팀별(경찰/도둑) 다크·라이트 전환이 있으나 어대GO는 단일 라이트 테마(웜 아이보리 캔버스) |
| **ScreenUtil designSize** | cops가 이미 `Size(393, 852)` 사용 → **그대로 유지** (디자인 문서의 button-w 353 = 393−좌우패딩 20×2와 일치) |
| **API 계약** | 구조 유지. `api_endpoints.dart`의 URL 값에 `// TODO: 백엔드 계약 확정 시 교체` 표시. DTO 필드도 확정 전까지 cops 계약 기준으로 두되 주석 표기 |
| **Firebase 설정** | 어대GO 전용 `google-services.json`(Android) / `GoogleService-Info.plist`(iOS)가 별도 필요. FCM/Auth 실동작은 이 설정 완료 후 검증 |
| **.env** | 어대GO `.env.example`은 `API_BASE_URL`, `GOOGLE_MAPS_API_KEY`만 있음. cops의 `WS_URL`은 이번 범위 아님(STOMP 미포팅) → env_config에서 `webSocketUrl` getter 제외 |

---

## 5. main.dart 부트스트랩 (cops 패턴 유지, 게임 요소 제거)

순서:
1. `WidgetsFlutterBinding.ensureInitialized()`
2. 릴리스 빌드 시 `debugPrint` no-op 처리 (토큰·위치 등 민감정보 로그 노출 방지)
3. `SecureTokenStorage().clearTokensIfReinstalled()` (재설치 시 iOS Keychain 잔존 토큰 정리)
4. `EnvConfig.initialize()` (.env 로드)
5. 세로 방향 고정 (`SystemChrome.setPreferredOrientations([portraitUp])`)
6. Firebase init (10초 타임아웃, 실패해도 앱 실행 계속) + Crashlytics 에러 핸들러 등록
7. FCM 서비스 / 로컬 알림 서비스 초기화
8. `runApp(ProviderScope(child: ScreenUtilInit(designSize: Size(393,852), child: MaterialApp.router(...))))`

**변경점**:
- cops는 main() 진입 즉시 위치 권한을 요청하나, 어대GO는 **지도/촬영 진입 시점으로 미룸**
  (아동 대상 앱 심사 및 UX상 유리). main에서는 위치 권한 요청 제거.
- `pending_invite_provider`(게임 초대 딥링크) 및 deeplink 서비스 관련 부팅 코드 제거.
- `locale_provider` / `AppLocalizations` / `app_icon` observer 관련 코드 제거.

---

## 6. 실행 순서 + 단계별 검증

각 단계 완료 시 `flutter analyze` 0 error + `dart run build_runner build --delete-conflicting-outputs`
성공을 확인한 뒤 다음 단계로 진행한다.

1. **부트스트랩 기반**: `main.dart` + `config/env_config` + `errors/app_exception` +
   `constants`(어대GO 디자인 토큰: app_colors/text_styles/spacing_and_radius) + `.env`/`.env.example` 정비
2. **네트워크/스토리지**: `network` 4종(dio_client, auth_interceptor, dio_exception_handler,
   api_error_response) + `storage/secure_token_storage` + `constants/api_endpoints`(TODO 표시)
   → 관련 테스트 이관(auth_interceptor_retry, dio_exception_handler, api_error_response,
   network_failure_detector, secure_token_storage_is_new_user)
3. **auth + user 로직**: data/domain/providers 전체 + `router`(인증 플로우 라우트만) +
   auth 페이지 뼈대(플로우·라우팅 유지, UI는 최소) → 로직 테스트 이관
   (agreement_provider, auth_notifier_agreement, user_repository/model/entity 계열).
   cops의 페이지 UI 골든/위젯 테스트(splash_offline_ui, login_page 등)는 제외
4. **FCM**: `services/fcm` 2종(firebase_messaging_service, local_notifications_service) +
   `services/device` 2종(device_id_manager, device_info_service — FCM 토큰 등록에 사용)
5. **Remote Config 세트**: `services/remote_config` 3종 + `widgets/app_dialog` +
   `widgets/pages`(force_update_page, maintenance_page) + 관련 라우트(maintenance, forceUpdate)
6. **위치/권한**: `services/location/device_location_service` +
   `services/permission`(location_permission_service, location_permission_messages)
7. **최종 스모크**: 앱 부팅 → 스플래시 → 로그인 페이지 도달 확인.
   (실제 로그인 성공/토큰 재발급은 **백엔드 API 계약 + Firebase 설정 확정 후** 별도 검증)

**안전망**: cops에 위 모듈들의 테스트가 이미 존재(총 76개 중 network/storage/auth/user 계열)하므로
로직 테스트를 같이 이관해 포팅 회귀를 잡는다.

---

## 7. 의존성 (pubspec) 확인

어대GO `pubspec.yaml`에 포팅 대상이 요구하는 패키지가 **모두 존재**한다:
`dio`, `retrofit(4.7.3 고정)`, `flutter_riverpod`, `freezed_annotation`, `json_annotation`,
`google_sign_in`, `sign_in_with_apple`, `firebase_core/auth/messaging/remote_config/crashlytics`,
`flutter_local_notifications`, `flutter_secure_storage`, `shared_preferences`, `flutter_dotenv`,
`geolocator`, `connectivity_plus`, `device_info_plus`, `package_info_plus`, `flutter_screenutil`,
`go_router`, `uuid`, `clock`. → **pubspec 추가 변경 없음** (STOMP·지도 등 미사용분은 이미 있어도 무방).

dev: `build_runner`, `riverpod_generator`, `freezed`, `json_serializable`, `retrofit_generator`,
`mocktail`, `fake_async` 모두 존재. → 코드 생성·테스트 도구도 충족.

---

## 8. 리스크 & 미해결 항목

- **API 계약 미정**: `api_endpoints.dart`와 auth/user DTO는 cops 계약을 임시 기준으로 둔다.
  백엔드 확정 시 DTO 필드·엔드포인트를 교체해야 하며, 이 시점 전까지 **로그인 실동작 검증 불가**.
  단계 7 스모크는 "로그인 페이지 도달"까지만 검증 목표로 한다.
- **Firebase 설정 파일**: 어대GO 전용 google-services.json / GoogleService-Info.plist가
  없으면 Firebase init이 실패한다(앱은 계속 실행되도록 설계됨). 소셜 로그인·FCM 실검증은 설정 후.
- **i18n 하드코딩**: 지금은 한국어 하드코딩으로 치환하나, 어대GO가 추후 다국어를 원하면
  cops의 error_message_mapper/l10n 패턴을 별도 포팅해야 한다(이번 범위 아님).
- **디자인 토큰 미완성**: constants 3종은 디자인 시스템 문서 기준으로 신규 작성하되,
  실제 화면 UI 완성은 이후 별도 작업. 이번엔 "컴파일되고 플로우가 도는" 수준까지만.
