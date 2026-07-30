import 'package:flutter/foundation.dart';

import '../../../core/constants/dogam_category.dart';
import '../../../core/mock/mock_asset_loader.dart';
import '../domain/entities/quiz_question_entity.dart';

/// 퀴즈 문항 소스 — `assets/mock/quiz.json`을 읽어 엔티티로 변환한다.
///
/// 퀴즈는 백엔드 API가 없어 `useMockData` 플래그와 무관하게 항상 이 파일을
/// 읽는다(설계 문서 §7).
class QuizQuestionSource {
  static const _asset = 'assets/mock/quiz.json';

  /// 문항 목록을 읽는다.
  ///
  /// **주의**: `category`가 [DogamCategory.fromServer]로 변환되지 않는 문항은
  /// 건너뛴다 — 도감 목록과 같은 방어다. 색·아이콘을 그릴 수 없기 때문이다.
  Future<List<QuizQuestionEntity>> getQuestions() async {
    final json = await loadMockJson(_asset);
    final rawQuestions = (json['questions'] as List)
        .cast<Map<String, dynamic>>();

    final questions = <QuizQuestionEntity>[];
    for (final raw in rawQuestions) {
      final category = DogamCategory.fromServer(raw['category'] as String?);
      if (category == null) {
        debugPrint('[Quiz] ⚠️ 알 수 없는 카테고리: ${raw['category']} — 문항 제외');
        continue;
      }
      questions.add(
        QuizQuestionEntity(
          name: raw['name'] as String,
          category: category,
          question: raw['question'] as String,
          choices: (raw['choices'] as List).cast<String>(),
          answerIndex: raw['answerIndex'] as int,
        ),
      );
    }
    return questions;
  }
}
