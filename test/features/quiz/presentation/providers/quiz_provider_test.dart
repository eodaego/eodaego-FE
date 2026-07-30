import 'package:eodaego/features/quiz/domain/entities/quiz_question_entity.dart';
import 'package:eodaego/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late List<QuizQuestionEntity> questions;

  setUp(() async {
    container = ProviderContainer();
    questions = await container.read(quizQuestionsProvider.future);
  });

  tearDown(() => container.dispose());

  test('has_6_questions_matching_the_fixture', () {
    expect(questions.length, 6);
  });

  test('advancing_the_round_moves_to_a_different_question', () {
    final first = quizQuestionAt(questions, 0);
    final second = quizQuestionAt(questions, 1);

    expect(second.name, isNot(first.name));
  });

  test('wraps_to_the_first_question_after_the_last', () {
    final first = quizQuestionAt(questions, 0);
    final afterLast = quizQuestionAt(questions, questions.length);

    expect(afterLast.name, first.name);
  });

  test('one_full_cycle_visits_every_question_exactly_once', () {
    final namesSeen = [
      for (var round = 0; round < questions.length; round++)
        quizQuestionAt(questions, round).name,
    ];

    expect(namesSeen.toSet().length, questions.length);
  });

  test('quizRound_starts_at_0_and_next_advances_state_by_1', () {
    expect(container.read(quizRoundProvider), 0);

    container.read(quizRoundProvider.notifier).next();
    expect(container.read(quizRoundProvider), 1);

    container.read(quizRoundProvider.notifier).next();
    expect(container.read(quizRoundProvider), 2);
  });

  test(
    'consecutive_shutter_presses_cycle_through_questions_and_wrap_around',
    () {
      final seenNames = <String>[];
      for (var i = 0; i < questions.length + 2; i++) {
        final round = container.read(quizRoundProvider);
        seenNames.add(quizQuestionAt(questions, round).name);
        container.read(quizRoundProvider.notifier).next();
      }

      // 처음 6개는 서로 다르고, 7번째부터는 처음과 같은 순서로 되풀이된다.
      expect(seenNames.sublist(0, 6).toSet().length, 6);
      expect(seenNames[6], seenNames[0]);
      expect(seenNames[7], seenNames[1]);
    },
  );
}
