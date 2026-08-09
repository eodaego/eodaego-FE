---
name: google-maps-setup
description: Google Maps API Key 설정 — Android local.properties, iOS Maps.xcconfig, 키 주입 흐름, CI 환경변수 주입. 지도 관련 빌드 오류나 신규 환경 세팅 시 사용.
---

# Google Maps API Key 설정 가이드

Google Maps SDK 사용을 위한 API Key 설정 방법입니다.
양 플랫폼 모두 변수명은 **`MAPS_API_KEY`** 하나로 통일되어 있습니다.

---

## 1. API Key 발급

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. **APIs & Services > Credentials > CREATE CREDENTIALS > API key**
3. 플랫폼별로 **키를 각각 발급**합니다 (CI 시크릿이 분리되어 있음)

### 필수: API Key 제한 설정

- **Android**: 앱 패키지명(`com.elipair.eodaego`) + SHA-1 인증서 지문
- **iOS**: 앱 번들 ID

---

## 2. Android 설정

`android/local.properties`에 다음 줄을 추가합니다:

```text
MAPS_API_KEY=발급받은_ANDROID_KEY
```

> `local.properties`는 `.gitignore`에 포함되어 커밋되지 않습니다.

### 키 주입 흐름

```text
local.properties (MAPS_API_KEY=xxx)
       ↓
android/app/build.gradle.kts (manifestPlaceholders["MAPS_API_KEY"])
       ↓
AndroidManifest.xml (com.google.android.geo.API_KEY = ${MAPS_API_KEY})
       ↓
Google Maps SDK 초기화
```

---

## 3. iOS 설정

템플릿을 복사한 뒤 실제 키를 입력합니다:

```bash
cp ios/Flutter/Maps.xcconfig.example ios/Flutter/Maps.xcconfig
```

```text
MAPS_API_KEY=발급받은_IOS_KEY
```

> `Maps.xcconfig`는 `ios/.gitignore`에 포함되어 커밋되지 않습니다.

### 키 주입 흐름

```text
Maps.xcconfig (MAPS_API_KEY=xxx)
       ↓
Debug.xcconfig / Release.xcconfig (#include? "Maps.xcconfig")
       ↓
Info.plist (GoogleMapsAPIKey = $(MAPS_API_KEY))
       ↓
AppDelegate.swift (Bundle에서 읽어 GMSServices.provideAPIKey 호출)
       ↓
Google Maps SDK 초기화
```

---

## 4. 빠른 설정 체크리스트

- [ ] `android/local.properties`에 `MAPS_API_KEY` 추가
- [ ] `ios/Flutter/Maps.xcconfig.example` → `Maps.xcconfig` 복사 후 키 입력

---

## 5. 트러블슈팅

### 지도가 빈 화면으로 뜸 (에러 없이 조용히 실패)

키 주입이 실패해도 **빌드는 성공**합니다. iOS는 `AppDelegate`가 미치환 문자열을 걸러내고, Android는 placeholder 기본값이 빈 문자열이라 그렇습니다. 아래를 순서대로 확인하세요.

1. **Android**: `grep MAPS_API_KEY android/local.properties`
2. **iOS**: 실제 빌드 설정에 값이 잡히는지 확인 (가장 확실한 검증)
   ```bash
   cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner \
     -configuration Release -showBuildSettings | grep MAPS_API_KEY
   ```
3. 캐시 클리어 후 재빌드:
   ```bash
   flutter clean && flutter pub get && flutter run
   ```

---

## 6. CI/CD 환경

**GitHub Secrets는 플랫폼별로 분리되어 있습니다.**

| 시크릿 | 사용처 |
|--------|--------|
| `GOOGLE_MAPS_API_KEY_ANDROID` | `PROJECT-FLUTTER-ANDROID-PLAYSTORE-CICD.yaml` |
| `GOOGLE_MAPS_API_KEY_IOS` | `PROJECT-FLUTTER-IOS-TESTFLIGHT.yaml`, `PROJECT-FLUTTER-IOS-TEST-TESTFLIGHT.yaml` |

두 워크플로우 모두 **빌드를 수행하는 잡 안에서** 설정 파일을 직접 생성하며, 시크릿이 비어 있으면 즉시 실패합니다.

```yaml
# Android — build-android 잡
- name: Create Google Maps config
  env:
    GOOGLE_MAPS_API_KEY_ANDROID: ${{ secrets.GOOGLE_MAPS_API_KEY_ANDROID }}
  run: |
    if [ -z "$GOOGLE_MAPS_API_KEY_ANDROID" ]; then
      echo "::error::GOOGLE_MAPS_API_KEY_ANDROID secret is required"
      exit 1
    fi
    printf '\nMAPS_API_KEY=%s\n' "$GOOGLE_MAPS_API_KEY_ANDROID" >> android/local.properties

# iOS — build-ios 잡
- name: Create Google Maps config
  env:
    GOOGLE_MAPS_API_KEY_IOS: ${{ secrets.GOOGLE_MAPS_API_KEY_IOS }}
  run: |
    if [ -z "$GOOGLE_MAPS_API_KEY_IOS" ]; then
      echo "::error::GOOGLE_MAPS_API_KEY_IOS secret is required"
      exit 1
    fi
    printf 'MAPS_API_KEY=%s\n' "$GOOGLE_MAPS_API_KEY_IOS" > ios/Flutter/Maps.xcconfig
```

> **주의**: 설정 파일 생성은 반드시 `flutter build`·`xcodebuild archive`보다 **앞선** 스텝이어야 합니다.
> 별도 잡에서 만들어 아티팩트로 넘기는 방식은 전달이 어긋나면 키 없는 빌드가 조용히 나가므로 쓰지 않습니다.
