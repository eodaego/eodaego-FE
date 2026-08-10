# Changelog

**현재 버전:** 1.0.37  
**마지막 업데이트:** 2026-08-10T11:18:03Z  

---

## [1.0.37] - 2026-08-10

**PR:** #35  

**기타**
- Merge pull request #34 from eodaego/20260809_#33_대기화면_고양이_탭반응과_공용버튼_진동
- docs : 리포트 문서 작성 #33
- style : 도감 상세 대표 이미지 확대 및 모서리 클리핑
- feat : 대기 화면 고양이를 풍선 상호작용으로 확장 #33
- docs : 이슈 문서 정리와 v1.0.37 릴리즈 노트 추가
- chore : 도감 목데이터 너구리를 바위너구리로 수정
- style : 스낵바 모서리 반경을 sm으로 축소
- feat : 공용 버튼 진동과 대기 화면 고양이 탭 반응 추가 #33

---

## [1.0.36] - 2026-08-09

**PR:** #32  

**기타**
- docs : 도감 API 식별자 이슈 문서를 기능요청으로 정리
- chore : iOS 최소 배포 타겟을 15.0으로 상향
- chore : riverpod 생성 코드 해시 갱신
- fix : 도감 수집률을 소수점 첫째 자리까지 표시
- fix : 도감 조회 카테고리를 항상 PLACE로 고정
- chore : iOS 워크플로우 미사용 Secrets.xcconfig 주입 제거 #30

---

## [1.0.35] - 2026-08-09

**PR:** #31  

**새 기능**
- 코스 추천 선택지를 아이콘 격자로 바꾸고 하단 버튼을 고정 #30
- 즐겨찾기 목록·정렬을 서버 기준으로 교체하고 목 코스 제거 #28
- 코스 추천 조건 화면을 5단계로 개편하고 실 API 연동 #28
- 코스 추천·즐겨찾기 Provider 추가 #28
- 코스 목 데이터소스와 픽스처 추가 #28
- 코스·즐겨찾기 Repository 추가 #28
- 코스·즐겨찾기 DTO와 API 클라이언트 추가 #28
- 코스 도메인 엔티티 추가 #28
- 코스 추천 조건 옵션 enum 추가 #28
- 홈 날씨 카드에 공원 혼잡도 표시 #27
- 공원 혼잡도 조회 API 연동 #27
- 공원 혼잡도 도메인 엔티티 추가 #27
- 퀴즈 보상 진입 시 도감 수집 연동 #24
- code 기반 도감 수집 provider 추가 #24
- 도감 수집 API 데이터 계층 배선 #24

**버그 수정**
- 코스 추천이 10초에 끊기지 않도록 전역 요청 타임아웃 제거 #30
- 도감 수집 최종 리뷰 마이너 반영 #24

**개선**
- 코스 공유 지점을 실 엔티티 기준으로 교체 #28
- 수집 provider 테스트 주석 컨벤션 정리 #24

**문서**
- 추천 요청 DTO의 null 필드 직렬화 설명 정정 #28

**기타**
- docs : 도감 API·지도 연동 작업 리포트 문서 작성 #30
- refactor : 하드코딩된 문자열·매직 넘버를 상수로 치환 #30
- feat : 홈 화면 레이아웃 개편 #30
- fix : 코스 추천 결과 화면에서 위저드로 되돌아가는 경로 차단 #30
- feat : 지도 코스 시트 즐겨찾기·장소 선택 상호작용 추가 #30
- feat : 도감 API 연동 및 지도 장소 정보 카드 표시 #30
- feat : Google Maps SDK 도입 및 공원 지도 실제 지도 전환 #30
- feat : 코스 생성 대기 화면에 안내 문구 추가 #30
- docs : 코스 추천 화면 정비 리포트 문서 작성 #30
- chore : 공원 약도 이미지 추가 #30
- fix : 즐겨찾기 토글 Future already completed 오류 수정 #30
- feat : 코스 추천 결과 목록·로딩 화면 개선 #30
- style : 포맷 미적용 파일 정리 #30
- docs : 코스 추천 화면 정비 이슈 문서 추가 #30
- docs : 리포트 작성 #24
- Merge pull request #29 from eodaego/20260808_#28_코스_추천_즐겨찾기_API_연동
- docs : 코스 추천·즐겨찾기 API 연동 리포트 문서 작성 #28
- docs : 공원 혼잡도 API 연동 리포트 문서 작성 #27
- docs : 코스·즐겨찾기·혼잡도 API 정본 갱신 #27
- Merge pull request #26 from eodaego/20260808_#25_앱_문구_UX_라이팅_정비
- docs : 리포트 문서 작성 #25
- feat : 앱 전체 문구 UX 라이팅 규칙에 맞게 정비 #25
- docs : 앱 문구 UX 라이팅 정비 이슈 문서 추가 #25
- style : dart format 적용
- chore : 에이전트 규칙 정리 및 UX 라이팅 스킬 분리
- feat : 내 정보 화면에 앱 버전 표시
- 수집 provider 생성 파일 재생성 #24
- Merge pull request #23 from eodaego/20260730_#22_목데이터_연결
- docs : 도감 그리드 전환 구현 보고서 추가 #22
- docs : 일러스트 에셋 명세 문서 추가 #22
- docs : 프로젝트 PRD 문서 추가 #22
- chore : gitignore에 로컬 에이전트 스캐폴딩 디렉터리 추가 #22
- refactor : 도감 목록을 3열 그리드로 전환 #22
- fix : 컨페티가 CTA 버튼을 가리지 않도록 낙하 막바지 페이드 추가 #22
- fix : CatalogImage에 imageUrl 네트워크 계층 추가 #22
- fix : 디자인 시스템 문서의 노랑 규칙·도감 목록·촬영 프레임 서술 오류 정정 #22
- docs : 축하 화면 개편에 맞춰 디자인 시스템 문서 정리 #22
- refactor : 촬영 화면 점선 프레임을 모서리 브래킷 4개로 교체 #22
- feat : 도감 목록을 리스트로 바꾸고 상세 정리 #22
- feat : 홈을 시안 기준으로 개편 #22

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

