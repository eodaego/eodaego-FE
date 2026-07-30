import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/dogam_category.dart';

part 'quiz_question_entity.freezed.dart';

/// 퀴즈 문항 — 정답 이름·카테고리·질문·보기·정답 인덱스.
///
/// **주의**: [category]는 [DogamCategory.fromServer]로 이미 변환된 값이라
/// 항상 유효하다. 변환에 실패하는 문항은 로더 단계에서 건너뛴다.
@freezed
class QuizQuestionEntity with _$QuizQuestionEntity {
  const factory QuizQuestionEntity({
    required String name,
    required DogamCategory category,
    required String question,
    required List<String> choices,
    required int answerIndex,

    /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
    String? code,
  }) = _QuizQuestionEntity;
}
