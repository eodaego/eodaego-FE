// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AgreementResponseModelImpl _$$AgreementResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$AgreementResponseModelImpl(
  termsOfServiceAgreed: json['termsOfServiceAgreed'] as bool? ?? false,
  privacyPolicyAgreed: json['privacyPolicyAgreed'] as bool? ?? false,
  locationInfoAgreed: json['locationInfoAgreed'] as bool? ?? false,
  marketingAgreed: json['marketingAgreed'] as bool? ?? false,
  termsAgreedAt: json['termsAgreedAt'] as String?,
  marketingAgreedAt: json['marketingAgreedAt'] as String?,
);

Map<String, dynamic> _$$AgreementResponseModelImplToJson(
  _$AgreementResponseModelImpl instance,
) => <String, dynamic>{
  'termsOfServiceAgreed': instance.termsOfServiceAgreed,
  'privacyPolicyAgreed': instance.privacyPolicyAgreed,
  'locationInfoAgreed': instance.locationInfoAgreed,
  'marketingAgreed': instance.marketingAgreed,
  'termsAgreedAt': instance.termsAgreedAt,
  'marketingAgreedAt': instance.marketingAgreedAt,
};
