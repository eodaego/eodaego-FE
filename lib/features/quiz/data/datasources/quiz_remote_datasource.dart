import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/quiz_model.dart';

part 'quiz_remote_datasource.g.dart';

/// 사진 인식 퀴즈 백엔드 API 클라이언트
///
/// **엔드포인트**:
/// - `POST /api/1/quiz?catalogType=` - 사진으로 퀴즈 생성 (JWT, multipart `image`)
/// - `POST /api/1/quiz/{quizId}/answer` - 정답 제출 (JWT)
@RestApi()
abstract class QuizRemoteDataSource {
  factory QuizRemoteDataSource(Dio dio) = _QuizRemoteDataSource;

  /// 퀴즈 생성 — 422 `RECOGNITION_FAILED`면 사진에서 인식하지 못한 것이다.
  ///
  /// **주의**: [image]는 항상 1장짜리 리스트다. retrofit_generator 9.7.0은 단일
  /// `MultipartFile` 파트를 지원하지 않아(`toJson() method have to add` 예외),
  /// 리스트로 받으면 각 원소를 `image` 필드에 그대로 싣는다.
  @POST(ApiEndpoints.quiz)
  @MultiPart()
  Future<QuizModel> createQuiz(
    @Query('catalogType') String catalogType,
    @Part(name: 'image') List<MultipartFile> image,
  );

  /// 정답 제출 — 오답도 200 `correct: false`
  @POST(ApiEndpoints.quizAnswer)
  Future<QuizAnswerModel> submitAnswer(
    @Path('quizId') String quizId,
    @Body() QuizAnswerRequestModel body,
  );
}
