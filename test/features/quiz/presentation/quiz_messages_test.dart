import 'package:eodaego/core/errors/app_exception.dart';
import 'package:eodaego/features/quiz/presentation/quiz_messages.dart';
import 'package:flutter_test/flutter_test.dart';

ServerException _e(String code) => ServerException(message: 'x', code: code);

void main() {
  test('scanErrorMessage_for_recognition_failed_suggests_switching_category', () {
    expect(
      scanErrorMessage(_e('RECOGNITION_FAILED')),
      '무엇인지 알아보지 못했어요. 종류를 바꿔서 다시 찍어볼까요?',
    );
  });

  test('scanErrorMessage_for_rejected_image_asks_to_retake', () {
    for (final code in [
      'IMAGE_TOO_LARGE',
      'INVALID_IMAGE_FORMAT',
      'INVALID_REQUEST',
    ]) {
      expect(scanErrorMessage(_e(code)), '사진을 보내지 못했어요. 다시 찍어주세요.');
    }
  });

  test('scanErrorMessage_for_server_down_network_or_unknown_asks_to_wait', () {
    const expected = '지금은 사진을 볼 수 없어요. 잠시 후 다시 찍어주세요.';
    expect(scanErrorMessage(_e('AI_SERVER_UNAVAILABLE')), expected);
    expect(scanErrorMessage(const NetworkException(message: 'x')), expected);
    expect(scanErrorMessage(Exception('?')), expected);
  });

  test('answerErrorMessage_for_quiz_not_found_says_time_is_up', () {
    expect(
      answerErrorMessage(_e('QUIZ_NOT_FOUND')),
      '퀴즈 시간이 지났어요. 다시 찍어볼까요?',
    );
  });

  test('answerErrorMessage_for_other_errors_asks_to_press_again', () {
    expect(answerErrorMessage(_e('X')), '답을 보내지 못했어요. 다시 눌러주세요.');
    expect(
      answerErrorMessage(const NetworkException(message: 'x')),
      '답을 보내지 못했어요. 다시 눌러주세요.',
    );
  });
}
