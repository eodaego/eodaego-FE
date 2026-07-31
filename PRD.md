# 어대GO – Flutter 앱 PRD

> 최종 업데이트: 2026-07-30 (v1.0.25 기준)
> 이 문서는 저장소의 실제 구현 상태를 정본으로 삼는다. 화면·기능 상태가 코드와 어긋나면 코드가 맞다.

---

## 1. 제품 개요

- **한 줄 정의**: 서울어린이대공원을 탐험하며 동물·식물·장소 도감을 수집하는 나들이 앱
- **핵심 루프**: 공원 방문 → 명소 탐험 → 촬영 → 퀴즈 풀기 → 도감 수집 → 수집률 달성
- **타겟 사용자**
  - 어린이 동반 가족: 공원 나들이를 "탐험 놀이"로 확장
  - 어린이 본인: 도감 수집·퀴즈 보상 (문구는 어린이 눈높이 해요체, `.claude/rules/04_UX_WRITING.md`)
- **부가 가치**: 방문 결정에 쓰이는 실시간 공원 날씨 (현재 + 3.5일치 시간대별 예보)

---

## 2. 유저 플로우

```
스플래시 → 온보딩 → 소셜 로그인(Google/Apple)
              │            └─ 게스트 둘러보기 (로그인 없이 화면 탐색)
              └─ 약관 동의(필수 게이트) → 닉네임 설정(선택, 이탈해도 재유도 없음)
                                              ↓
         ┌──────────── 하단 4탭 + 중앙 카메라 버튼 ────────────┐
         홈         지도         [촬영]         도감        즐겨찾기
          │                        │             │
     날씨 상세              퀴즈 → 정답 축하   도감 상세
     코스 추천 위저드
```

- 닉네임은 온보딩 게이트가 아니다. 건너뛰어도 마이페이지에서 변경 가능.
- 약관 동의는 진짜 게이트다. `requiresAgreement`가 true면 통과해야 진입.

---

## 3. 화면·기능 현황

| 기능 | 화면 | 상태 |
|------|------|------|
| 인증 | 스플래시 / 온보딩 / 로그인 / 약관 동의 / 닉네임 설정 | ✅ 실 API 연동 (JWT, 401 자동 재발급) |
| 홈 | 날씨 바 · 도감 진행률 카드 · 코스 추천 진입 | ✅ 실 API 연동 |
| 날씨 | 날씨 상세 (현재 + 시간대별 예보, 날짜 구분) | ✅ 실 API 연동 (KST 고정 처리) |
| 도감 | 목록(카테고리 필터·검색) / 상세 / 요약 | ✅ 실 API 연동 (미수집은 물음표 표시) |
| 마이페이지 | 닉네임 변경 / 회원탈퇴 / 약관 다시 보기·마케팅 토글 | ✅ 실 API 연동 |
| 촬영 → 퀴즈 | 촬영 / 퀴즈 / 정답 축하 | 🟡 퀴즈 문항 파일 기반 (백엔드 퀴즈·사진 인식 없음) |
| 코스 추천 | 위저드 / 결과 | 🟡 목 UI (백엔드 API 없음) |
| 지도 | 지도 탭 | 🟡 목 UI (지도 SDK 미연동) |
| 즐겨찾기 | 즐겨찾기 탭 | 🟡 목 UI |

**목 데이터 모드**: `USE_MOCK_DATA=true`면 예시 응답 파일(`assets/mock/`)로 전 화면이 동작한다.
분기는 DataSource(서버 통신 지점)에서만 하고 이후 변환 코드는 실 경로와 공유한다 — 시연·UI 작업용.

---

## 4. 기술 스택

정본은 `pubspec.yaml`. 요약만 적는다.

- **UI**: Flutter (Material), flutter_screenutil, 2폰트 체계(Cafe24 Ssurround + Pretendard)
- **라우팅**: go_router
- **상태 관리**: Riverpod 코드 생성(`@riverpod`) — 수동 Provider 선언 금지
- **네트워킹**: dio + retrofit(4.7.3 고정, 4.9.x 비호환) + AuthInterceptor(JWT 자동 주입)
- **인증**: google_sign_in, sign_in_with_apple → 백엔드 JWT / flutter_secure_storage
- **Firebase**: Remote Config(강제 업데이트·점검 모드), FCM, Crashlytics, Analytics
- **카메라·스캔**: mobile_scanner, qr_flutter
- **에러 처리**: try-catch + Custom Exception (**Either/dartz 금지**)

---

## 5. 아키텍처

Clean Architecture 3계층, feature-first. 상세 규칙은 `.claude/rules/00_QUICK_REFERENCE.md`가 정본.

```
lib/
├── core/        # 2개 이상 feature가 쓰는 것 (constants, network, storage, services, mock, …)
└── features/    # auth, collection, course, favorite, home, map, quiz, scan, user, weather
    └── <기능>/data · domain · presentation
```

- 의존성: Presentation → Domain ← Data. feature 간 직접 import 금지.
- Repository는 `DioExceptionHandler.handle(e)`로 예외 변환 후 throw.

---

## 6. 백엔드 API 현황

정본은 `docs/api-docs.json`. 앱이 사용하는 엔드포인트:

| 도메인 | 엔드포인트 | 비고 |
|--------|-----------|------|
| Auth | 소셜 로그인 / 토큰 재발급 / 로그아웃 | |
| Member | 닉네임 변경·중복 확인 / 약관 조회·수정 / 회원탈퇴(204) | |
| Catalog | 도감 목록 / 상세 / 수집 현황 요약 | 수집(collect)은 사진 인식 대기로 미사용 |
| Weather | 현재 날씨 조회 | 로그인 필요 (공개 정보 인증 요구는 백엔드 논의 중) |

---

## 7. 로드맵 (남은 작업)

**P0 — 핵심 루프 완성**
- 사진 인식 + 도감 수집 연동 (백엔드 AI 서버 준비 후, `POST /catalog/{id}/collect`)
- 퀴즈 백엔드 연동 (현재 파일 기반)

**P1 — 목 UI의 실기능 전환**
- 지도: 지도 SDK 연동 + 공원 명소 핀
- 즐겨찾기: 저장·조회 API
- 코스 추천: 추천 API 연동

**P2 — 부가 기능**
- 공원 혼잡도 (서버 API 준비 후)
- 도감 동식물 실사진 (현재 카테고리 아이콘 대체)
- 홈 화면 고도화

---

## 8. 관련 문서

| 문서 | 내용 |
|------|------|
| `.claude/rules/00_QUICK_REFERENCE.md` | 아키텍처·네이밍·에러 처리 규칙 정본 |
| `.claude/skills/design-system/` | 색상 토큰(동물 주황·식물 초록·장소 파랑·보상 노랑), 타이포, 컴포넌트 |
| `.claude/skills/api-integration/` | API 연동 절차 |
| `docs/api-docs.json` | 백엔드 OpenAPI 명세 |
| `.issues/` · `.report/` | 기능별 이슈 스펙과 구현 보고서 |
| `CHANGELOG.md` | 버전별 변경 이력 |
