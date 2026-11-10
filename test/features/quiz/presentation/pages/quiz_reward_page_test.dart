import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/features/collection/domain/entities/catalog_item_entity.dart';
import 'package:eodaego/features/collection/domain/repositories/catalog_repository.dart';
import 'package:eodaego/features/collection/presentation/providers/catalog_provider.dart';
import 'package:eodaego/features/quiz/presentation/providers/quiz_session_provider.dart';
import 'package:eodaego/features/quiz/presentation/quiz_messages.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/quiz_page_harness.dart';

class _CountingCatalogRepository implements CatalogRepository {
  int collectCalls = 0;

  @override
  Future<void> collectCatalogItem(String catalogItemId) async => collectCalls++;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _answerCorrectly(WidgetTester tester) async {
  await tester.tap(find.text('수달'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('reward_shows_new_message_when_item_was_not_collected', (
    tester,
  ) async {
    await pumpQuizApp(tester, repo: FakeQuizRepository());
    await _answerCorrectly(tester);

    expect(find.text(rewardNewMessage), findsOneWidget);
    expect(find.text('수달'), findsWidgets);
  });

  testWidgets('reward_shows_again_message_when_already_collected', (
    tester,
  ) async {
    await pumpQuizApp(
      tester,
      repo: FakeQuizRepository(),
      catalog: const [
        CatalogItemEntity(
          id: 'a',
          category: DogamCategory.animal,
          collected: true,
        ),
      ],
    );
    await _answerCorrectly(tester);

    expect(find.text(rewardAgainMessage), findsOneWidget);
    expect(find.text(rewardNewMessage), findsNothing);
  });

  testWidgets('reward_button_opens_collected_item_detail', (tester) async {
    await pumpQuizApp(tester, repo: FakeQuizRepository());
    await _answerCorrectly(tester);

    await tester.tap(find.text('도감 보러 가기'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('DETAIL_a'), findsOneWidget);
  });

  testWidgets('reward_page_does_not_call_collect_api', (tester) async {
    final catalog = _CountingCatalogRepository();
    await pumpQuizApp(
      tester,
      repo: FakeQuizRepository(),
      extraOverrides: [catalogRepositoryProvider.overrideWithValue(catalog)],
    );
    await _answerCorrectly(tester);

    expect(find.text('정답이에요!'), findsOneWidget);
    expect(catalog.collectCalls, 0);
  });

  testWidgets('reward_page_sends_user_to_scan_when_no_result', (tester) async {
    final container = await pumpQuizApp(tester, repo: FakeQuizRepository());
    container.read(quizSessionProvider.notifier).clear();
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.text('SCAN_PAGE '), findsOneWidget);
  });
}
