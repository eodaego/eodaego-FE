# 안 죽는 로그아웃 + 로그인 화면 AppSnackbar 통일 — 설계

> **작성일**: 2026-07-08
> **상태**: 승인됨 (구현 대기)
> **참고 구현**: `/Users/luca/workspace/Flutter_Project/cops_and_robbers` auth

---

## 1. 문제 / 배경

- 현재 로그아웃은 임시 홈 화면(`home_page.dart`)의 **fire-and-forget 버튼**으로만 존재한다. `await`도 실패 처리도 없다.
- `AuthRepositoryImpl.signOut()`은 **Firebase 로그아웃이 throw하면 토큰 삭제 단계를 건너뛰고** 예외를 던진다(cops에서 그대로 이식된 약점). 로컬에 토큰이 남을 수 있다.
- `AuthNotifier.signOut()`은 실패 시 `AsyncValue.error`로 끝난다. 라우터 redirect는 `auth.value`가 error를 rethrow하는 것을 try-catch로 받아 로그인으로 보내지만, 사용자에겐 **아무 안내가 없고** 상태 흐름이 지저분하다(로그아웃 실패인데 로그인으로 이동, 토큰 잔존 가능).
- 로그인 화면(`login_page.dart`)의 강제 로그아웃/세션 만료 안내는 앱 공용 `AppSnackbar`가 아니라 **기본 `ScaffoldMessenger` SnackBar**로 표시된다.

## 2. 목표 / 비목표

**목표**
1. 로그아웃이 **어떤 경우에도 앱을 멈추지 않는다**. 백엔드·Firebase 실패와 무관하게 **로컬 정리(토큰 삭제)를 항상 완료**하고 로그인 화면으로 이동한다.
2. 로그아웃 결과(성공/예상 밖 오류)와 강제 로그아웃 사유를 **로그인 화면에서 `AppSnackbar`로 통일**해 안내한다.

**비목표**
- 확인 다이얼로그 / 로딩 팝업(cops의 `AppDialog.confirm`, `AppPopup.showRandomLoading`) 이식 — eodaego에 해당 인프라가 없고 로그아웃이 임시 홈 버튼이라 범위 제외. 추후 설정 화면 생기면 별도 작업.
- 로그아웃 버튼의 최종 UI/위치 — 임시 홈 버튼 유지.
- i18n — eodaego는 아직 미도입. 안내 문구는 한국어 상수로 처리.

## 3. 설계

### 3.1 원칙
- 로그아웃의 본질은 **로컬 상태 정리**다. 원격(백엔드/Firebase) 실패는 무시하고 진행한다.
- `AuthNotifier.signOut()`은 **rethrow하지 않고 최종적으로 항상 `AsyncValue.data(null)`**(로그아웃 완료)로 끝난다. auth가 error 상태로 끝나지 않으므로 라우터의 `.value` 재던짐·앱 멈춤이 **원천적으로 발생하지 않는다**.
- 모든 안내는 **로그인 화면 단일 지점**에서 `AppSnackbar`로 표시한다(로그아웃 원화면은 redirect로 언마운트되므로 그 화면에서 띄우지 않는다).

### 3.2 컴포넌트 변경

#### (1) `lib/features/auth/data/repositories/auth_repository_impl.dart` — `signOut()` 방탄화
단계별 개별 try-catch로 재구성한다.
- **백엔드 로그아웃**: 실패해도 로그만 남기고 진행 (기존 유지).
- **Firebase 로그아웃**: 실패해도 로그만 남기고 진행 (기존엔 여기서 throw하며 토큰 삭제를 스킵 → 제거).
- **토큰 삭제**: 항상 실행.

```dart
Future<void> signOut() async {
  // 1. 백엔드 로그아웃 (실패 무시)
  try {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken != null) {
      await _authRemoteDataSource.logout(LogoutRequestModel(refreshToken: refreshToken));
    }
  } catch (e) {
    debugPrint('⚠️ 백엔드 로그아웃 실패 (무시): $e');
  }

  // 2. Firebase 로그아웃 (실패 무시 — 로컬 정리 우선)
  try {
    await _firebaseAuthDataSource.signOut();
  } catch (e) {
    debugPrint('⚠️ Firebase 로그아웃 실패 (무시): $e');
  }

  // 3. 로컬 토큰 삭제 (반드시 실행)
  await _tokenStorage.clearTokens();
}
```
→ 이제 `signOut()`은 **토큰 삭제 자체가 실패하는 극히 드문 경우에만** throw한다.

#### (2) `lib/features/auth/presentation/providers/auth_provider.dart` — `AuthNotifier.signOut()`
```dart
Future<void> signOut() async {
  state = const AsyncValue.loading();
  try {
    await ref.read(signOutUseCaseProvider).execute();
    ref.read(loginNoticeKeyProvider.notifier).state = 'logoutSuccess';
  } catch (e) {
    // repo가 로컬 정리를 best-effort로 이미 수행(백엔드·Firebase 무시, 토큰삭제 실행).
    // 여기 도달 = 토큰삭제 자체 실패 등 극히 드문 경우 → 재시도 무의미, 안내만.
    debugPrint('⚠️ 로그아웃 중 예상 밖 오류: $e');
    ref.read(loginNoticeKeyProvider.notifier).state = 'logoutUnexpected';
  } finally {
    state = const AsyncValue.data(null); // 항상 로그아웃 완료 상태
  }
}
```
핵심: **`finally`에서 항상 `data(null)`** → 라우터가 안전하게 로그인으로 이동. 예외는 UI로 전파되지 않는다. Firebase 세션은 repo 2단계에서 이미 정리되므로, 토큰이 극히 드물게 잔존해도 `AuthNotifier.build()`의 `currentUser == null` 검사로 로그아웃 상태가 유지된다.

#### (3) 로그인 화면 안내 채널 — 리네임 + 확장
`forceLogoutMessageKeyProvider` → **`loginNoticeKeyProvider`**로 리네임(의미: "로그인 화면에 띄울 안내 키").
- 정의: `lib/core/network/dio_client.dart:21` (`StateProvider<String?>`)
- 사용: `auth_provider.dart`(강제 로그아웃 콜백에서 set), `login_page.dart`(read/clear)
- **별개 프로바이더 `forceLogoutCallbackNotifierProvider`(로그아웃 콜백)는 리네임하지 않는다.**

안내 키 값:
| 키 | 발생 | 문구(한국어) | 색 |
|---|---|---|---|
| `logoutSuccess` | 정상 로그아웃 | 로그아웃되었습니다 | `AppColors.ink` (기본) |
| `logoutUnexpected` | 로그아웃 중 예상 밖 오류 | 로그아웃 중 문제가 있었어요 | `AppColors.danger` |
| `errorAuthExpired` | 강제 로그아웃(세션 만료) | 세션이 만료되었어요. 다시 로그인해 주세요. | `AppColors.danger` |
| `errorTemporaryRetry` | 강제 로그아웃(일시 오류) | 일시적인 오류가 발생했어요. 다시 시도해 주세요. | `AppColors.danger` |

#### (4) `lib/features/auth/presentation/pages/login_page.dart`
- (a) 기본 `ScaffoldMessenger.of(context).showSnackBar(...)` 제거 → **`AppSnackbar.show(...)`** 로 교체.
- (b) **화면 mount 시(`WidgetsBinding.instance.addPostFrameCallback`) 대기 중인 키를 `ref.read` → 표시 → clear.** 현재 `ref.listen`만으론 로그인 화면 mount 이전에 설정된 키(정상 로그아웃 경로)를 놓친다. cops `login_page` initState 방식으로 교정한다.
- 키 → (문구, 색) 매핑 헬퍼로 표시. 예:

```dart
(String message, Color color) _loginNotice(String key) {
  switch (key) {
    case 'logoutSuccess':      return ('로그아웃되었습니다', AppColors.ink);
    case 'logoutUnexpected':   return ('로그아웃 중 문제가 있었어요', AppColors.danger);
    case 'errorAuthExpired':   return ('세션이 만료되었어요. 다시 로그인해 주세요.', AppColors.danger);
    case 'errorTemporaryRetry':return ('일시적인 오류가 발생했어요. 다시 시도해 주세요.', AppColors.danger);
    default:                   return ('다시 로그인해 주세요.', AppColors.ink);
  }
}
```
> `login_page`는 현재 `ConsumerWidget`이다. mount 시 정확히 1회 read가 필요하므로 **`ConsumerStatefulWidget`으로 전환**하고 `initState`의 `addPostFrameCallback`에서 read→표시→clear 한다(cops `login_page`와 동일 패턴). `build`의 postFrame은 리빌드마다 재실행되어 중복 표시 위험이 있으므로 채택하지 않는다.

#### (5) `lib/features/home/presentation/pages/home_page.dart`
- 임시 로그아웃 버튼은 그대로 `ref.read(authNotifierProvider.notifier).signOut()` 호출. (`signOut()`이 안전해져 추가 처리가 필요 없다.) 성공 피드백은 로그인 화면에서 표시된다.

### 3.3 데이터 흐름
| 시나리오 | 흐름 |
|---|---|
| **정상 로그아웃** | 버튼 → `signOut()` → repo 로컬 정리 완료 → 키=`logoutSuccess` → `data(null)` → 라우터 로그인 이동 → 로그인 화면이 키 read → "로그아웃되었습니다"(ink) `AppSnackbar` |
| **예상 밖 오류** | repo throw → notifier catch → best-effort 정리 + 키=`logoutUnexpected` → `data(null)` → 로그인 → "로그아웃 중 문제가 있었어요"(danger) |
| **강제 로그아웃**(인터셉터) | 기존대로 콜백이 키 set + forceLogout → 로그인 → 사유를 `AppSnackbar`(danger)로 표시(기존 `ScaffoldMessenger`에서 승격) |

### 3.4 에러 처리 보장
- 어느 경로도 UI로 예외를 rethrow하지 않는다.
- auth는 항상 `data(null)`로 끝나므로 라우터 redirect의 `auth.value` 재던짐 → 앱 멈춤 경로가 발생하지 않는다.

## 4. 테스트 (경계만 mock: 로컬 저장소·Firebase·API)

**Repository (`auth_repository_impl_test.dart`)**
- 백엔드 로그아웃이 실패해도 `clearTokens()`가 호출되고 예외가 새지 않는다.
- Firebase 로그아웃이 실패해도 `clearTokens()`가 호출되고 예외가 새지 않는다.
- 정상 경로에서 3단계 모두 호출된다.

**Notifier (`auth_provider_test.dart`)**
- `signOut()` 이후 `state == AsyncValue.data(null)` (성공·예상밖오류 모두).
- 성공 시 `loginNoticeKeyProvider == 'logoutSuccess'`, 예상 밖 오류 시 `'logoutUnexpected'`.

**(선택) 위젯 (`login_page_test.dart`)**
- `loginNoticeKeyProvider`에 키가 있는 상태로 로그인 화면을 mount하면 해당 문구의 `AppSnackbar`가 노출되고 키가 clear된다.

## 5. 변경 파일 요약
- `lib/features/auth/data/repositories/auth_repository_impl.dart` — `signOut()` 방탄화
- `lib/features/auth/presentation/providers/auth_provider.dart` — `signOut()` 재작성 + `loginNoticeKeyProvider` 사용
- `lib/core/network/dio_client.dart` — `forceLogoutMessageKeyProvider` → `loginNoticeKeyProvider` 리네임(정의)
- `lib/features/auth/presentation/pages/login_page.dart` — `ConsumerStatefulWidget` 전환 + `initState` postFrame에서 키 read + `AppSnackbar` 표시 + 키/색 매핑
- `lib/features/home/presentation/pages/home_page.dart` — 변경 없음(또는 최소)
- (테스트) `test/features/auth/...` 신규

## 6. 미해결 사항
- 없음. (다이얼로그/로딩 팝업은 명시적 비목표.)
