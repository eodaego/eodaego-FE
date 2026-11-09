import '../../../core/errors/app_exception.dart';

// 문구 상수 — ux-writing 검토로 문장이 바뀌면 여기만 고친다.
const scanRecognitionFailedMessage = '무엇인지 알아보지 못했어요. 종류를 바꿔서 다시 찍어볼까요?';
const scanImageRejectedMessage = '사진을 보내지 못했어요. 다시 찍어주세요.';
const scanUnavailableMessage = '지금은 사진을 볼 수 없어요. 잠시 후 다시 찍어주세요.';
const answerExpiredMessage = '퀴즈 시간이 지났어요. 다시 찍어볼까요?';
const answerFailedMessage = '답을 보내지 못했어요. 다시 눌러주세요.';

String? _code(Object error) => error is AppException ? error.code : null;

/// 사진 인식(퀴즈 생성) 실패 안내. 네트워크·서버 장애·알 수 없는 오류는 모두 마지막 문구.
String scanErrorMessage(Object error) => switch (_code(error)) {
  'RECOGNITION_FAILED' => scanRecognitionFailedMessage,
  'IMAGE_TOO_LARGE' ||
  'INVALID_IMAGE_FORMAT' ||
  'INVALID_REQUEST' => scanImageRejectedMessage,
  _ => scanUnavailableMessage,
};

/// 정답 제출 실패 안내.
String answerErrorMessage(Object error) => _code(error) == 'QUIZ_NOT_FOUND'
    ? answerExpiredMessage
    : answerFailedMessage;

// 퀴즈·보상 화면 문구
const quizQuestionAnimal = '이 친구 이름이 뭘까요?';
const quizQuestionPlant = '이 식물 이름이 뭘까요?';
const quizQuestionPlace = '여기는 어디일까요?';
const rewardNewMessage = '도감에 새 친구를 등록했어요';
const rewardAgainMessage = '또 만났네요! 이미 도감에 있는 친구예요';
