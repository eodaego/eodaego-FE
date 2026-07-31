// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_item_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CatalogItemDetailModel _$CatalogItemDetailModelFromJson(
  Map<String, dynamic> json,
) {
  return _CatalogItemDetailModel.fromJson(json);
}

/// @nodoc
mixin _$CatalogItemDetailModel {
  /// 도감 항목 ID
  String get id => throw _privateConstructorUsedError;

  /// 이름
  String get name => throw _privateConstructorUsedError;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  String get category => throw _privateConstructorUsedError;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 서버가 생략하면 null
  String? get code => throw _privateConstructorUsedError;

  /// 특징 — 앱에서 한 줄 설명 자리에 쓴다
  String get feature => throw _privateConstructorUsedError;

  /// 어린이 눈높이 설명
  String get childDescription => throw _privateConstructorUsedError;

  /// 이미지 URL
  String? get imageUrl => throw _privateConstructorUsedError;

  /// 수집 시각 (ISO 8601)
  String? get collectedAt => throw _privateConstructorUsedError;

  /// Serializes this CatalogItemDetailModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogItemDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogItemDetailModelCopyWith<CatalogItemDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogItemDetailModelCopyWith<$Res> {
  factory $CatalogItemDetailModelCopyWith(
    CatalogItemDetailModel value,
    $Res Function(CatalogItemDetailModel) then,
  ) = _$CatalogItemDetailModelCopyWithImpl<$Res, CatalogItemDetailModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String category,
    String? code,
    String feature,
    String childDescription,
    String? imageUrl,
    String? collectedAt,
  });
}

/// @nodoc
class _$CatalogItemDetailModelCopyWithImpl<
  $Res,
  $Val extends CatalogItemDetailModel
>
    implements $CatalogItemDetailModelCopyWith<$Res> {
  _$CatalogItemDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogItemDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? code = freezed,
    Object? feature = null,
    Object? childDescription = null,
    Object? imageUrl = freezed,
    Object? collectedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
            feature: null == feature
                ? _value.feature
                : feature // ignore: cast_nullable_to_non_nullable
                      as String,
            childDescription: null == childDescription
                ? _value.childDescription
                : childDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            collectedAt: freezed == collectedAt
                ? _value.collectedAt
                : collectedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CatalogItemDetailModelImplCopyWith<$Res>
    implements $CatalogItemDetailModelCopyWith<$Res> {
  factory _$$CatalogItemDetailModelImplCopyWith(
    _$CatalogItemDetailModelImpl value,
    $Res Function(_$CatalogItemDetailModelImpl) then,
  ) = __$$CatalogItemDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String category,
    String? code,
    String feature,
    String childDescription,
    String? imageUrl,
    String? collectedAt,
  });
}

/// @nodoc
class __$$CatalogItemDetailModelImplCopyWithImpl<$Res>
    extends
        _$CatalogItemDetailModelCopyWithImpl<$Res, _$CatalogItemDetailModelImpl>
    implements _$$CatalogItemDetailModelImplCopyWith<$Res> {
  __$$CatalogItemDetailModelImplCopyWithImpl(
    _$CatalogItemDetailModelImpl _value,
    $Res Function(_$CatalogItemDetailModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogItemDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? code = freezed,
    Object? feature = null,
    Object? childDescription = null,
    Object? imageUrl = freezed,
    Object? collectedAt = freezed,
  }) {
    return _then(
      _$CatalogItemDetailModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        feature: null == feature
            ? _value.feature
            : feature // ignore: cast_nullable_to_non_nullable
                  as String,
        childDescription: null == childDescription
            ? _value.childDescription
            : childDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        collectedAt: freezed == collectedAt
            ? _value.collectedAt
            : collectedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogItemDetailModelImpl implements _CatalogItemDetailModel {
  const _$CatalogItemDetailModelImpl({
    required this.id,
    required this.name,
    required this.category,
    this.code,
    this.feature = '',
    this.childDescription = '',
    this.imageUrl,
    this.collectedAt,
  });

  factory _$CatalogItemDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogItemDetailModelImplFromJson(json);

  /// 도감 항목 ID
  @override
  final String id;

  /// 이름
  @override
  final String name;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  @override
  final String category;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 서버가 생략하면 null
  @override
  final String? code;

  /// 특징 — 앱에서 한 줄 설명 자리에 쓴다
  @override
  @JsonKey()
  final String feature;

  /// 어린이 눈높이 설명
  @override
  @JsonKey()
  final String childDescription;

  /// 이미지 URL
  @override
  final String? imageUrl;

  /// 수집 시각 (ISO 8601)
  @override
  final String? collectedAt;

  @override
  String toString() {
    return 'CatalogItemDetailModel(id: $id, name: $name, category: $category, code: $code, feature: $feature, childDescription: $childDescription, imageUrl: $imageUrl, collectedAt: $collectedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogItemDetailModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.feature, feature) || other.feature == feature) &&
            (identical(other.childDescription, childDescription) ||
                other.childDescription == childDescription) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.collectedAt, collectedAt) ||
                other.collectedAt == collectedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    category,
    code,
    feature,
    childDescription,
    imageUrl,
    collectedAt,
  );

  /// Create a copy of CatalogItemDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogItemDetailModelImplCopyWith<_$CatalogItemDetailModelImpl>
  get copyWith =>
      __$$CatalogItemDetailModelImplCopyWithImpl<_$CatalogItemDetailModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogItemDetailModelImplToJson(this);
  }
}

abstract class _CatalogItemDetailModel implements CatalogItemDetailModel {
  const factory _CatalogItemDetailModel({
    required final String id,
    required final String name,
    required final String category,
    final String? code,
    final String feature,
    final String childDescription,
    final String? imageUrl,
    final String? collectedAt,
  }) = _$CatalogItemDetailModelImpl;

  factory _CatalogItemDetailModel.fromJson(Map<String, dynamic> json) =
      _$CatalogItemDetailModelImpl.fromJson;

  /// 도감 항목 ID
  @override
  String get id;

  /// 이름
  @override
  String get name;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  @override
  String get category;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 서버가 생략하면 null
  @override
  String? get code;

  /// 특징 — 앱에서 한 줄 설명 자리에 쓴다
  @override
  String get feature;

  /// 어린이 눈높이 설명
  @override
  String get childDescription;

  /// 이미지 URL
  @override
  String? get imageUrl;

  /// 수집 시각 (ISO 8601)
  @override
  String? get collectedAt;

  /// Create a copy of CatalogItemDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogItemDetailModelImplCopyWith<_$CatalogItemDetailModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
