import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/quiz_question_source.dart';
import '../../domain/entities/quiz_question_entity.dart';

part 'quiz_provider.g.dart';

/// 퀴즈 문항 목록. 촬영마다 새로 읽지 않고 앱 생애주기 동안 한 번만 읽는다.
@riverpod
Future<List<QuizQuestionEntity>> quizQuestions(Ref ref) {
  return QuizQuestionSource().getQuestions();
}

/// 현재 라운드 인덱스 — 셔터를 누를 때마다 하나씩 올라간다.
///
/// 무작위가 아니라 순차 순환이다(설계 문서 §7) — 시연 중 같은 문제가
/// 연달아 나오는 걸 막는다.
@riverpod
class QuizRound extends _$QuizRound {
  @override
  int build() => 0;

  /// 다음 문항으로 넘긴다.
  void next() => state = state + 1;
}

/// [round]에 해당하는 문항을 계산한다.
///
/// **주의**: [questions]가 비어 있으면 안 된다 — 호출 전에 비어있음을 걸러낸다.
QuizQuestionEntity quizQuestionAt(
  List<QuizQuestionEntity> questions,
  int round,
) => questions[round % questions.length];
