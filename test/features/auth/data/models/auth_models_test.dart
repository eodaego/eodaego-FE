import 'package:eodaego/features/auth/data/models/login_request_model.dart';
import 'package:eodaego/features/auth/data/models/login_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginResponseModel', () {
    test('parses_flat_token_fields_from_spec_example', () {
      final model = LoginResponseModel.fromJson({
        'accessToken': 'eyJhbGciOiJIUzI1NiJ9.access',
        'refreshToken': 'eyJhbGciOiJIUzI1NiJ9.refresh',
        'firstLogin': false,
        'requiresAgreement': true,
        'nickname': '회원a1b2c3d4',
        'userId': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
      });

      expect(model.accessToken, 'eyJhbGciOiJIUzI1NiJ9.access');
      expect(model.refreshToken, 'eyJhbGciOiJIUzI1NiJ9.refresh');
      expect(model.firstLogin, isFalse);
      expect(model.requiresAgreement, isTrue);
      expect(model.nickname, '회원a1b2c3d4');
      expect(model.userId, '3fa85f64-5717-4562-b3fc-2c963f66afa6');
    });

    test('defaults_requires_agreement_to_true_when_absent', () {
      final model = LoginResponseModel.fromJson({
        'accessToken': 'a',
        'refreshToken': 'r',
        'userId': 'uuid',
      });

      // fail-closed: 서버가 값을 안 주면 약관 게이트를 열지 않는다
      expect(model.requiresAgreement, isTrue);
      expect(model.firstLogin, isFalse);
      expect(model.nickname, '');
    });

    test('throws_when_access_token_absent', () {
      expect(
        () => LoginResponseModel.fromJson({
          'refreshToken': 'r',
          'userId': 'uuid',
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('LoginRequestModel', () {
    test('omits_fcm_token_key_when_null', () {
      const model = LoginRequestModel(
        idToken: 'id-token',
        socialType: 'GOOGLE',
        deviceType: 'IOS',
        deviceId: 'device-uuid',
        fcmToken: null,
      );

      final json = model.toJson();

      // 키 자체가 없어야 서버가 기존 FCM 토큰을 보존한다
      expect(json.containsKey('fcmToken'), isFalse);
      expect(json, {
        'idToken': 'id-token',
        'socialType': 'GOOGLE',
        'deviceType': 'IOS',
        'deviceId': 'device-uuid',
      });
    });

    test('includes_fcm_token_when_present', () {
      const model = LoginRequestModel(
        idToken: 'id-token',
        socialType: 'APPLE',
        deviceType: 'ANDROID',
        deviceId: 'device-uuid',
        fcmToken: 'fcm-token',
      );

      expect(model.toJson()['fcmToken'], 'fcm-token');
    });
  });
}
