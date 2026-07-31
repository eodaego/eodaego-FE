// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_item_detail_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CatalogItemDetailEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DogamCategory get category => throw _privateConstructorUsedError;
  String get feature => throw _privateConstructorUsedError;
  String get childDescription => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get collectedAt => throw _privateConstructorUsedError;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
  String? get code => throw _privateConstructorUsedError;

  /// Create a copy of CatalogItemDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogItemDetailEntityCopyWith<CatalogItemDetailEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogItemDetailEntityCopyWith<$Res> {
  factory $CatalogItemDetailEntityCopyWith(
    CatalogItemDetailEntity value,
    $Res Function(CatalogItemDetailEntity) then,
  ) = _$CatalogItemDetailEntityCopyWithImpl<$Res, CatalogItemDetailEntity>;
  @useResult
  $Res call({
    String id,
    String name,
    DogamCategory category,
    String feature,
    String childDescription,
    String? imageUrl,
    String? collectedAt,
    String? code,
  });
}

/// @nodoc
class _$CatalogItemDetailEntityCopyWithImpl<
  $Res,
  $Val extends CatalogItemDetailEntity
>
    implements $CatalogItemDetailEntityCopyWith<$Res> {
  _$CatalogItemDetailEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogItemDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? feature = null,
    Object? childDescription = null,
    Object? imageUrl = freezed,
    Object? collectedAt = freezed,
    Object? code = freezed,
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
                      as DogamCategory,
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
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CatalogItemDetailEntityImplCopyWith<$Res>
    implements $CatalogItemDetailEntityCopyWith<$Res> {
  factory _$$CatalogItemDetailEntityImplCopyWith(
    _$CatalogItemDetailEntityImpl value,
    $Res Function(_$CatalogItemDetailEntityImpl) then,
  ) = __$$CatalogItemDetailEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    DogamCategory category,
    String feature,
    String childDescription,
    String? imageUrl,
    String? collectedAt,
    String? code,
  });
}

/// @nodoc
class __$$CatalogItemDetailEntityImplCopyWithImpl<$Res>
    extends
        _$CatalogItemDetailEntityCopyWithImpl<
          $Res,
          _$CatalogItemDetailEntityImpl
        >
    implements _$$CatalogItemDetailEntityImplCopyWith<$Res> {
  __$$CatalogItemDetailEntityImplCopyWithImpl(
    _$CatalogItemDetailEntityImpl _value,
    $Res Function(_$CatalogItemDetailEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogItemDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? feature = null,
    Object? childDescription = null,
    Object? imageUrl = freezed,
    Object? collectedAt = freezed,
    Object? code = freezed,
  }) {
    return _then(
      _$CatalogItemDetailEntityImpl(
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
                  as DogamCategory,
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
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CatalogItemDetailEntityImpl implements _CatalogItemDetailEntity {
  const _$CatalogItemDetailEntityImpl({
    required this.id,
    required this.name,
    required this.category,
    required this.feature,
    required this.childDescription,
    this.imageUrl,
    this.collectedAt,
    this.code,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final DogamCategory category;
  @override
  final String feature;
  @override
  final String childDescription;
  @override
  final String? imageUrl;
  @override
  final String? collectedAt;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
  @override
  final String? code;

  @override
  String toString() {
    return 'CatalogItemDetailEntity(id: $id, name: $name, category: $category, feature: $feature, childDescription: $childDescription, imageUrl: $imageUrl, collectedAt: $collectedAt, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogItemDetailEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.feature, feature) || other.feature == feature) &&
            (identical(other.childDescription, childDescription) ||
                other.childDescription == childDescription) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.collectedAt, collectedAt) ||
                other.collectedAt == collectedAt) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    category,
    feature,
    childDescription,
    imageUrl,
    collectedAt,
    code,
  );

  /// Create a copy of CatalogItemDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogItemDetailEntityImplCopyWith<_$CatalogItemDetailEntityImpl>
  get copyWith =>
      __$$CatalogItemDetailEntityImplCopyWithImpl<
        _$CatalogItemDetailEntityImpl
      >(this, _$identity);
}

abstract class _CatalogItemDetailEntity implements CatalogItemDetailEntity {
  const factory _CatalogItemDetailEntity({
    required final String id,
    required final String name,
    required final DogamCategory category,
    required final String feature,
    required final String childDescription,
    final String? imageUrl,
    final String? collectedAt,
    final String? code,
  }) = _$CatalogItemDetailEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  DogamCategory get category;
  @override
  String get feature;
  @override
  String get childDescription;
  @override
  String? get imageUrl;
  @override
  String? get collectedAt;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
  @override
  String? get code;

  /// Create a copy of CatalogItemDetailEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogItemDetailEntityImplCopyWith<_$CatalogItemDetailEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
