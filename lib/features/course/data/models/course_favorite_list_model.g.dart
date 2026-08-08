// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_favorite_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseFavoriteItemModelImpl _$$CourseFavoriteItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$CourseFavoriteItemModelImpl(
  course: json['course'] == null
      ? null
      : CourseModel.fromJson(json['course'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$CourseFavoriteItemModelImplToJson(
  _$CourseFavoriteItemModelImpl instance,
) => <String, dynamic>{'course': instance.course};

_$CourseFavoriteListModelImpl _$$CourseFavoriteListModelImplFromJson(
  Map<String, dynamic> json,
) => _$CourseFavoriteListModelImpl(
  totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => CourseFavoriteItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CourseFavoriteItemModel>[],
);

Map<String, dynamic> _$$CourseFavoriteListModelImplToJson(
  _$CourseFavoriteListModelImpl instance,
) => <String, dynamic>{
  'totalCount': instance.totalCount,
  'items': instance.items,
};
