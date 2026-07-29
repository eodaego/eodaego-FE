// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_list_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CatalogListResponseModel _$CatalogListResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _CatalogListResponseModel.fromJson(json);
}

/// @nodoc
mixin _$CatalogListResponseModel {
  /// 전체 항목 수
  int get totalCount => throw _privateConstructorUsedError;

  /// 현재 회원의 수집 항목 수
  int get collectedCount => throw _privateConstructorUsedError;

  /// 도감 항목 목록
  List<CatalogItemSummaryModel> get items => throw _privateConstructorUsedError;

  /// Serializes this CatalogListResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogListResponseModelCopyWith<CatalogListResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogListResponseModelCopyWith<$Res> {
  factory $CatalogListResponseModelCopyWith(
    CatalogListResponseModel value,
    $Res Function(CatalogListResponseModel) then,
  ) = _$CatalogListResponseModelCopyWithImpl<$Res, CatalogListResponseModel>;
  @useResult
  $Res call({
    int totalCount,
    int collectedCount,
    List<CatalogItemSummaryModel> items,
  });
}

/// @nodoc
class _$CatalogListResponseModelCopyWithImpl<
  $Res,
  $Val extends CatalogListResponseModel
>
    implements $CatalogListResponseModelCopyWith<$Res> {
  _$CatalogListResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? collectedCount = null,
    Object? items = null,
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
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CatalogItemSummaryModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CatalogListResponseModelImplCopyWith<$Res>
    implements $CatalogListResponseModelCopyWith<$Res> {
  factory _$$CatalogListResponseModelImplCopyWith(
    _$CatalogListResponseModelImpl value,
    $Res Function(_$CatalogListResponseModelImpl) then,
  ) = __$$CatalogListResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalCount,
    int collectedCount,
    List<CatalogItemSummaryModel> items,
  });
}

/// @nodoc
class __$$CatalogListResponseModelImplCopyWithImpl<$Res>
    extends
        _$CatalogListResponseModelCopyWithImpl<
          $Res,
          _$CatalogListResponseModelImpl
        >
    implements _$$CatalogListResponseModelImplCopyWith<$Res> {
  __$$CatalogListResponseModelImplCopyWithImpl(
    _$CatalogListResponseModelImpl _value,
    $Res Function(_$CatalogListResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? collectedCount = null,
    Object? items = null,
  }) {
    return _then(
      _$CatalogListResponseModelImpl(
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        collectedCount: null == collectedCount
            ? _value.collectedCount
            : collectedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CatalogItemSummaryModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogListResponseModelImpl implements _CatalogListResponseModel {
  const _$CatalogListResponseModelImpl({
    this.totalCount = 0,
    this.collectedCount = 0,
    final List<CatalogItemSummaryModel> items =
        const <CatalogItemSummaryModel>[],
  }) : _items = items;

  factory _$CatalogListResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogListResponseModelImplFromJson(json);

  /// 전체 항목 수
  @override
  @JsonKey()
  final int totalCount;

  /// 현재 회원의 수집 항목 수
  @override
  @JsonKey()
  final int collectedCount;

  /// 도감 항목 목록
  final List<CatalogItemSummaryModel> _items;

  /// 도감 항목 목록
  @override
  @JsonKey()
  List<CatalogItemSummaryModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CatalogListResponseModel(totalCount: $totalCount, collectedCount: $collectedCount, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogListResponseModelImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.collectedCount, collectedCount) ||
                other.collectedCount == collectedCount) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCount,
    collectedCount,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of CatalogListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogListResponseModelImplCopyWith<_$CatalogListResponseModelImpl>
  get copyWith =>
      __$$CatalogListResponseModelImplCopyWithImpl<
        _$CatalogListResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogListResponseModelImplToJson(this);
  }
}

abstract class _CatalogListResponseModel implements CatalogListResponseModel {
  const factory _CatalogListResponseModel({
    final int totalCount,
    final int collectedCount,
    final List<CatalogItemSummaryModel> items,
  }) = _$CatalogListResponseModelImpl;

  factory _CatalogListResponseModel.fromJson(Map<String, dynamic> json) =
      _$CatalogListResponseModelImpl.fromJson;

  /// 전체 항목 수
  @override
  int get totalCount;

  /// 현재 회원의 수집 항목 수
  @override
  int get collectedCount;

  /// 도감 항목 목록
  @override
  List<CatalogItemSummaryModel> get items;

  /// Create a copy of CatalogListResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogListResponseModelImplCopyWith<_$CatalogListResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
