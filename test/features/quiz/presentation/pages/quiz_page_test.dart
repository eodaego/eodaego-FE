import 'package:eodaego/features/quiz/presentation/quiz_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/quiz_page_harness.dart';

void main() {
  testWidgets('quiz_page_shows_server_choices_and_category_question', (
    tester,
  ) async {
    await pumpQuizApp(tester, repo: FakeQuizRepository());

    expect(find.text(quizQuestionAnimal), findsOneWidget);
    for (final name in ['수달', '너구리', '오소리']) {
      expect(find.text(name), findsOneWidget);
    }
  });

  testWidgets(
    'quiz_page_shows_taken_photo_instead_of_category_icon_when_photo_exists',
    (tester) async {
      await pumpQuizApp(tester, repo: FakeQuizRepository(), imagePath: 'p.jpg');
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.pets), findsNothing);
    },
  );

  testWidgets('quiz_page_shows_category_icon_when_no_photo', (tester) async {
    await pumpQuizApp(tester, repo: FakeQuizRepository());
    expect(find.byIcon(Icons.pets), findsOneWidget);
  });

  testWidgets('wrong_choice_is_locked_and_others_stay_tappable', (
    tester,
  ) async {
    final repo = FakeQuizRepository();
    await pumpQuizApp(tester, repo: repo);

    await tester.tap(find.text('너구리'));
    await tester.pump();
    await tester.tap(find.text('너구리'));
    await tester.pump();
    expect(repo.submitted, ['b']);
    final locked = tester.widget<Text>(find.text('너구리'));
    expect(locked.style?.decoration, TextDecoration.lineThrough);

    await tester.tap(find.text('오소리'));
    await tester.pump();
    expect(repo.submitted, ['b', 'c']);
  });

  testWidgets('correct_choice_opens_reward', (tester) async {
    await pumpQuizApp(tester, repo: FakeQuizRepository());

    await tester.tap(find.text('수달'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('정답이에요!'), findsOneWidget);
  });

  testWidgets('expired_quiz_sends_user_back_to_scan_with_message', (
    tester,
  ) async {
    await pumpQuizApp(tester, repo: FakeQuizRepository(expired: true));

    await tester.tap(find.text('수달'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('SCAN_PAGE animal'), findsOneWidget);
    expect(find.text(answerExpiredMessage), findsOneWidget);
  });

  testWidgets('quiz_page_sends_user_to_scan_when_no_session', (tester) async {
    await pumpQuizApp(tester, repo: FakeQuizRepository(), startSession: false);
    await tester.pump();

    expect(find.text('SCAN_PAGE '), findsOneWidget);
  });
}
