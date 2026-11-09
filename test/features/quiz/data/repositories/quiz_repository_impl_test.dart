import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eodaego/core/constants/dogam_category.dart';
import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/features/quiz/data/datasources/quiz_remote_datasource.dart';
import 'package:eodaego/features/quiz/data/models/quiz_model.dart';
import 'package:eodaego/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

/// HTTP 경계를 대신하는 페이크.
class _FakeQuizDataSource implements QuizRemoteDataSource {
  _FakeQuizDataSource({this.quiz, this.answer, this.error});

  final QuizModel? quiz;
  final QuizAnswerModel? answer;
  final Object? error;

  String? catalogType;
  List<MultipartFile>? image;

  @override
  Future<QuizModel> createQuiz(
    String catalogType,
    List<MultipartFile> image,
  ) async {
    this.catalogType = catalogType;
    this.image = image;
    if (error != null) throw error!;
    return quiz!;
  }

  @override
  Future<QuizAnswerModel> submitAnswer(
    String quizId,
    QuizAnswerRequestModel body,
  ) async => answer!;
}

void main() {
  late File photo;

  setUp(() {
    final dir = Directory.systemTemp.createTempSync('quiz_test');
    photo = File('${dir.path}/shot.heic')..writeAsBytesSync([1, 2, 3]);
  });

  const threeChoices = QuizModel(
    quizId: 'q1',
    choices: [
      QuizChoiceModel(catalogItemId: 'a', name: '수달'),
      QuizChoiceModel(catalogItemId: 'b', name: '사자'),
      QuizChoiceModel(catalogItemId: 'c', name: '코끼리'),
    ],
  );

  test('createQuiz_sends_category_server_value_and_jpeg_part', () async {
    final fake = _FakeQuizDataSource(quiz: threeChoices);
    await QuizRepositoryImpl(
      fake,
    ).createQuiz(category: DogamCategory.plant, imagePath: photo.path);

    expect(fake.catalogType, 'PLANT');
    expect(fake.image, hasLength(1));
    expect(fake.image!.single.contentType.toString(), 'image/jpeg');
    expect(fake.image!.single.filename, endsWith('.jpg'));
  });

  test('createQuiz_maps_three_choices', () async {
    final quiz = await QuizRepositoryImpl(
      _FakeQuizDataSource(quiz: threeChoices),
    ).createQuiz(category: DogamCategory.animal, imagePath: photo.path);

    expect(quiz.quizId, 'q1');
    expect(quiz.choices.map((c) => c.name), ['수달', '사자', '코끼리']);
    expect(quiz.choices.first.catalogItemId, 'a');
  });

  test('createQuiz_without_image_path_throws_validation_exception', () {
    final repo = QuizRepositoryImpl(_FakeQuizDataSource(quiz: threeChoices));
    expect(
      repo.createQuiz(category: DogamCategory.animal, imagePath: null),
      throwsA(isA<ValidationException>()),
    );
  });

  test('createQuiz_surfaces_recognition_failed_code', () async {
    final request = RequestOptions(path: '/api/1/quiz');
    final repo = QuizRepositoryImpl(
      _FakeQuizDataSource(
        error: DioException(
          requestOptions: request,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: request,
            statusCode: 422,
            data: {'errorCode': 'RECOGNITION_FAILED'},
          ),
        ),
      ),
    );

    await expectLater(
      repo.createQuiz(category: DogamCategory.place, imagePath: photo.path),
      throwsA(
        isA<AppException>().having((e) => e.code, 'code', 'RECOGNITION_FAILED'),
      ),
    );
  });

  test('submitAnswer_maps_wrong_answer_without_error', () async {
    final result = await QuizRepositoryImpl(
      _FakeQuizDataSource(answer: const QuizAnswerModel(correct: false)),
    ).submitAnswer(quizId: 'q1', catalogItemId: 'b');

    expect(result.correct, isFalse);
    expect(result.collectedCatalogItemId, isNull);
  });
}
