// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoursePlaceModelImpl _$$CoursePlaceModelImplFromJson(
  Map<String, dynamic> json,
) => _$CoursePlaceModelImpl(
  visitOrder: (json['visitOrder'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  category: json['category'] as String?,
);

Map<String, dynamic> _$$CoursePlaceModelImplToJson(
  _$CoursePlaceModelImpl instance,
) => <String, dynamic>{
  'visitOrder': instance.visitOrder,
  'name': instance.name,
  'category': instance.category,
};

_$CourseModelImpl _$$CourseModelImplFromJson(Map<String, dynamic> json) =>
    _$CourseModelImpl(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      tagLabels:
          (json['tagLabels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      estimatedDurationMinutes:
          (json['estimatedDurationMinutes'] as num?)?.toInt() ?? 0,
      entrance: json['entrance'] as String?,
      exit: json['exit'] as String?,
      favorite: json['favorite'] as bool? ?? false,
      places:
          (json['places'] as List<dynamic>?)
              ?.map((e) => CoursePlaceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CoursePlaceModel>[],
    );

Map<String, dynamic> _$$CourseModelImplToJson(_$CourseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'tagLabels': instance.tagLabels,
      'estimatedDurationMinutes': instance.estimatedDurationMinutes,
      'entrance': instance.entrance,
      'exit': instance.exit,
      'favorite': instance.favorite,
      'places': instance.places,
    };
