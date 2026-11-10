import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eodaego/features/quiz/data/datasources/quiz_mock_datasource.dart';
import 'package:eodaego/features/quiz/data/models/quiz_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final placeIds = {
    for (final item
        in (jsonDecode(File('assets/mock/catalog.json').readAsStringSync())
                as Map)['items']
            as List)
      if (item['category'] == 'PLACE') item['id'] as String,
  };
  final image = [
    MultipartFile.fromBytes([1]),
  ];

  test('mock_quiz_offers_three_choices_from_requested_category', () async {
    final quiz = await QuizMockDataSource().createQuiz('PLACE', image);

    expect(quiz.choices, hasLength(3));
    expect(quiz.choices.map((c) => c.catalogItemId).toSet(), hasLength(3));
    expect(
      quiz.choices.every((c) => placeIds.contains(c.catalogItemId)),
      isTrue,
    );
  });

  test('mock_answer_is_correct_only_for_the_hidden_answer', () async {
    final source = QuizMockDataSource();
    final quiz = await source.createQuiz('PLACE', image);

    final results = [
      for (final c in quiz.choices)
        await source.submitAnswer(
          quiz.quizId,
          QuizAnswerRequestModel(selectedCatalogItemId: c.catalogItemId),
        ),
    ];

    expect(results.where((r) => r.correct), hasLength(1));
    final right = results.firstWhere((r) => r.correct);
    expect(right.collectedCatalogItemId, isNotNull);
    expect(
      results
          .where((r) => !r.correct)
          .every((r) => r.collectedCatalogItemId == null),
      isTrue,
    );
  });

  test('mock_quiz_works_without_image', () async {
    // 목은 이미지를 읽지 않는다 — 빈 파트로도 퀴즈가 나온다.
    final quiz = await QuizMockDataSource().createQuiz('ANIMAL', [
      MultipartFile.fromBytes(const []),
    ]);
    expect(quiz.choices, hasLength(3));
  });
}
