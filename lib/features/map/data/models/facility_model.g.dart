// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FacilityModelImpl _$$FacilityModelImplFromJson(Map<String, dynamic> json) =>
    _$FacilityModelImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      category: json['category'] as String? ?? '',
      name: json['name'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      facilityType: json['facilityType'] as String?,
    );

Map<String, dynamic> _$$FacilityModelImplToJson(_$FacilityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'facilityType': instance.facilityType,
    };

_$FacilityDetailModelImpl _$$FacilityDetailModelImplFromJson(
  Map<String, dynamic> json,
) => _$FacilityDetailModelImpl(
  id: (json['id'] as num?)?.toInt() ?? 0,
  category: json['category'] as String? ?? '',
  name: json['name'] as String? ?? '',
  intro: json['intro'] as String?,
  description: json['description'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  facilityType: json['facilityType'] as String?,
  openTime: json['openTime'] as String?,
  closeTime: json['closeTime'] as String?,
  operatingNote: json['operatingNote'] as String?,
);

Map<String, dynamic> _$$FacilityDetailModelImplToJson(
  _$FacilityDetailModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'name': instance.name,
  'intro': instance.intro,
  'description': instance.description,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'facilityType': instance.facilityType,
  'openTime': instance.openTime,
  'closeTime': instance.closeTime,
  'operatingNote': instance.operatingNote,
};
