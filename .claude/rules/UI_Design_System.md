---
version: 1.0
name: eodaego-design-system
description: 서울어린이대공원 탐방·도감 수집 앱 "어대GO"의 디자인 시스템. 어린이(+보호자) 타깃이라 큰 폰트, 큰 터치 영역, 둥근 형태, 색으로 읽는 정보 구조가 원칙이다. 웜 아이보리 캔버스(#FAF7F0) 위에 숲 초록(#3DA35D)을 메인으로, 도감 3분류가 고정 카테고리 컬러(동물=주황, 식물=초록, 장소=파랑)를 가지며 이 색 언어가 도감·지도 마커·촬영 모드·코스 스텝 전반을 관통한다. 보상 노랑(#FFC93C)은 도감 획득/축하 순간에만 등장하는 단일 하이라이트다. 타이포는 2폰트 체계 — 제목·버튼·도감 이름은 Cafe24 Ssurround(둥근 디스플레이), 본문·설명은 Pretendard Variable. radius는 "외부 = 내부 × 2, 패딩 = 내부 radius" 규칙 위에서 8/12/24/32 4단 스케일만 사용한다.

colors:
  # ── Brand / Category ──
  primary: "#3DA35D" # 숲 초록. 메인 CTA, 진행바, 활성 탭, 카메라 FAB
  primary-dark: "#1E6B3C" # 초록 틴트 위 텍스트, 브랜드 로고 텍스트
  primary-tint: "#E6F4EA" # 선택 상태 배경, 아바타 배경
  animal: "#F58A3C" # 동물 카테고리
  animal-dark: "#5C2A08" # 주황 틴트 위 텍스트
  animal-tint: "#FEF0E4" # 동물 칩/뱃지 배경
  plant: "#3DA35D" # 식물 카테고리 (primary 공유)
  plant-dark: "#1E6B3C"
  plant-tint: "#E6F4EA"
  place: "#4A9FE8" # 장소 카테고리
  place-dark: "#0A3A63" # 파랑 틴트 위 텍스트
  place-tint: "#E8F3FC"
  reward: "#FFC93C" # 보상 노랑. 도감 획득 축하, 핵심 CTA(코스 추천 받기)
  reward-dark: "#5F4400" # 노랑 위 텍스트

  # ── Canvas / Surface ──
  canvas: "#FAF7F0" # 앱 기본 배경 (웜 아이보리, 순백 금지)
  surface: "#FFFFFF" # 카드, 시트, 입력창
  surface-dim: "#F0EDE4" # 비활성 배경, 진행바 트랙, 오답 선택지
  camera-bg: "#20241F" # 촬영 화면 전용 다크 배경

  # ── Ink / Text ──
  ink: "#2B2B28" # 기본 텍스트 (순검정 금지)
  muted: "#6B6A64" # 보조 텍스트, 캡션
  disabled: "#9B998F" # 비활성 탭/텍스트
  uncollected: "#B9B6AC" # 미수집 도감 ? 카드
  on-primary: "#FFFFFF" # 초록/주황/파랑 위 텍스트

  # ── Border / Semantic ──
  line: "#EBE7DC" # 기본 헤어라인 (1px)
  danger: "#A32D2D" # 탈퇴 등 파괴적 액션 텍스트

typography:
  # Display = Cafe24Ssurround (단일 굵기), Body = Pretendard Variable
  display-34:
    fontFamily: "Cafe24Ssurround"
    fontSize: 34sp
    lineHeight: 1.2
    use: "로그인 화면 앱 로고 타이틀"
  display-26:
    fontFamily: "Cafe24Ssurround"
    fontSize: 26sp
    lineHeight: 1.25
    use: "도감 상세 이름, 축하 화면 타이틀"
  display-24:
    fontFamily: "Cafe24Ssurround"
    fontSize: 24sp
    lineHeight: 1.35
    use: "위저드 질문 (한 화면 한 질문)"
  display-22:
    fontFamily: "Cafe24Ssurround"
    fontSize: 22sp
    lineHeight: 1.4
    use: "퀴즈 질문"
  display-19:
    fontFamily: "Cafe24Ssurround"
    fontSize: 19sp
    lineHeight: 1.3
    use: "코스 카드 제목, 히어로 카드 문구, 앱바 타이틀"
  display-17:
    fontFamily: "Cafe24Ssurround"
    fontSize: 17sp
    lineHeight: 1.0
    use: "주요 버튼 라벨"
  display-16:
    fontFamily: "Cafe24Ssurround"
    fontSize: 16sp
    lineHeight: 1.0
    use: "섹션 카드 제목(내 도감, 공원 지도 보기), 필터 칩"
  body-17:
    fontFamily: "Pretendard"
    fontWeight: 500
    fontSize: 17sp
    lineHeight: 1.65
    letterSpacing: -0.32
    use: "어린이 눈높이 설명 본문 — 앱에서 가장 중요한 읽기 텍스트, 일반 앱보다 1~2px 크게"
  body-15:
    fontFamily: "Pretendard"
    fontWeight: 500
    fontSize: 15sp
    lineHeight: 1.6
    letterSpacing: -0.32
    use: "일반 본문, 도감 특징 설명"
  label-16-semibold:
    fontFamily: "Pretendard"
    fontWeight: 600
    fontSize: 16sp
    lineHeight: 1.0
    letterSpacing: -0.32
    use: "AppButton 기본 textStyle, 소셜 로그인 버튼, 옵션 카드 제목"
  caption-14:
    fontFamily: "Pretendard"
    fontWeight: 500
    fontSize: 14sp
    lineHeight: 1.4
    letterSpacing: -0.32
    use: "보조 설명, 수집 날짜, 위저드 서브텍스트 — 앱 전체 최소 크기"
  tag-13-bold:
    fontFamily: "Pretendard"
    fontWeight: 700
    fontSize: 13sp
    lineHeight: 1.0
    letterSpacing: -0.32
    use: "카테고리 칩(동물 10), 뱃지, 도감 카드 이름"
  tag-12-bold:
    fontFamily: "Pretendard"
    fontWeight: 700
    fontSize: 12sp
    lineHeight: 1.0
    letterSpacing: -0.32
    use: "예상 시간 뱃지, 탭바 라벨 — 장식적 최소 크기, 본문 사용 금지"

rounded:
  xs: 8 # 뱃지, 지도 게이트 라벨, 작은 칩
  sm: 12 # 도감 그리드 카드, 카드(24) 내부의 버튼·썸네일
  md: 16 # AppButton 기본, 입력창, 퀴즈 선택지
  lg: 24 # 카드(코스/도감상세/홈 카드), 다이얼로그, 촬영 가이드 프레임
  xl: 32 # 바텀시트 상단, 풀스크린 모달
  full: 999 # 카메라 FAB, 셔터, 마커, 아바타, 모드 토글, 필터 칩(pill)
  # 규칙: 외부 radius = 내부 radius × 2, 패딩 = 내부 radius
  # 페어링 체인 A: 뱃지(8) → 버튼(16) → 시트(32)
  # 페어링 체인 B: 카드 내부 요소(12) → 카드(24)
  # AppButton 기본 16은 화면/시트 루트의 풀폭 버튼 기준. 카드(24) 안에 넣을 때는 12.r 오버라이드

spacing:
  xs: 4
  sm: 8
  md: 12
  base: 16
  lg: 20 # 화면 좌우 기본 패딩
  xl: 24
  xxl: 32

touch:
  min: 48 # 모든 인터랙티브 요소 최소
  button-h: 56 # AppButton 기본 높이 (소셜 로그인 포함)
  button-w: 353 # AppButton 기본 너비 (기준폭 393 − 좌우 패딩 20×2)
  quiz-opt-h: 60 # 퀴즈 선택지
  fab: 64 # 탭바 중앙 카메라 FAB
  shutter: 78 # 카메라 셔터

components:
  app-button:
    note: "공용 AppButton 위젯의 기본값. 모든 버튼은 이 위젯 하나 + 파라미터 프리셋으로 만든다"
    width: "353.w"
    height: "56.h"
    rounded: "16.r ({rounded.md})"
    typography: "{typography.label-16-semibold}"
    backgroundColor: "{colors.primary}"
    foregroundColor: "{colors.on-primary}"
    disabledBackgroundColor: "{colors.uncollected}"
    disabledForegroundColor: "{colors.on-primary}"
    showBorder: false
    borderWidth: 1.0
    borderColor: "{colors.line}"
  button-primary:
    preset: "기본값 그대로 + textStyle: display-17"
    note: "화면당 1개 원칙"
  button-reward:
    preset: "backgroundColor: reward / foregroundColor: reward-dark / textStyle: display-17"
    note: "코스 추천 받기, 축하 화면 CTA 등 핵심 순간 전용"
  button-social-google:
    preset: "backgroundColor: surface / foregroundColor: ink / showBorder: true / icon: 구글 로고(leading)"
  button-social-apple:
    preset: "backgroundColor: ink / foregroundColor: on-primary / icon: 애플 로고(leading)"
  button-danger:
    preset: "backgroundColor: surface / foregroundColor: danger / showBorder: true / subtitle: 삭제 경고 문구"
    note: "탈퇴 등 파괴적 액션. subtitle로 Hard Delete 경고 필수"
  card:
    backgroundColor: "{colors.surface}"
    border: "1px {colors.line}"
    rounded: "{rounded.lg}"
    padding: 18
  hero-card:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.lg}"
    padding: 20
    note: "홈 최상단, 내부 CTA는 button-reward (카드 내부이므로 12.r 오버라이드)"
  option-card:
    backgroundColor: "{colors.surface}"
    border: "2px {colors.line}"
    rounded: "{rounded.lg}"
    padding: 18
    selected: "border 2px 카테고리색 + 배경 카테고리 tint"
    note: "위저드 선택지. 이모지/아이콘 30px + 제목 + 보조설명 구조"
  quiz-option:
    backgroundColor: "{colors.surface}"
    border: "2px {colors.line}"
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
    minHeight: 60
    typography: "{typography.label-16-semibold}"
  quiz-option-wrong:
    backgroundColor: "{colors.surface-dim}"
    textColor: "{colors.uncollected}"
    border: "none"
    note: "오답 시 해당 선택지만 비활성 + 취소선. 추가 설명 없음(QUIZ-03)"
  badge:
    rounded: "{rounded.xs}"
    padding: "4px 10px"
    typography: "{typography.tag-13-bold}"
    note: "배경 = 카테고리 tint, 텍스트 = 같은 계열 dark. 절대 검정 텍스트 금지"
  filter-chip:
    rounded: "{rounded.full}"
    height: 38
    typography: "{typography.display-16}"
    default: "surface 배경 + line 테두리 + muted 텍스트"
    active: "ink 배경 + on-primary 텍스트"
  tab-bar:
    backgroundColor: "{colors.surface}"
    border-top: "1px {colors.line}"
    active: "{colors.primary-dark}"
    inactive: "{colors.disabled}"
    typography: "{typography.tag-12-bold}"
  camera-fab:
    backgroundColor: "{colors.primary}"
    rounded: "{rounded.full}"
    size: 64
    note: "탭바 중앙, 탭바 위로 -34 돌출, canvas색 5px 링"
  shutter:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.full}"
    size: 78
    border: "6px 현재 촬영 모드의 카테고리색"
  mode-toggle:
    rounded: "{rounded.full}"
    default: "rgba(255,255,255,.15) 배경 + 흰 텍스트"
    active: "카테고리색 배경"
    typography: "{typography.display-16}"
  dogam-card:
    aspectRatio: "3 / 3.6"
    backgroundColor: "{colors.surface}"
    border: "2px 카테고리색"
    rounded: "{rounded.sm}"
  dogam-card-locked:
    backgroundColor: "{colors.surface-dim}"
    border: "none"
    textColor: "{colors.uncollected}"
    note: "? 를 Cafe24Ssurround 34px로 표시. 실루엣만 노출"
  map-marker:
    rounded: "{rounded.full}"
    size: 34
    border: "3px {colors.surface}"
    typography: "Cafe24Ssurround 15"
    note: "배경 = 카테고리색, 코스 순서 숫자 표시"
  bottom-sheet:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.xl} {rounded.xl} 0 0"
    grabber: "44x5 line색"
  progress-bar:
    track: "{colors.surface-dim}"
    fill: "{colors.primary}"
    height: 12
    rounded: 6
---

# 어대GO 디자인 시스템

## Overview

어대GO는 어린이가 서울어린이대공원을 탐험하며 동물·식물·장소 도감을 모으는 앱이다. 디자인의 모든 결정은 세 가지 원칙에서 나온다.

**1) 색이 곧 정보 구조다.** 도감의 3분류가 고정 카테고리 컬러를 가진다 — 동물 `{colors.animal}`(주황), 식물 `{colors.plant}`(초록), 장소 `{colors.place}`(파랑). 이 색은 도감 카드 테두리, 지도 마커, 촬영 모드 토글과 셔터 링, 코스 스텝 번호, 카테고리 칩까지 앱 전체에서 동일하게 적용된다. 글을 읽지 못하는 아이도 색만 보고 카테고리를 인식할 수 있어야 하므로, 카테고리 컬러를 다른 용도로 유용하거나 화면마다 다르게 쓰는 것을 금지한다.

**2) 보상 노랑은 아껴 쓴다.** `{colors.reward}`(#FFC93C)는 앱에서 가장 뜨거운 색으로, 등장 자체가 "특별한 순간"의 신호다. 허용 위치는 딱 두 곳 — 홈 히어로 카드의 "코스 추천 받기" CTA, 그리고 퀴즈 정답 시 도감 획득 축하 화면(전면 배경). 그 외 어디에도 노랑을 쓰지 않는다.

**3) 어린이 기준으로 모든 수치를 키운다.** 본문 최소 15sp(핵심 설명은 17sp), 캡션 최소 14sp, 터치 타깃 최소 48, 주요 버튼 52 이상. 배경은 순백이 아닌 웜 아이보리 `{colors.canvas}`로 종이 그림책 질감을 내고, 텍스트는 순검정이 아닌 `{colors.ink}`(#2B2B28)를 쓴다.

## Colors

### 카테고리 컬러 페어링 규칙

틴트 배경 위 텍스트는 **반드시 같은 계열의 dark 스톱**을 쓴다. 검정이나 회색 텍스트를 틴트 위에 올리는 것을 금지한다.

| 배경                           | 텍스트                         | 예시                    |
| ------------------------------ | ------------------------------ | ----------------------- |
| `{colors.animal-tint}` #FEF0E4 | `{colors.animal-dark}` #5C2A08 | "동물 10" 칩, 동물 뱃지 |
| `{colors.plant-tint}` #E6F4EA  | `{colors.plant-dark}` #1E6B3C  | "식물 8" 칩, 선택 상태  |
| `{colors.place-tint}` #E8F3FC  | `{colors.place-dark}` #0A3A63  | "장소 6" 칩             |
| `{colors.reward}` #FFC93C      | `{colors.reward-dark}` #5F4400 | 노랑 CTA, 축하 화면     |
| 카테고리 원색 (solid)          | `{colors.on-primary}` #FFFFFF  | 마커, 버튼, 스텝 번호   |

위 조합은 모두 WCAG AA(4.5:1) 이상을 만족한다. 야외 햇빛 환경에서 사용하는 앱이므로 이 기준을 낮추지 않는다.

### 상태 컬러

- **미수집** `{colors.uncollected}` #B9B6AC — 도감 `?` 카드 전용. 미수집은 무채색+실루엣, 수집 완료는 카테고리 컬러 풀 적용으로 대비를 만들어 수집 동기를 시각화한다.
- **비활성** `{colors.disabled}` #9B998F — 탭바 비활성 아이콘/라벨.
- **파괴적 액션** `{colors.danger}` #A32D2D — 탈퇴하기 텍스트에만 사용. 탈퇴는 Hard Delete이므로 보조 설명("모든 기록이 완전히 삭제돼요")을 항상 동반한다.
- **촬영 배경** `{colors.camera-bg}` #20241F — 카메라 화면만 다크. 나머지 화면에 다크 배경 금지.

## Typography

### 2폰트 체계

| 역할    | 폰트                | 파일                       | 쓰는 곳                                                                  |
| ------- | ------------------- | -------------------------- | ------------------------------------------------------------------------ |
| Display | Cafe24 Ssurround    | `Cafe24Ssurround-v2.0.ttf` | 앱 타이틀, 화면 제목, 질문(위저드·퀴즈), 버튼 라벨, 도감 이름, 마커 숫자 |
| Body    | Pretendard Variable | `PretendardVariable.ttf`   | 본문, 설명, 캡션, 칩/뱃지, 탭 라벨                                       |

Ssurround는 단일 굵기 디스플레이 폰트이므로 **크기로만 위계를 만든다**(34/26/24/22/19/17/16). Pretendard는 Variable이므로 weight 400·500·600·700을 쓰되, 본문 기본은 Medium(500)이다 — 어린이 가독성 기준으로 Regular보다 Medium이 낫다. Ssurround를 본문 긴 글에 쓰는 것을 금지한다(어린이 눈높이 설명은 반드시 Pretendard 17sp).

letterSpacing은 Pretendard 계열에 -0.32 고정, Ssurround는 0(폰트 자체가 넉넉한 자간을 가짐).

### Flutter 정의 예시

pubspec.yaml 등록:

```yaml
fonts:
  - family: Cafe24Ssurround
    fonts:
      - asset: assets/fonts/Cafe24Ssurround-v2.0.ttf
  - family: Pretendard
    fonts:
      - asset: assets/fonts/PretendardVariable.ttf
```

AppTextStyles 패턴 (flutter_screenutil 기준):

```dart
class AppTextStyles {
  AppTextStyles._();

  // ── Display (Cafe24Ssurround, 단일 굵기) ──

  /// 로그인 앱 타이틀 (34sp)
  static TextStyle get display_34 => TextStyle(
    fontFamily: 'Cafe24Ssurround',
    fontSize: 34.sp,
    height: 1.2,
  );

  /// 도감 상세 이름, 축하 타이틀 (26sp)
  static TextStyle get display_26 => TextStyle(
    fontFamily: 'Cafe24Ssurround',
    fontSize: 26.sp,
    height: 1.25,
  );

  /// 위저드 질문 (24sp)
  static TextStyle get display_24 => TextStyle(
    fontFamily: 'Cafe24Ssurround',
    fontSize: 24.sp,
    height: 1.35,
  );

  /// 퀴즈 질문 (22sp)
  static TextStyle get display_22 => TextStyle(
    fontFamily: 'Cafe24Ssurround',
    fontSize: 22.sp,
    height: 1.4,
  );

  /// 코스 카드 제목, 앱바 타이틀 (19sp)
  static TextStyle get display_19 => TextStyle(
    fontFamily: 'Cafe24Ssurround',
    fontSize: 19.sp,
    height: 1.3,
  );

  /// 주요 버튼 라벨 (17sp)
  static TextStyle get display_17 => TextStyle(
    fontFamily: 'Cafe24Ssurround',
    fontSize: 17.sp,
    height: 1.0,
  );

  /// 섹션 카드 제목, 필터 칩 (16sp)
  static TextStyle get display_16 => TextStyle(
    fontFamily: 'Cafe24Ssurround',
    fontSize: 16.sp,
    height: 1.0,
  );

  // ── Body (Pretendard Variable) ──

  /// 어린이 눈높이 설명 본문 (17sp Medium) — 앱 최중요 읽기 텍스트
  static TextStyle get body_17 => TextStyle(
    fontFamily: 'Pretendard',
    fontVariations: const [FontVariation('wght', 500)],
    fontSize: 17.sp,
    height: 1.65,
    letterSpacing: -0.32,
  );

  /// 일반 본문 (15sp Medium)
  static TextStyle get body_15 => TextStyle(
    fontFamily: 'Pretendard',
    fontVariations: const [FontVariation('wght', 500)],
    fontSize: 15.sp,
    height: 1.6,
    letterSpacing: -0.32,
  );

  /// 소셜 로그인 버튼, 옵션 카드 제목 (16sp SemiBold)
  static TextStyle get label_16 => TextStyle(
    fontFamily: 'Pretendard',
    fontVariations: const [FontVariation('wght', 600)],
    fontSize: 16.sp,
    height: 1.0,
    letterSpacing: -0.32,
  );

  /// 보조 설명, 수집 날짜 (14sp Medium) — 앱 전체 최소 크기
  static TextStyle get caption_14 => TextStyle(
    fontFamily: 'Pretendard',
    fontVariations: const [FontVariation('wght', 500)],
    fontSize: 14.sp,
    height: 1.4,
    letterSpacing: -0.32,
  );

  /// 카테고리 칩, 뱃지, 도감 카드 이름 (13sp Bold)
  static TextStyle get tag_13 => TextStyle(
    fontFamily: 'Pretendard',
    fontVariations: const [FontVariation('wght', 700)],
    fontSize: 13.sp,
    height: 1.0,
    letterSpacing: -0.32,
  );

  /// 시간 뱃지, 탭바 라벨 (12sp Bold) — 장식 전용, 본문 금지
  static TextStyle get tag_12 => TextStyle(
    fontFamily: 'Pretendard',
    fontVariations: const [FontVariation('wght', 700)],
    fontSize: 12.sp,
    height: 1.0,
    letterSpacing: -0.32,
  );
}
```

주의: PretendardVariable은 하나의 ttf로 모든 굵기를 담으므로 `fontVariations`로 weight를 지정한다. `fontWeight: FontWeight.w600` 방식은 Variable 폰트에서 플랫폼별 렌더링이 갈릴 수 있어 `FontVariation('wght', …)`을 표준으로 한다.

## Radius

### 핵심 규칙

**외부 radius = 내부 radius × 2, 패딩 = 내부 radius.** 이 규칙 하나로 중첩된 모든 둥근 모서리가 동심원처럼 자연스럽게 맞는다. AppButton 기본값(16.r)이 들어오면서 스케일은 두 개의 체인으로 정리된다.

- **체인 A (버튼 계열)**: 뱃지 8 → 버튼·입력창 16 → 바텀시트 32
- **체인 B (카드 계열)**: 카드 내부 버튼·썸네일 12 → 카드 24

### 스케일과 페어링

| 토큰             | 값  | 용도                                              | 안에 들어가는 것   |
| ---------------- | --- | ------------------------------------------------- | ------------------ |
| `{rounded.xs}`   | 8   | 뱃지, 작은 칩                                     | — (최하위)         |
| `{rounded.sm}`   | 12  | 도감 그리드 카드, **카드(24) 내부의 버튼·썸네일** | 각진 뱃지          |
| `{rounded.md}`   | 16  | **AppButton 기본**, 입력창, 퀴즈 선택지           | 뱃지(8)            |
| `{rounded.lg}`   | 24  | 카드, 다이얼로그, 촬영 가이드 프레임              | 내부 요소(12)      |
| `{rounded.xl}`   | 32  | 바텀시트 상단, 풀스크린 모달                      | 버튼(16), 카드(16) |
| `{rounded.full}` | 999 | FAB, 셔터, 마커, 아바타, 모드 토글, pill 칩       | — (예외 계층)      |

**버튼 radius 판정 규칙**: 버튼이 화면/시트 루트에 풀폭으로 놓이면 기본값 16.r 그대로, 카드(24) 안에 들어가면 `borderRadius: BorderRadius.circular(12.r)` 오버라이드. 이 한 줄만 지키면 ×2 규칙이 깨지지 않는다.

원형(`full`)은 규칙의 예외 계층으로, "누르는 것 중 가장 중요한 것"(카메라 FAB, 셔터)과 "지도 위 점"(마커)에만 쓴다.

```dart
class AppRadius {
  AppRadius._();
  static const xs = 8.0;   // 뱃지
  static const sm = 12.0;  // 카드 내부 버튼, 도감 그리드 카드
  static const md = 16.0;  // AppButton 기본
  static const lg = 24.0;  // 카드
  static const xl = 32.0;  // 바텀시트
  static const full = 999.0;
}
```

## Layout

- **화면 좌우 패딩**: `{spacing.lg}` 20 고정.
- **카드 사이 간격**: 14 (홈 카드 스택), 도감 그리드 gap 10.
- **도감 그리드**: 3열, 카드 비율 3:3.6.
- **코스 카드**: 가로 스와이프(PageView), 카드 min-width 300, snap 정렬.
- **위저드**: 한 화면 한 질문. 질문(display-24) → 서브텍스트(caption-14) → 옵션 카드 세로 스택. 선택지는 항상 3개 이하.
- **여백 철학**: 어린이 UI는 밀도를 낮춘다. 한 화면에 카드 3~4개를 넘기지 않고, 정보가 많으면 화면을 쪼갠다(위저드 3스텝이 그 예).

## Touch Targets

| 요소                  | 크기                  | 근거                                                               |
| --------------------- | --------------------- | ------------------------------------------------------------------ |
| 모든 인터랙티브 최소  | 48×48                 | 어린이 손가락 정확도가 낮음                                        |
| 기본 버튼 (AppButton) | 353.w × 56.h          | 기준폭 393 − 좌우 패딩 20×2. ScreenUtil designSize (393, 852) 전제 |
| 퀴즈 선택지           | 높이 60+              | 핵심 루프의 핵심 터치                                              |
| 카메라 FAB            | 64 (탭바 위 -34 돌출) | 앱의 대표 액션                                                     |
| 셔터                  | 78                    | 한 손 조작, 야외 환경                                              |

## Elevation

그림자는 사실상 **1단계**만 쓴다 — 카메라 FAB의 `0 6px 14px rgba(61,163,93,.35)`(브랜드색 섀도)와 마커의 `0 3px 8px rgba(0,0,0,.2)`. 카드는 그림자 없이 `1px {colors.line}` 테두리 + 배경 대비(surface vs canvas)로 분리한다. 다층 그림자, 글로우, 그라데이션 금지 — 그림책 같은 플랫함이 컨셉이다.

## Components

### 버튼 — 공용 AppButton 위젯

모든 버튼은 단일 `AppButton` 위젯 + 파라미터 프리셋으로 만든다. 별도 버튼 위젯 신규 생성 금지.

```dart
class AppButton extends StatelessWidget {
  final String text;                        // 필수
  final VoidCallback? onPressed;            // 필수, null이면 비활성화
  final Color? backgroundColor;             // 기본: AppColors.primary (#3DA35D)
  final Color? foregroundColor;             // 기본: AppColors.white
  final Color? disabledBackgroundColor;     // 기본: AppColors.uncollected (#B9B6AC)
  final Color? disabledForegroundColor;     // 기본: AppColors.white
  final bool showBorder;                    // 기본: false (채움 버튼에 테두리 불필요)
  final double borderWidth;                 // 기본: 1.0
  final Color? borderColor;                 // 기본: AppColors.line (#EBE7DC)
  final double? width;                      // 기본: 353.w
  final double? height;                     // 기본: 56.h
  final BorderRadius? borderRadius;         // 기본: BorderRadius.circular(16.r)
  final Widget? icon;                       // 선택
  final IconPosition iconPosition;          // 기본: leading
  final bool isLoading;                     // true면 CircularProgressIndicator
  final String? subtitle;                   // 선택, 메인 텍스트 아래 caption-14
  final Color? subtitleColor;               // 기본: foregroundColor
  final MainAxisAlignment? contentAlignment;// 기본: center
  final TextStyle? textStyle;               // 기본: AppTextStyles.label_16
}
```

**프리셋 매핑** (파라미터 조합, 팩토리 생성자로 구현 권장):

| 프리셋              | 오버라이드                                                  | 쓰는 곳                          |
| ------------------- | ----------------------------------------------------------- | -------------------------------- |
| `AppButton.primary` | textStyle: display_17                                       | 일반 CTA. 화면당 1개 원칙        |
| `AppButton.reward`  | bg: reward / fg: reward-dark / textStyle: display_17        | 코스 추천 받기, 축하 화면 전용   |
| `AppButton.google`  | bg: surface / fg: ink / showBorder: true / icon: 구글 로고  | 로그인                           |
| `AppButton.apple`   | bg: ink / fg: white / icon: 애플 로고                       | 로그인                           |
| `AppButton.danger`  | bg: surface / fg: danger / showBorder: true / subtitle 필수 | 탈퇴하기 (Hard Delete 경고 동반) |

세부 규칙:

- **비활성 = onPressed: null** 하나로 통일. 별도 disabled 플래그를 만들지 않는다. 위저드 "코스 3개 보러 가기"는 관심 분야 미선택 시 null.
- **isLoading**은 AI 코스 추천 요청 대기 등 서버 왕복 구간에서 사용. 로딩 중 onPressed 무시(중복 요청 방지).
- **subtitle**은 danger 프리셋과 정보성 버튼에만. 일반 CTA에 subtitle 금지 — 어린이 UI에서 버튼은 한 줄이 원칙.
- **radius 오버라이드**는 카드(24) 내부에 놓일 때 12.r 한 가지 경우만 허용 (Radius 섹션 참조).
- 기본 textStyle이 label_16(Pretendard SemiBold)인 이유: 소셜 로그인·유틸 버튼이 수적으로 더 많아서다. 브랜드 목소리가 필요한 핵심 CTA만 display_17(Ssurround)로 올린다.

### 위저드 옵션 카드 (`option-card`)

radius 24, 2px 테두리. 기본은 line색, 선택 시 **해당 카테고리색 테두리 + 카테고리 tint 배경**(관심 분야 스텝) 또는 primary/tint(그 외 스텝). 구조는 [이모지 30px] + [제목 label-16] + [보조설명 caption-14]. 단일 선택 스텝은 선택 후 350ms 뒤 자동 다음 스텝, 복수 선택 스텝(관심 분야)은 토글 + 하단 버튼.

### 퀴즈 (`quiz-option`)

3지선다, 세로 스택, 각 높이 60+, radius 16 (AppButton과 동일한 md). **오답 처리(QUIZ-03)**: 오답 선택지는 `surface-dim` 배경 + `uncollected` 텍스트 + 취소선으로 비활성화하고, 힌트는 "앗, 다시 골라 볼까요?" 한 줄만. 추가 해설 금지. 정답 시 250ms 뒤 축하 화면 전환.

### 축하 화면

전면 `{colors.reward}` 배경, 중앙에 흰 카드(radius 24)로 획득한 도감 노출. 앱에서 노랑이 전면을 덮는 유일한 화면 — 이 희소성이 보상 감각을 만든다.

### 도감 그리드 (`dogam-card` / `dogam-card-locked`)

- 수집 완료: 흰 배경 + **2px 카테고리색 테두리** + 사진/일러스트 + 이름(tag-13).
- 미수집: surface-dim 배경, 테두리 없음, `?`를 Ssurround 34px uncollected색으로. 이름 대신 "미수집".
- 카드 radius 12 (3열 그리드 밀도에서 16 이상은 과함).

### 도감 상세

사진 영역(radius 24, 카테고리 tint 배경) → 카테고리·상태 뱃지 → 이름(display-26) → 특징(body-15, muted) → **어린이 눈높이 설명 카드**(흰 카드 radius 24, body-17, 소제목은 Ssurround 15 카테고리 dark색) → 수집 날짜(caption-14). 상태 뱃지는 3종: 수집 가능 / 임시 중단 / 운영 종료.

### 탭바

홈 · 지도 · [카메라 FAB] · 도감 · 내정보 5슬롯. 활성 primary-dark, 비활성 disabled. FAB는 canvas색 5px 링으로 탭바에서 분리. 카메라가 앱의 핵심 액션이므로 중앙 최대 크기가 불변 원칙이다.

### 지도

공식 약도 이미지 위 오버레이. 마커(`map-marker`)는 34px 원형, 카테고리색 배경 + 흰 3px 테두리 + Ssurround 숫자(코스 순서). 출입문은 radius 8 흰 라벨. 하단은 `bottom-sheet`(radius 32 상단, grabber 44×5)로 코스 장소 리스트. 길 안내·경로 추적 UI는 만들지 않는다(명세 11.3).

### 카메라

배경 `camera-bg`. 상단 모드 토글(pill) — 활성 시 카테고리색 fill, 촬영 프레임은 260×260 dashed radius 24, **셔터 링 색 = 현재 모드 카테고리색**. 장소 모드는 힌트에 "위치로 확인해요"를 노출(실제 판정은 GPS, PLACE-01).

## Motion

- 화면 전환: 기본 슬라이드/페이드, 300ms 이하.
- 위저드 자동 진행: 선택 피드백 노출 후 350ms 딜레이.
- 축하 화면: 도감 카드 scale-in(0.8→1.0, easeOutBack 400ms) 한 번. 컨페티 등 파티클은 넣더라도 2초 내 종료.
- 그 외 장식적 애니메이션 금지. `reduce motion` 설정 시 전부 페이드로 대체.

## Accessibility 하한선

접근성 전용 기능은 스코프 밖(명세 16)이지만, 아래는 디자인 기본값으로 지킨다: 텍스트 대비 AA 4.5:1 이상(위 페어링 표 준수), 최소 폰트 14sp, 최소 터치 48, 색 단독 의존 금지(카테고리는 색+아이콘+라벨 3중 표기).

## Known Gaps

- 공식 약도 이미지의 실제 색감과 마커 색 충돌 여부는 이미지 수급 후 검증 필요(약도가 초록 계열이면 식물 마커에 흰 테두리 3px 유지가 필수).
- 도감 실물 사진 vs 일러스트 방향 미확정 — 사진이면 카드 테두리 2px 유지, 일러스트면 tint 배경 채움 방식으로 변경 검토.
- 임시 중단/운영 종료 상태의 도감 카드 시각 처리(회색 오버레이 vs 뱃지만) 미확정.
- 다크 모드 미지원(웜 아이보리 단일 테마). 카메라 화면만 예외적 다크.
