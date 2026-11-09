import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_message_keys.dart';
import '../../../../core/constants/dogam_category.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/dio_exception_handler.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_remote_datasource.dart';
import '../models/quiz_model.dart';

/// Quiz Repository 구현체
class QuizRepositoryImpl implements QuizRepository {
  QuizRepositoryImpl(this._dataSource);

  final QuizRemoteDataSource _dataSource;

  @override
  Future<QuizEntity> createQuiz({
    required DogamCategory category,
    required String? imagePath,
  }) async {
    if (imagePath == null) {
      throw const ValidationException(
        message: '사진을 찾지 못했어요. 다시 촬영해 주세요.',
        messageKey: AppMessageKeys.errorTemporaryRetry,
      );
    }
    try {
      // 서버 허용 형식(jpeg/png/webp/heic/heif, 10MB)에 맞춰 jpeg로 고정해 보낸다.
      final image = await MultipartFile.fromFile(
        imagePath,
        filename: 'quiz.jpg',
        contentType: DioMediaType('image', 'jpeg'),
      );
      final response = await _dataSource.createQuiz(category.serverValue, [
        image,
      ]);
      if (kDebugMode) {
        debugPrint('[Quiz] ✅ 퀴즈 생성 (${category.serverValue})');
      }
      return QuizEntity(
        quizId: response.quizId,
        choices: [
          for (final c in response.choices)
            QuizChoiceEntity(catalogItemId: c.catalogItemId, name: c.name),
        ],
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '퀴즈를 만들지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorTemporaryRetry,
        originalException: e,
      );
    }
  }

  @override
  Future<QuizAnswerEntity> submitAnswer({
    required String quizId,
    required String catalogItemId,
  }) async {
    try {
      final response = await _dataSource.submitAnswer(
        quizId,
        QuizAnswerRequestModel(selectedCatalogItemId: catalogItemId),
      );
      return QuizAnswerEntity(
        correct: response.correct,
        collectedCatalogItemId: response.collectedCatalogItemId,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: '정답을 확인하지 못했어요. 잠시 후 다시 시도해 주세요.',
        messageKey: AppMessageKeys.errorTemporaryRetry,
        originalException: e,
      );
    }
  }
}
