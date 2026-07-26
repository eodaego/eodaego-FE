// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AgreementRequestModelImpl _$$AgreementRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$AgreementRequestModelImpl(
  termsOfServiceAgreed: json['termsOfServiceAgreed'] as bool,
  privacyPolicyAgreed: json['privacyPolicyAgreed'] as bool,
  locationInfoAgreed: json['locationInfoAgreed'] as bool,
  marketingAgreed: json['marketingAgreed'] as bool,
);

Map<String, dynamic> _$$AgreementRequestModelImplToJson(
  _$AgreementRequestModelImpl instance,
) => <String, dynamic>{
  'termsOfServiceAgreed': instance.termsOfServiceAgreed,
  'privacyPolicyAgreed': instance.privacyPolicyAgreed,
  'locationInfoAgreed': instance.locationInfoAgreed,
  'marketingAgreed': instance.marketingAgreed,
};
