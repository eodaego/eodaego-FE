# Changelog

**현재 버전:** 1.0.22  
**마지막 업데이트:** 2026-07-29T07:15:25Z  

---

## [1.0.22] - 2026-07-29

**PR:** #17  

**문서**
- v1.0.19 릴리즈 노트 추가 #10

**기타**
- Merge pull request #16 from eodaego/20260726_#15_마이페이지_설정_닉네임_탈퇴_약관
- docs : 리포트 문서 작성 #15
- style : dart format 코드 정리 #15
- feat : 마이페이지 디자인 개편 #15
- feat : 닉네임 입력창 상태 아이콘을 지우기 버튼으로 교체 #15
- style : 안내·에러 문구에 해요체 보이스톤 적용 #15
- docs : UX 라이팅 가이드 추가 #15
- docs : API 연동 가이드를 스킬로 전환하고 규칙 문서 압축 #15
- feat : 닉네임 중복 확인 및 길이 제약 반영 #15
- feat : 마이페이지 설정 — 닉네임 변경·회원탈퇴·약관 다시 보기 #15
- fix : 회원탈퇴 204 응답 정합 및 미사용 회원조회 코드 제거 #15
- chore : Issue-Branch 슬래시 커맨드 추가 #15
- docs : 프로젝트 규칙 문서 정리 및 스킬 전환 #15
- docs : 마이페이지 설정 이슈 추가 #15
- Merge pull request #14 from eodaego/20260712_#13_소셜_로그인_및_약관_동의_연동
- ci : Android CI를 debug 빌드로 변경 #13
- ci : Android 빌드 재활성화 및 불필요한 gradlew 스텝 제거 #13
- ci : iOS 빌드가 러너 기본 Xcode를 쓰도록 변경 #13
- docs : 리포트 문서 작성 #13
- ci : Xcode 버전 수정 및 iOS 빌드 재활성화 #13
- ci : PR 빌드 잡 비활성화 #13
- style : 안내 문구를 어린이 눈높이 말투로 다듬음 #13
- refactor : 로그인 에러 처리를 단일 경로로 정리 #13
- style : 닉네임 설정 화면 레이아웃을 약관 화면과 통일 #13
- feat : 약관 동의 화면 개편 및 마케팅 동의 문서 추가 #13
- style : dart format 일괄 적용 #13
- fix : 온보딩 흐름 이탈 수정 및 토큰 로그 노출 제거 #13
- feat : 닉네임 설정 화면 서버 연동 #13
- feat : 닉네임 변경 API 연동 및 형식 검증 유틸 추가 #13
- feat : 약관 동의 API 정본 계약 적용 #13
- feat : 로그인 계약 정합 - flat 응답, userId UUID, 토큰 재발급 #13
- refactor : API 경로 v1 적용 및 에러 응답 포맷 교체 #13
- docs : Auth/Member API 연동 이슈 및 API 정본 추가 #13

---

## [1.0.19] - 2026-07-11

**PR:** #12  

**새로운 기능**
- 홈, 지도, 도감, 즐겨찾기 4탭 기반의 전체 목 UI를 추가했습니다.
- 코스 추천, 지도 코스 보기, 도감 검색·필터·상세 보기, 즐겨찾기 정렬을 지원합니다.
- 촬영·퀴즈·보상 및 내 정보 화면을 추가했습니다.
- 게스트 둘러보기와 로그인 안내 흐름을 제공합니다.
- 공원 날씨·혼잡도, 도감 수집률, 공식 사이트 링크를 홈에서 확인할 수 있습니다.

**개선 사항**
- 앱 버전을 1.0.19로 업데이트했습니다.
- 목 데이터 사용 여부를 설정할 수 있습니다.
- Android·iOS 테스트 및 배포 실행 방식을 개선했습니다.

---

## [1.0.18] - 2026-07-10

**PR:** #9  

**새로운 기능**
- QR 코드 스캔을 위한 카메라 권한과 지도·주변 장소 안내를 위한 위치 권한이 추가되었습니다.
- Android와 iOS에서 필요한 권한 안내가 제공됩니다.

**개선 사항**
- 앱 버전이 1.0.18로 업데이트되었습니다.
- 최신 버전 정보와 버전 코드가 갱신되었습니다.

---

## [1.0.17] - 2026-07-09

**PR:** #8  

**Chores**
- 앱 및 프로젝트 버전이 `1.0.17`으로 업데이트되었습니다.
- 최신 버전 정보가 `v1.0.15`에서 `v1.0.15`/`v1.0.17` 기준으로 갱신되었습니다.

**Bug Fixes**
- 빌드 처리 대기 동작에 시간 제한이 추가되어, 배포 과정이 더 안정적으로 진행되도록 개선되었습니다.

---

## [1.0.15] - 2026-07-09

**PR:** #7  

**New Features**
- 릴리즈 노트 파일을 길이 제한에 맞춰 자동으로 잘라내는 도구가 추가되었습니다.
- 앱 버전이 `1.0.15`로 업데이트되었습니다.

**Chores**
- 최신 버전 표기와 버전 코드가 함께 갱신되었습니다.
- Android 빌드 설정이 안정적인 NDK 버전을 사용하도록 조정되었습니다.

**Style**
- 여러 화면과 테스트 코드의 표시 형식이 정리되어 가독성이 개선되었습니다.

---

## [1.0.14] - 2026-07-09

**PR:** #5  

**새 기능**
- 앱 버전이 `1.0.14`로 업데이트되었습니다.
- iOS/Android 배포 파이프라인이 프로젝트 경로 변경에 더 유연하게 동작하도록 개선되었습니다.

**문서**
- README의 최신 버전 정보가 업데이트되었습니다.

---

## [1.0.13] - 2026-07-09

**PR:** #4  

**New Features**
- 앱 런처 아이콘이 새 디자인으로 적용되어 Android/iOS 홈 화면 표시가 개선되었습니다.
- 약관/개인정보/위치정보 문서가 앱 내에서 외부 웹 원문과 연결되도록 확장되었습니다.
- 최신 버전 표기가 `v1.0.13`으로 업데이트되었습니다.

**Documentation**
- 이용약관, 개인정보처리방침, 위치기반서비스 약관 문서가 추가되었습니다.
- 아이콘 재생성 및 확인 방법에 대한 안내가 정리되었습니다.

---

## [1.0.9] - 2026-07-08

**PR:** #3  

**새 기능**
- 로그인 화면 하단 정렬 + 약관 동의/열람(LegalDocumentPage, 임시 JSON)
- 공용 AppButton 위젯 + Google/Apple 프리셋, 로그인 화면 적용
- 로그인 실패 시 AppSnackbar 피드백 (백엔드 미응답 등, 앱 멈춤 방지)
- 로그인 화면 안내를 AppSnackbar로 통일 (loginNoticeFor + mount 소비)
- 스플래시 최소 노출 시간(1.8s) 보장 #2
- 화면 전환 애니메이션 제거 (NoTransitionPage) #2
- 위치·권한 서비스 #2
- Remote Config (버전 체크·강제 업데이트·점검) #2
- FCM·디바이스 서비스 + 부트스트랩 연결 #2
- main.dart 부트스트랩 (앱 부팅 → 로그인) #2
- 라우터 + 인증 페이지 뼈대 + 홈 플레이스홀더 #2
- 인증 provider (약관·auth notifier) #2
- 유저 데이터·도메인 계층 (닉네임·약관·탈퇴) #2
- 인증 데이터·도메인 계층 (Firebase·Retrofit 로그인) #2
- 공용 다이얼로그 + 점검·강제 업데이트 페이지 #2
- 네트워크·스토리지 계층 (Dio·AuthInterceptor·SecureTokenStorage) #2
- 코어 상수·config·errors·utils (디자인 토큰·EnvConfig·AppException·URL) #2

**버그 수정**
- 로그인 취소(AuthCancelledException)를 에러가 아닌 미로그인 복귀로 처리
- 로그아웃 실패해도 앱 멈추지 않도록 signOut을 항상 data(null)로 종료
- 로그아웃 시 원격 실패와 무관하게 로컬 토큰 삭제 보장
- FCM 정리 + Firebase 설정 gitignore + Colors.transparent 상수화 #2
- .env를 Flutter 에셋으로 등록 (dotenv 로드 크래시 방지) #2
- 스플래시 리다이렉트 데드엔드 해소 + 린트 정리 #2
- 다이얼로그 스크림 AppColors.scrim 상수화 #2

**개선**
- forceLogoutMessageKeyProvider를 loginNoticeKeyProvider로 리네임

**문서**
- 로그아웃 견고화 및 로그인 안내 AppSnackbar 통일 설계 스펙
- cops → 어대GO 포팅 구현 계획 추가 (12 태스크)
- cops_and_robbers → 어대GO 선별 포팅 설계 문서 추가

**기타**
- docs : Firebase 초기 설정 보고서 갱신 (Remote Config 배선·상수화 반영) #2
- chore : Remote Config 초기화 배선 + ads 제거·상수화 #2
- chore : superpowers 에이전트 플랜 문서 git 추적 제외
- docs : Firebase 연동·iOS 푸시/소셜 로그인 설정 구현 보고서 추가
- chore : Firebase/FlutterFire 연동 및 iOS 푸시·소셜 로그인 네이티브 설정
- assets/icons SVG 에셋을 pubspec에 등록
- Merge branch 'main' of https://github.com/eodaego/eodaego-FE
- Firebase 설정 파일 추가 (google-services.json / GoogleService-Info.plist) #2
- Merge branch 'main' of https://github.com/eodaego/eodaego-FE
- docs : 이슈 작성문서
- 앱 아이콘·디자인 시스템 파일 추가 #2
- 기본 카운터 테스트 제거 + app_router.g.dart 동기화 #2
- chore : iOS/Android 빌드 및 Fastlane 배포 설정 추가
- feat : 커스텀 폰트(Pretendard, Cafe24Ssurround) 등록
- Add keystore files to .gitignore
- Merge branch 'main' of https://github.com/eodaego/eodaego-FE
- fix : Android core library desugaring 활성화
- chore : google_mobile_ads 의존성 임시 제외
- chore : iOS CocoaPods 설치 및 연동
- chore : Firebase 버전 하향 및 Google Maps 의존성 제거
- chore : 디버깅 파일
- chore : 개발 규칙·커맨드 문서 및 에이전트 설정 추가
- chore : 앱 패키지 식별자 및 표시 이름 변경
- chore : 프로젝트 의존성 추가 및 플러그인 등록
- chore : TEMPLATE 세팅

---

