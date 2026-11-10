import 'dart:math';

import 'package:dio/dio.dart';

import '../../../../core/mock/mock_asset_loader.dart';
import '../models/quiz_model.dart';
import 'quiz_remote_datasource.dart';

/// 목 퀴즈 데이터소스
///
/// `assets/mock/catalog.json`의 요청 카테고리(이름이 있는 항목)에서 정답 1 + 오답 2를
/// 무작위 순서로 낸다. 정답 id를 `quizId`별로 메모리에 들고 판정하므로
/// 이 데이터소스를 만드는 provider는 keepAlive여야 한다. 이미지는 쓰지 않는다.
class QuizMockDataSource implements QuizRemoteDataSource {
  static const _asset = 'assets/mock/catalog.json';

  final _random = Random();
  final _answers = <String, String>{};
  var _seq = 0;

  @override
  Future<QuizModel> createQuiz(
    String catalogType,
    List<MultipartFile> image,
  ) async {
    final json = await loadMockJson(_asset);
    final items = [
      for (final item in json['items'] as List)
        // 미수집 항목은 서버가 이름을 숨겨(null) 선택지로 못 쓴다 — 이름 있는 항목만.
        if ((item as Map<String, dynamic>)['category'] == catalogType &&
            item['name'] != null)
          item,
    ]..shuffle(_random);

    final picked = items.take(3).toList();
    final quizId = 'mock-quiz-${_seq++}';
    _answers[quizId] = picked.first['id'] as String;
    picked.shuffle(_random);
    return QuizModel(
      quizId: quizId,
      choices: [
        for (final item in picked)
          QuizChoiceModel(
            catalogItemId: item['id'] as String,
            name: item['name'] as String,
          ),
      ],
    );
  }

  @override
  Future<QuizAnswerModel> submitAnswer(
    String quizId,
    QuizAnswerRequestModel body,
  ) async {
    final correct = _answers[quizId] == body.selectedCatalogItemId;
    return QuizAnswerModel(
      correct: correct,
      collectedCatalogItemId: correct ? body.selectedCatalogItemId : null,
    );
  }
}
