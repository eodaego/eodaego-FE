import 'package:eodaego/features/user/data/models/agreement_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AgreementRequestModel', () {
    test('toJson은 4개 boolean 필드를 올바른 키로 직렬화한다', () {
      const model = AgreementRequestModel(
        termsOfServiceAgreed: true,
        privacyPolicyAgreed: true,
        locationInfoAgreed: true,
        marketingAgreed: false,
      );

      final json = model.toJson();

      expect(json, {
        'termsOfServiceAgreed': true,
        'privacyPolicyAgreed': true,
        'locationInfoAgreed': true,
        'marketingAgreed': false,
      });
    });

    test('fromJson은 JSON을 올바르게 역직렬화한다', () {
      final json = {
        'termsOfServiceAgreed': true,
        'privacyPolicyAgreed': false,
        'locationInfoAgreed': true,
        'marketingAgreed': true,
      };

      final model = AgreementRequestModel.fromJson(json);

      expect(model.termsOfServiceAgreed, true);
      expect(model.privacyPolicyAgreed, false);
      expect(model.locationInfoAgreed, true);
      expect(model.marketingAgreed, true);
    });

    test('copyWith는 지정된 필드만 변경한다', () {
      const original = AgreementRequestModel(
        termsOfServiceAgreed: true,
        privacyPolicyAgreed: true,
        locationInfoAgreed: true,
        marketingAgreed: false,
      );

      final updated = original.copyWith(marketingAgreed: true);

      expect(updated.termsOfServiceAgreed, true);
      expect(updated.privacyPolicyAgreed, true);
      expect(updated.locationInfoAgreed, true);
      expect(updated.marketingAgreed, true);
    });

    test('동일한 값의 두 인스턴스는 같다', () {
      const model1 = AgreementRequestModel(
        termsOfServiceAgreed: true,
        privacyPolicyAgreed: true,
        locationInfoAgreed: true,
        marketingAgreed: false,
      );

      const model2 = AgreementRequestModel(
        termsOfServiceAgreed: true,
        privacyPolicyAgreed: true,
        locationInfoAgreed: true,
        marketingAgreed: false,
      );

      expect(model1, model2);
      expect(model1.hashCode, model2.hashCode);
    });
  });
}
