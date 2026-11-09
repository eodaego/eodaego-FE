import '../../../../core/constants/dogam_category.dart';
import '../entities/quiz_entity.dart';

abstract class QuizRepository {
  /// 사진으로 퀴즈를 만든다. 실서버 경로에서 [imagePath]가 null이면
  /// `ValidationException`을 던진다.
  Future<QuizEntity> createQuiz({
    required DogamCategory category,
    required String? imagePath,
  });

  Future<QuizAnswerEntity> submitAnswer({
    required String quizId,
    required String catalogItemId,
  });
}
