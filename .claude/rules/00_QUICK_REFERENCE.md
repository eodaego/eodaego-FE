# 빠른 참조 가이드 (Quick Reference Guide)

> 일반적인 Dart/Flutter 문법은 적지 않는다. **코드만 봐서는 알 수 없는 것**만 남긴다.
> 패키지·버전은 `pubspec.yaml`, 폴더 트리는 `ls lib/`가 정본이다.

---

## 📚 문서 지도

**항상 로드되는 규칙** (`.claude/rules/`)

| 문서 | 내용 |
|------|------|
| [01_CODE_CONVENTIONS.md](01_CODE_CONVENTIONS.md) | 로깅 이모지 규칙, 주석 규칙 |
| [03_TESTING_RULES.md](03_TESTING_RULES.md) | 테스트 작성 규칙 |

**필요할 때 불러 쓰는 스킬** (`.claude/skills/`) — 컨텍스트 절약을 위해 지연 로딩

| 스킬 | 언제 |
|------|------|
| `api-integration` | 새 API 연동, 인증 인터셉터·에러 변환 확인 시 |
| `design-system` | UI 화면·위젯·스타일 작업 시 |
| `deploy` | 배포, GitHub Actions 워크플로우 수정 시 |
| `google-maps-setup` | 지도 빌드 오류, 신규 환경 세팅 시 |

---

## 🏗️ 아키텍처

Clean Architecture 3계층. 의존성은 한 방향으로만 흐른다.

```
Presentation → Domain ← Data
```

- **Data**: API 호출, DB 접근, Repository 구현
- **Domain**: 비즈니스 로직 (Entity, Use Case, Repository 인터페이스)
- **Presentation**: UI (Widget, Page, Provider)

### 문서로만 알 수 있는 결정

- **에러 처리**: try-catch + Custom Exception. **Either/dartz 사용 금지** (2025-12-30 제거)
- **상태 관리**: Riverpod 코드 생성(`@riverpod`) 방식. 수동 Provider 선언 금지
- **retrofit 버전 고정**: `pubspec.yaml` 주석 참조 (4.9.x `logError` 시그니처 비호환)

---

## 📂 파일 배치와 이름

### 어디에 둘 것인가

- **2개 이상 feature가 쓰면** → `lib/core/`
- **1개 feature만 쓰면** → `lib/features/<기능>/`
- feature 간 직접 import 금지. 공유가 필요하면 Provider로 참조한다.
- 각 feature는 `data/` · `domain/` · `presentation/` 3계층을 유지한다.

### 네이밍

| 타입 | 규칙 | 예시 |
|------|------|------|
| **파일명** | snake_case | `user_profile_page.dart` |
| **클래스명** | PascalCase | `UserProfilePage` |
| **변수·상수** | camelCase | `userName`, `maxCollectionCount` |
| **Private** | `_` 시작 | `_privateMethod()` |

### 파일 Suffix

| 타입 | Suffix | 예시 |
|------|--------|------|
| **Model** | `_model.dart` | `user_model.dart` |
| **Entity** | `_entity.dart` | `user_entity.dart` |
| **Repository** | `_repository.dart` | `user_repository.dart` |
| **Use Case** | `_usecase.dart` | `create_user_usecase.dart` |
| **Provider** | `_provider.dart` | `user_provider.dart` |
| **Page** | `_page.dart` | `user_profile_page.dart` |
| **Widget** | `_widget.dart` | `user_card_widget.dart` |

---

## ⚠️ 에러 처리

계층별 책임이 다르다.

| 계층 | 할 일 |
|------|-------|
| **Repository** | `DioExceptionHandler.handle(e)`로 변환해 throw |
| **Use Case** | 그대로 전파, 또는 비즈니스 규칙 위반을 검증해 throw |
| **Presentation** | try-catch → `AsyncValue.error()` |

예외 종류: `NetworkException` · `ValidationException` · `AuthException` · `ServerException`

---

## ✅ 코드 리뷰 체크리스트

이 프로젝트에서만 의미 있는 항목들이다. 일반적인 Dart 린트 사항은 `flutter analyze`가 잡는다.

- [ ] 의존성 흐름 준수 — Presentation → Domain ← Data
- [ ] Data 계층에 비즈니스 로직 없음 / Domain 계층에 Flutter 의존성 없음
- [ ] feature 간 직접 import 없음
- [ ] Either 패턴 미사용 (try-catch)
- [ ] 코드 생성 파일(`.g.dart`, `.freezed.dart`) 커밋 포함
- [ ] 새 API는 `DioExceptionHandler`를 거쳐 예외 변환

---

## 📌 자주 묻는 질문

**Q: 파일을 어디에 만들어야 하나요?**
A: 2개 이상 feature가 쓰면 `lib/core/`, 하나만 쓰면 `lib/features/<기능>/`.

**Q: Either 패턴을 써야 하나요?**
A: 아니요. 프로젝트에서 제거되었습니다. try-catch를 씁니다.

**Q: Repository에서 에러를 어떻게 처리하나요?**
A: `DioExceptionHandler.handle(e)`로 변환해 throw합니다. 자세한 절차는 `api-integration` 스킬 참조.
