import 'package:flutter_test/flutter_test.dart';
import 'package:eodaego/core/network/api_error_response.dart';

void main() {
  group('ApiErrorResponse.tryParse', () {
    test('parses_error_code_and_message', () {
      final result = ApiErrorResponse.tryParse({
        'errorCode': 'NICKNAME_ALREADY_EXISTS',
        'errorMessage': '이미 사용 중인 닉네임입니다.',
      });

      expect(result, isNotNull);
      expect(result!.errorCode, 'NICKNAME_ALREADY_EXISTS');
      expect(result.errorMessage, '이미 사용 중인 닉네임입니다.');
      expect(result.fieldErrors, isNull);
    });

    test('parses_field_errors_for_validation_failure', () {
      final result = ApiErrorResponse.tryParse({
        'errorCode': 'INVALID_REQUEST',
        'errorMessage': '잘못된 요청입니다.',
        'fieldErrors': [
          {'field': 'socialType', 'reason': '널이어서는 안됩니다'},
        ],
      });

      expect(result!.fieldErrors, hasLength(1));
      expect(result.fieldErrors!.first.field, 'socialType');
      expect(result.fieldErrors!.first.reason, '널이어서는 안됩니다');
    });

    test('parses_when_only_error_message_present', () {
      final result = ApiErrorResponse.tryParse({
        'errorMessage': '서버 오류',
      });

      expect(result, isNotNull);
      expect(result!.errorCode, isNull);
      expect(result.errorMessage, '서버 오류');
    });

    test('returns_null_for_non_error_body', () {
      expect(ApiErrorResponse.tryParse({'ok': true}), isNull);
      expect(ApiErrorResponse.tryParse(null), isNull);
      expect(ApiErrorResponse.tryParse('plain text'), isNull);
    });

    test('ignores_malformed_field_errors_entries', () {
      final result = ApiErrorResponse.tryParse({
        'errorCode': 'INVALID_REQUEST',
        'fieldErrors': ['not-a-map', 42],
      });

      expect(result, isNotNull);
      expect(result!.fieldErrors, isEmpty);
    });
  });
}
