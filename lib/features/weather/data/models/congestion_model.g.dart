// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'congestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CongestionModelImpl _$$CongestionModelImplFromJson(
  Map<String, dynamic> json,
) => _$CongestionModelImpl(
  level: json['level'] as String?,
  label: json['label'] as String? ?? '',
  collectedAt: json['collectedAt'] as String?,
);

Map<String, dynamic> _$$CongestionModelImplToJson(
  _$CongestionModelImpl instance,
) => <String, dynamic>{
  'level': instance.level,
  'label': instance.label,
  'collectedAt': instance.collectedAt,
};
