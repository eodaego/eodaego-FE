# 빠른 참조 가이드 (Quick Reference Guide)

> **작성일**: 2025-12-30
> **대상 독자**: 신규 개발자, 빠른 참조 필요 시
> **문서 버전**: 1.0.0

이 문서는 코드 작성 시 빠르게 참조할 수 있는 **핵심 규칙만** 정리한 요약본입니다.
상세한 설명과 예시 코드는 각 상세 문서를 참고하세요.

---

## 📚 상세 문서 링크

**항상 로드되는 규칙** (`.claude/rules/`)

| 문서 | 내용 |
|------|------|
| [01_CODE_CONVENTIONS.md](01_CODE_CONVENTIONS.md) | 로깅 이모지 규칙, 주석 규칙 |
| [02_API_INTEGRATION_GUIDE.md](02_API_INTEGRATION_GUIDE.md) | API 연동 절차, 인증 인터셉터, 에러 처리 |
| [03_TESTING_RULES.md](03_TESTING_RULES.md) | 테스트 작성 규칙 |

**필요할 때 불러 쓰는 스킬** (`.claude/skills/`) — 컨텍스트 절약을 위해 지연 로딩

| 스킬 | 언제 |
|------|------|
| `design-system` | UI 화면·위젯·스타일 작업 시 |
| `deploy` | 배포, GitHub Actions 워크플로우 수정 시 |
| `google-maps-setup` | 지도 빌드 오류, 신규 환경 세팅 시 |

---

## 🏗️ 아키텍처

### Clean Architecture 3계층

- **Data**: API 호출, DB 접근, Repository 구현
- **Domain**: 비즈니스 로직 (Entity, Use Case, Repository 인터페이스)
- **Presentation**: UI (Widget, Page, Provider)

### 의존성 흐름

```
Presentation → Domain ← Data
```

### 기술 스택

패키지와 버전은 `pubspec.yaml`이 정본이다. 여기 옮겨 적지 않는다.

문서로만 알 수 있는 결정:

- **에러 처리**: try-catch + Custom Exception. **Either/dartz 사용 금지** (2025-12-30 제거)
- **상태 관리**: Riverpod 코드 생성(`@riverpod`) 방식. 수동 Provider 선언 금지
- **retrofit 버전 고정**: `pubspec.yaml` 주석 참조 (4.9.x `logError` 시그니처 비호환)

---

## 📂 파일 및 폴더 구조

### 파일 네이밍

| 타입 | 규칙 | 예시 |
|------|------|------|
| **파일명** | snake_case | `user_profile_page.dart` |
| **클래스명** | PascalCase | `UserProfilePage` |
| **변수명** | camelCase | `userName` |
| **상수** | camelCase | `maxCollectionCount` |
| **Private** | _(언더스코어) 시작 | `_privateMethod()` |

### 폴더 구조

실제 트리는 `ls lib/`로 확인한다. 규칙만 적는다.

- **2개 이상 feature가 쓰면** → `lib/core/`
- **1개 feature만 쓰면** → `lib/features/<기능>/`
- feature 간 직접 import 금지. 공유가 필요하면 Provider로 참조한다.
- 각 feature는 `data/` · `domain/` · `presentation/` 3계층을 유지한다.

### 파일 Suffix 규칙

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

## 💻 코드 작성 규칙

### 변수 선언

- **const**: 컴파일 타임 상수 (`const int maxCollectionCount = 30`)
- **final**: 런타임에 한 번만 할당 (`final String id = uuid.v4()`)
- **var**: 지양, 타입 명시 권장

### Null Safety

- **Nullable**: `String?`, `int?`
- **Non-null 단언**: `value!` (주의 필요)
- **Null 체크 연산자**: `value ?? defaultValue`, `value?.method()`

### 비동기 처리

- `async`/`await` 사용
- `Future<T>` 반환 타입 명시
- `try-catch`로 에러 처리

### 주석

- **Public API**: DartDoc 주석 (`///`) 필수
- **복잡한 로직**: 한글 설명 주석 권장
- **TODO**: `// TODO(이름): 설명`

### 에러 처리

- **Custom Exception** 사용 (Either 패턴 사용 안 함)
- `NetworkException`, `ValidationException`, `AuthException` 등
- Repository: Exception throw
- Use Case: Exception 전파 또는 비즈니스 검증
- Presentation: try-catch + AsyncValue.error()

### 로깅

- **개발**: `debugPrint()` 사용
- **프로덕션**: `AppLogger.debug/info/warning/error()`
- **에러 리포팅**: `ErrorReporter.reportError()`

---

## 🔧 코드 생성

### 언제 실행?

- `@riverpod`, `@freezed`, `@RestApi` 추가/수정 후
- `.g.dart`, `.freezed.dart` 파일 없을 때
- 빌드 에러 발생 시

### 명령어

```bash
# 1회 생성
flutter pub run build_runner build --delete-conflicting-outputs

# Watch 모드 (파일 변경 시 자동)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 어노테이션

| 어노테이션 | 용도 | 생성 파일 |
|-----------|------|-----------|
| `@riverpod` | Riverpod Provider | `*.g.dart` |
| `@freezed` | 불변 데이터 클래스 | `*.freezed.dart` |
| `@JsonSerializable()` | JSON 직렬화 | `*.g.dart` |
| `@RestApi()` | REST API 인터페이스 | `*.g.dart` |

---

## 🎨 위젯 작성

### 위젯 선택

- **StatelessWidget**: 상태 없는 UI
- **StatefulWidget**: 내부 상태 관리 필요 시
- **ConsumerWidget**: Riverpod Provider 사용 시

### 생성자

- `const` 생성자 사용 권장 (성능 최적화)
- `Key` 파라미터 선택적 포함

### 빌드 메서드

- 중첩 깊이 3단계 이하 유지
- 복잡한 위젯은 별도 Widget으로 분리

---

## ✅ 코드 리뷰 체크리스트

### 필수 체크

- [ ] 파일명 snake_case
- [ ] 클래스명 PascalCase
- [ ] Public API에 DartDoc 주석
- [ ] Null Safety 준수
- [ ] try-catch 에러 처리
- [ ] `const` 생성자 사용
- [ ] 코드 생성 파일 포함 (.g.dart, .freezed.dart)

### Clean Architecture 체크

- [ ] Data: Repository 구현만
- [ ] Domain: 비즈니스 로직만
- [ ] Presentation: UI와 Provider만
- [ ] 의존성 흐름: Presentation → Domain ← Data

### 성능 체크

- [ ] 불필요한 rebuild 방지
- [ ] 무한 루프 위험 없음
- [ ] 메모리 누수 위험 없음

---

## 🔑 핵심 원칙 요약

1. **파일명**: snake_case
2. **클래스명**: PascalCase
3. **변수명**: camelCase
4. **에러 처리**: try-catch (Either 패턴 사용 안 함)
5. **코드 생성**: @riverpod, @freezed, @RestApi 사용
6. **3계층 구조**: Data, Domain, Presentation 분리
7. **const 생성자**: 가능한 모든 곳에서 사용
8. **Public API**: 반드시 DartDoc 주석

---

## 📌 자주 묻는 질문

**Q: 파일을 어디에 만들어야 하나요?**
A: 2개 이상 feature가 쓰면 `lib/core/`, 하나만 쓰면 `lib/features/<기능>/`. 위 "폴더 구조" 참조

**Q: 코드 생성이 안 돼요**
A: `flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs`

**Q: Either 패턴을 써야 하나요?**
A: 아니요. 프로젝트에서 제거되었습니다. try-catch 사용

**Q: Repository에서 에러를 어떻게 처리하나요?**
A: `DioExceptionHandler.handle(e)`로 변환해 throw합니다. [02_API_INTEGRATION_GUIDE.md](02_API_INTEGRATION_GUIDE.md) 참조

---

**문서 작성**: Development Team
**최종 업데이트**: 2025-12-30
