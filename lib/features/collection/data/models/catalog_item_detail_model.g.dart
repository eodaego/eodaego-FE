// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_item_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogItemDetailModelImpl _$$CatalogItemDetailModelImplFromJson(
  Map<String, dynamic> json,
) => _$CatalogItemDetailModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  feature: json['feature'] as String? ?? '',
  childDescription: json['childDescription'] as String? ?? '',
  imageUrl: json['imageUrl'] as String?,
  collectedAt: json['collectedAt'] as String?,
);

Map<String, dynamic> _$$CatalogItemDetailModelImplToJson(
  _$CatalogItemDetailModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'feature': instance.feature,
  'childDescription': instance.childDescription,
  'imageUrl': instance.imageUrl,
  'collectedAt': instance.collectedAt,
};
