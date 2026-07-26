// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseModelImpl _$$LoginResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoginResponseModelImpl(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  userId: json['userId'] as String,
  requiresAgreement: json['requiresAgreement'] as bool? ?? true,
  firstLogin: json['firstLogin'] as bool? ?? false,
  nickname: json['nickname'] as String? ?? '',
);

Map<String, dynamic> _$$LoginResponseModelImplToJson(
  _$LoginResponseModelImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'userId': instance.userId,
  'requiresAgreement': instance.requiresAgreement,
  'firstLogin': instance.firstLogin,
  'nickname': instance.nickname,
};
