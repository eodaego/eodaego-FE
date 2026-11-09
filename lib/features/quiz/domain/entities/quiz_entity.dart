/// 사진 인식 퀴즈 — 선택지 3개
class QuizEntity {
  const QuizEntity({required this.quizId, required this.choices});

  final String quizId;
  final List<QuizChoiceEntity> choices;
}

class QuizChoiceEntity {
  const QuizChoiceEntity({required this.catalogItemId, required this.name});

  final String catalogItemId;
  final String name;
}

/// 정답 제출 결과. 오답이면 [collectedCatalogItemId]는 null이다.
class QuizAnswerEntity {
  const QuizAnswerEntity({required this.correct, this.collectedCatalogItemId});

  final bool correct;
  final String? collectedCatalogItemId;
}
