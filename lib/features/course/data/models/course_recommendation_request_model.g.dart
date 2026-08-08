// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_recommendation_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseRecommendationRequestModelImpl
_$$CourseRecommendationRequestModelImplFromJson(Map<String, dynamic> json) =>
    _$CourseRecommendationRequestModelImpl(
      entrance: json['entrance'] as String,
      exit: json['exit'] as String,
      interestTypes: (json['interestTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      stayDurationMinutes: (json['stayDurationMinutes'] as num?)?.toInt(),
      companionType: json['companionType'] as String?,
    );

Map<String, dynamic> _$$CourseRecommendationRequestModelImplToJson(
  _$CourseRecommendationRequestModelImpl instance,
) => <String, dynamic>{
  'entrance': instance.entrance,
  'exit': instance.exit,
  if (instance.interestTypes case final value?) 'interestTypes': value,
  if (instance.stayDurationMinutes case final value?)
    'stayDurationMinutes': value,
  if (instance.companionType case final value?) 'companionType': value,
};
