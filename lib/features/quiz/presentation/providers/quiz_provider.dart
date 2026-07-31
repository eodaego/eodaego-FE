import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/quiz_question_source.dart';
import '../../domain/entities/quiz_question_entity.dart';

part 'quiz_provider.g.dart';

/// 퀴즈 문항 목록. 화면이 보고 있는 동안은 캐시되고, 아무도 보지 않는 순간
/// dispose됐다가 다음에 다시 읽는다(autoDispose) — 정적 에셋이라 다시 읽어도
/// 결과가 같으므로 무해하다.
@riverpod
Future<List<QuizQuestionEntity>> quizQuestions(Ref ref) {
  return QuizQuestionSource().getQuestions();
}

/// 현재 라운드 인덱스 — 셔터를 누를 때마다 하나씩 올라간다.
///
/// 무작위가 아니라 순차 순환이다(설계 문서 §7) — 시연 중 같은 문제가
/// 연달아 나오는 걸 막는다.
///
/// 앱 생애주기 동안 유지 (keepAlive) — scan_page가 `next()`를 부른 시점과
/// quiz_page가 처음 watch하는 시점 사이에는 이 provider를 보는 화면이 하나도
/// 없다. autoDispose였다면 그 틈에 상태가 사라지고 0으로 리셋될 수 있어
/// (Riverpod의 프레임 유예에 기대는 셈이라 위험하다), 촬영할 때마다 수달만
/// 나오는 시연 사고로 이어진다.
@Riverpod(keepAlive: true)
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
