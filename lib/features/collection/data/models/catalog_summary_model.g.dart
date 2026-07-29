// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogCategorySummaryModelImpl _$$CatalogCategorySummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$CatalogCategorySummaryModelImpl(
  category: json['category'] as String,
  totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
  collectedCount: (json['collectedCount'] as num?)?.toInt() ?? 0,
  collectionRate: (json['collectionRate'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$$CatalogCategorySummaryModelImplToJson(
  _$CatalogCategorySummaryModelImpl instance,
) => <String, dynamic>{
  'category': instance.category,
  'totalCount': instance.totalCount,
  'collectedCount': instance.collectedCount,
  'collectionRate': instance.collectionRate,
};

_$CatalogSummaryModelImpl _$$CatalogSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$CatalogSummaryModelImpl(
  totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
  collectedCount: (json['collectedCount'] as num?)?.toInt() ?? 0,
  collectionRate: (json['collectionRate'] as num?)?.toDouble() ?? 0,
  byCategory:
      (json['byCategory'] as List<dynamic>?)
          ?.map(
            (e) =>
                CatalogCategorySummaryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CatalogCategorySummaryModel>[],
);

Map<String, dynamic> _$$CatalogSummaryModelImplToJson(
  _$CatalogSummaryModelImpl instance,
) => <String, dynamic>{
  'totalCount': instance.totalCount,
  'collectedCount': instance.collectedCount,
  'collectionRate': instance.collectionRate,
  'byCategory': instance.byCategory,
};
