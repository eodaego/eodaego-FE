// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_item_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogItemSummaryModelImpl _$$CatalogItemSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$CatalogItemSummaryModelImpl(
  id: json['id'] as String,
  category: json['category'] as String,
  code: json['code'] as String?,
  name: json['name'] as String?,
  imageUrl: json['imageUrl'] as String?,
  collected: json['collected'] as bool? ?? false,
);

Map<String, dynamic> _$$CatalogItemSummaryModelImplToJson(
  _$CatalogItemSummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'code': instance.code,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'collected': instance.collected,
};
