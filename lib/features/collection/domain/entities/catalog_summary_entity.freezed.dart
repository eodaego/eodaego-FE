// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_summary_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CatalogSummaryEntity {
  int get totalCount => throw _privateConstructorUsedError;
  int get collectedCount => throw _privateConstructorUsedError;
  double get collectionRate => throw _privateConstructorUsedError;
  Map<DogamCategory, int> get collectedByCategory =>
      throw _privateConstructorUsedError;

  /// Create a copy of CatalogSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogSummaryEntityCopyWith<CatalogSummaryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogSummaryEntityCopyWith<$Res> {
  factory $CatalogSummaryEntityCopyWith(
    CatalogSummaryEntity value,
    $Res Function(CatalogSummaryEntity) then,
  ) = _$CatalogSummaryEntityCopyWithImpl<$Res, CatalogSummaryEntity>;
  @useResult
  $Res call({
    int totalCount,
    int collectedCount,
    double collectionRate,
    Map<DogamCategory, int> collectedByCategory,
  });
}

/// @nodoc
class _$CatalogSummaryEntityCopyWithImpl<
  $Res,
  $Val extends CatalogSummaryEntity
>
    implements $CatalogSummaryEntityCopyWith<$Res> {
  _$CatalogSummaryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? collectedCount = null,
    Object? collectionRate = null,
    Object? collectedByCategory = null,
  }) {
    return _then(
      _value.copyWith(
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            collectedCount: null == collectedCount
                ? _value.collectedCount
                : collectedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            collectionRate: null == collectionRate
                ? _value.collectionRate
                : collectionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            collectedByCategory: null == collectedByCategory
                ? _value.collectedByCategory
                : collectedByCategory // ignore: cast_nullable_to_non_nullable
                      as Map<DogamCategory, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CatalogSummaryEntityImplCopyWith<$Res>
    implements $CatalogSummaryEntityCopyWith<$Res> {
  factory _$$CatalogSummaryEntityImplCopyWith(
    _$CatalogSummaryEntityImpl value,
    $Res Function(_$CatalogSummaryEntityImpl) then,
  ) = __$$CatalogSummaryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalCount,
    int collectedCount,
    double collectionRate,
    Map<DogamCategory, int> collectedByCategory,
  });
}

/// @nodoc
class __$$CatalogSummaryEntityImplCopyWithImpl<$Res>
    extends _$CatalogSummaryEntityCopyWithImpl<$Res, _$CatalogSummaryEntityImpl>
    implements _$$CatalogSummaryEntityImplCopyWith<$Res> {
  __$$CatalogSummaryEntityImplCopyWithImpl(
    _$CatalogSummaryEntityImpl _value,
    $Res Function(_$CatalogSummaryEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? collectedCount = null,
    Object? collectionRate = null,
    Object? collectedByCategory = null,
  }) {
    return _then(
      _$CatalogSummaryEntityImpl(
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        collectedCount: null == collectedCount
            ? _value.collectedCount
            : collectedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        collectionRate: null == collectionRate
            ? _value.collectionRate
            : collectionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        collectedByCategory: null == collectedByCategory
            ? _value._collectedByCategory
            : collectedByCategory // ignore: cast_nullable_to_non_nullable
                  as Map<DogamCategory, int>,
      ),
    );
  }
}

/// @nodoc

class _$CatalogSummaryEntityImpl implements _CatalogSummaryEntity {
  const _$CatalogSummaryEntityImpl({
    required this.totalCount,
    required this.collectedCount,
    required this.collectionRate,
    required final Map<DogamCategory, int> collectedByCategory,
  }) : _collectedByCategory = collectedByCategory;

  @override
  final int totalCount;
  @override
  final int collectedCount;
  @override
  final double collectionRate;
  final Map<DogamCategory, int> _collectedByCategory;
  @override
  Map<DogamCategory, int> get collectedByCategory {
    if (_collectedByCategory is EqualUnmodifiableMapView)
      return _collectedByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_collectedByCategory);
  }

  @override
  String toString() {
    return 'CatalogSummaryEntity(totalCount: $totalCount, collectedCount: $collectedCount, collectionRate: $collectionRate, collectedByCategory: $collectedByCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogSummaryEntityImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.collectedCount, collectedCount) ||
                other.collectedCount == collectedCount) &&
            (identical(other.collectionRate, collectionRate) ||
                other.collectionRate == collectionRate) &&
            const DeepCollectionEquality().equals(
              other._collectedByCategory,
              _collectedByCategory,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCount,
    collectedCount,
    collectionRate,
    const DeepCollectionEquality().hash(_collectedByCategory),
  );

  /// Create a copy of CatalogSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogSummaryEntityImplCopyWith<_$CatalogSummaryEntityImpl>
  get copyWith =>
      __$$CatalogSummaryEntityImplCopyWithImpl<_$CatalogSummaryEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _CatalogSummaryEntity implements CatalogSummaryEntity {
  const factory _CatalogSummaryEntity({
    required final int totalCount,
    required final int collectedCount,
    required final double collectionRate,
    required final Map<DogamCategory, int> collectedByCategory,
  }) = _$CatalogSummaryEntityImpl;

  @override
  int get totalCount;
  @override
  int get collectedCount;
  @override
  double get collectionRate;
  @override
  Map<DogamCategory, int> get collectedByCategory;

  /// Create a copy of CatalogSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogSummaryEntityImplCopyWith<_$CatalogSummaryEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
