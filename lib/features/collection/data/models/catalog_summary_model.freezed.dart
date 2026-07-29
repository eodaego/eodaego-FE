// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CatalogCategorySummaryModel _$CatalogCategorySummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _CatalogCategorySummaryModel.fromJson(json);
}

/// @nodoc
mixin _$CatalogCategorySummaryModel {
  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  String get category => throw _privateConstructorUsedError;

  /// 해당 카테고리 전체 항목 수
  int get totalCount => throw _privateConstructorUsedError;

  /// 해당 카테고리 수집 항목 수
  int get collectedCount => throw _privateConstructorUsedError;

  /// 수집률 백분율 — 서버가 반올림해 내려준다
  double get collectionRate => throw _privateConstructorUsedError;

  /// Serializes this CatalogCategorySummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogCategorySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogCategorySummaryModelCopyWith<CatalogCategorySummaryModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogCategorySummaryModelCopyWith<$Res> {
  factory $CatalogCategorySummaryModelCopyWith(
    CatalogCategorySummaryModel value,
    $Res Function(CatalogCategorySummaryModel) then,
  ) =
      _$CatalogCategorySummaryModelCopyWithImpl<
        $Res,
        CatalogCategorySummaryModel
      >;
  @useResult
  $Res call({
    String category,
    int totalCount,
    int collectedCount,
    double collectionRate,
  });
}

/// @nodoc
class _$CatalogCategorySummaryModelCopyWithImpl<
  $Res,
  $Val extends CatalogCategorySummaryModel
>
    implements $CatalogCategorySummaryModelCopyWith<$Res> {
  _$CatalogCategorySummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogCategorySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? totalCount = null,
    Object? collectedCount = null,
    Object? collectionRate = null,
  }) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CatalogCategorySummaryModelImplCopyWith<$Res>
    implements $CatalogCategorySummaryModelCopyWith<$Res> {
  factory _$$CatalogCategorySummaryModelImplCopyWith(
    _$CatalogCategorySummaryModelImpl value,
    $Res Function(_$CatalogCategorySummaryModelImpl) then,
  ) = __$$CatalogCategorySummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String category,
    int totalCount,
    int collectedCount,
    double collectionRate,
  });
}

/// @nodoc
class __$$CatalogCategorySummaryModelImplCopyWithImpl<$Res>
    extends
        _$CatalogCategorySummaryModelCopyWithImpl<
          $Res,
          _$CatalogCategorySummaryModelImpl
        >
    implements _$$CatalogCategorySummaryModelImplCopyWith<$Res> {
  __$$CatalogCategorySummaryModelImplCopyWithImpl(
    _$CatalogCategorySummaryModelImpl _value,
    $Res Function(_$CatalogCategorySummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogCategorySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? totalCount = null,
    Object? collectedCount = null,
    Object? collectionRate = null,
  }) {
    return _then(
      _$CatalogCategorySummaryModelImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogCategorySummaryModelImpl
    implements _CatalogCategorySummaryModel {
  const _$CatalogCategorySummaryModelImpl({
    required this.category,
    this.totalCount = 0,
    this.collectedCount = 0,
    this.collectionRate = 0,
  });

  factory _$CatalogCategorySummaryModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CatalogCategorySummaryModelImplFromJson(json);

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  @override
  final String category;

  /// 해당 카테고리 전체 항목 수
  @override
  @JsonKey()
  final int totalCount;

  /// 해당 카테고리 수집 항목 수
  @override
  @JsonKey()
  final int collectedCount;

  /// 수집률 백분율 — 서버가 반올림해 내려준다
  @override
  @JsonKey()
  final double collectionRate;

  @override
  String toString() {
    return 'CatalogCategorySummaryModel(category: $category, totalCount: $totalCount, collectedCount: $collectedCount, collectionRate: $collectionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogCategorySummaryModelImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.collectedCount, collectedCount) ||
                other.collectedCount == collectedCount) &&
            (identical(other.collectionRate, collectionRate) ||
                other.collectionRate == collectionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    category,
    totalCount,
    collectedCount,
    collectionRate,
  );

  /// Create a copy of CatalogCategorySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogCategorySummaryModelImplCopyWith<_$CatalogCategorySummaryModelImpl>
  get copyWith =>
      __$$CatalogCategorySummaryModelImplCopyWithImpl<
        _$CatalogCategorySummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogCategorySummaryModelImplToJson(this);
  }
}

abstract class _CatalogCategorySummaryModel
    implements CatalogCategorySummaryModel {
  const factory _CatalogCategorySummaryModel({
    required final String category,
    final int totalCount,
    final int collectedCount,
    final double collectionRate,
  }) = _$CatalogCategorySummaryModelImpl;

  factory _CatalogCategorySummaryModel.fromJson(Map<String, dynamic> json) =
      _$CatalogCategorySummaryModelImpl.fromJson;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  @override
  String get category;

  /// 해당 카테고리 전체 항목 수
  @override
  int get totalCount;

  /// 해당 카테고리 수집 항목 수
  @override
  int get collectedCount;

  /// 수집률 백분율 — 서버가 반올림해 내려준다
  @override
  double get collectionRate;

  /// Create a copy of CatalogCategorySummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogCategorySummaryModelImplCopyWith<_$CatalogCategorySummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CatalogSummaryModel _$CatalogSummaryModelFromJson(Map<String, dynamic> json) {
  return _CatalogSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$CatalogSummaryModel {
  /// 전체 항목 수
  int get totalCount => throw _privateConstructorUsedError;

  /// 전체 수집 항목 수
  int get collectedCount => throw _privateConstructorUsedError;

  /// 전체 수집률 백분율
  double get collectionRate => throw _privateConstructorUsedError;

  /// 카테고리별 현황
  List<CatalogCategorySummaryModel> get byCategory =>
      throw _privateConstructorUsedError;

  /// Serializes this CatalogSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogSummaryModelCopyWith<CatalogSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogSummaryModelCopyWith<$Res> {
  factory $CatalogSummaryModelCopyWith(
    CatalogSummaryModel value,
    $Res Function(CatalogSummaryModel) then,
  ) = _$CatalogSummaryModelCopyWithImpl<$Res, CatalogSummaryModel>;
  @useResult
  $Res call({
    int totalCount,
    int collectedCount,
    double collectionRate,
    List<CatalogCategorySummaryModel> byCategory,
  });
}

/// @nodoc
class _$CatalogSummaryModelCopyWithImpl<$Res, $Val extends CatalogSummaryModel>
    implements $CatalogSummaryModelCopyWith<$Res> {
  _$CatalogSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? collectedCount = null,
    Object? collectionRate = null,
    Object? byCategory = null,
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
            byCategory: null == byCategory
                ? _value.byCategory
                : byCategory // ignore: cast_nullable_to_non_nullable
                      as List<CatalogCategorySummaryModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CatalogSummaryModelImplCopyWith<$Res>
    implements $CatalogSummaryModelCopyWith<$Res> {
  factory _$$CatalogSummaryModelImplCopyWith(
    _$CatalogSummaryModelImpl value,
    $Res Function(_$CatalogSummaryModelImpl) then,
  ) = __$$CatalogSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalCount,
    int collectedCount,
    double collectionRate,
    List<CatalogCategorySummaryModel> byCategory,
  });
}

/// @nodoc
class __$$CatalogSummaryModelImplCopyWithImpl<$Res>
    extends _$CatalogSummaryModelCopyWithImpl<$Res, _$CatalogSummaryModelImpl>
    implements _$$CatalogSummaryModelImplCopyWith<$Res> {
  __$$CatalogSummaryModelImplCopyWithImpl(
    _$CatalogSummaryModelImpl _value,
    $Res Function(_$CatalogSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? collectedCount = null,
    Object? collectionRate = null,
    Object? byCategory = null,
  }) {
    return _then(
      _$CatalogSummaryModelImpl(
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
        byCategory: null == byCategory
            ? _value._byCategory
            : byCategory // ignore: cast_nullable_to_non_nullable
                  as List<CatalogCategorySummaryModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogSummaryModelImpl implements _CatalogSummaryModel {
  const _$CatalogSummaryModelImpl({
    this.totalCount = 0,
    this.collectedCount = 0,
    this.collectionRate = 0,
    final List<CatalogCategorySummaryModel> byCategory =
        const <CatalogCategorySummaryModel>[],
  }) : _byCategory = byCategory;

  factory _$CatalogSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogSummaryModelImplFromJson(json);

  /// 전체 항목 수
  @override
  @JsonKey()
  final int totalCount;

  /// 전체 수집 항목 수
  @override
  @JsonKey()
  final int collectedCount;

  /// 전체 수집률 백분율
  @override
  @JsonKey()
  final double collectionRate;

  /// 카테고리별 현황
  final List<CatalogCategorySummaryModel> _byCategory;

  /// 카테고리별 현황
  @override
  @JsonKey()
  List<CatalogCategorySummaryModel> get byCategory {
    if (_byCategory is EqualUnmodifiableListView) return _byCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byCategory);
  }

  @override
  String toString() {
    return 'CatalogSummaryModel(totalCount: $totalCount, collectedCount: $collectedCount, collectionRate: $collectionRate, byCategory: $byCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogSummaryModelImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.collectedCount, collectedCount) ||
                other.collectedCount == collectedCount) &&
            (identical(other.collectionRate, collectionRate) ||
                other.collectionRate == collectionRate) &&
            const DeepCollectionEquality().equals(
              other._byCategory,
              _byCategory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCount,
    collectedCount,
    collectionRate,
    const DeepCollectionEquality().hash(_byCategory),
  );

  /// Create a copy of CatalogSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogSummaryModelImplCopyWith<_$CatalogSummaryModelImpl> get copyWith =>
      __$$CatalogSummaryModelImplCopyWithImpl<_$CatalogSummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogSummaryModelImplToJson(this);
  }
}

abstract class _CatalogSummaryModel implements CatalogSummaryModel {
  const factory _CatalogSummaryModel({
    final int totalCount,
    final int collectedCount,
    final double collectionRate,
    final List<CatalogCategorySummaryModel> byCategory,
  }) = _$CatalogSummaryModelImpl;

  factory _CatalogSummaryModel.fromJson(Map<String, dynamic> json) =
      _$CatalogSummaryModelImpl.fromJson;

  /// 전체 항목 수
  @override
  int get totalCount;

  /// 전체 수집 항목 수
  @override
  int get collectedCount;

  /// 전체 수집률 백분율
  @override
  double get collectionRate;

  /// 카테고리별 현황
  @override
  List<CatalogCategorySummaryModel> get byCategory;

  /// Create a copy of CatalogSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogSummaryModelImplCopyWith<_$CatalogSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
