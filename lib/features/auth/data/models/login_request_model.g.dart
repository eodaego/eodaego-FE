// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestModelImpl _$$LoginRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoginRequestModelImpl(
  idToken: json['idToken'] as String,
  socialType: json['socialType'] as String,
  deviceType: json['deviceType'] as String,
  deviceId: json['deviceId'] as String,
  fcmToken: json['fcmToken'] as String?,
);

Map<String, dynamic> _$$LoginRequestModelImplToJson(
  _$LoginRequestModelImpl instance,
) => <String, dynamic>{
  'idToken': instance.idToken,
  'socialType': instance.socialType,
  'deviceType': instance.deviceType,
  'deviceId': instance.deviceId,
  if (instance.fcmToken case final value?) 'fcmToken': value,
};
