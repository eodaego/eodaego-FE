// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogListResponseModelImpl _$$CatalogListResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$CatalogListResponseModelImpl(
  totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
  collectedCount: (json['collectedCount'] as num?)?.toInt() ?? 0,
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => CatalogItemSummaryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CatalogItemSummaryModel>[],
);

Map<String, dynamic> _$$CatalogListResponseModelImplToJson(
  _$CatalogListResponseModelImpl instance,
) => <String, dynamic>{
  'totalCount': instance.totalCount,
  'collectedCount': instance.collectedCount,
  'items': instance.items,
};
