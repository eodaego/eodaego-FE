import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

/// 퀴즈 생성 응답 DTO — `POST /api/1/quiz`
@freezed
class QuizModel with _$QuizModel {
  const factory QuizModel({
    required String quizId,
    @Default(<QuizChoiceModel>[]) List<QuizChoiceModel> choices,
  }) = _QuizModel;

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);
}

/// 퀴즈 선택지 DTO
@freezed
class QuizChoiceModel with _$QuizChoiceModel {
  const factory QuizChoiceModel({
    required String catalogItemId,
    required String name,
  }) = _QuizChoiceModel;

  factory QuizChoiceModel.fromJson(Map<String, dynamic> json) =>
      _$QuizChoiceModelFromJson(json);
}

/// 정답 제출 요청 DTO — `POST /api/1/quiz/{quizId}/answer`
@freezed
class QuizAnswerRequestModel with _$QuizAnswerRequestModel {
  const factory QuizAnswerRequestModel({
    required String selectedCatalogItemId,
  }) = _QuizAnswerRequestModel;

  factory QuizAnswerRequestModel.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerRequestModelFromJson(json);
}

/// 정답 제출 응답 DTO. 오답은 에러가 아니라 `correct: false`다.
@freezed
class QuizAnswerModel with _$QuizAnswerModel {
  const factory QuizAnswerModel({
    required bool correct,
    String? collectedCatalogItemId,
  }) = _QuizAnswerModel;

  factory QuizAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerModelFromJson(json);
}
