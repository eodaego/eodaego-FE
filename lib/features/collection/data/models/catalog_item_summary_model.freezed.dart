// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_item_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CatalogItemSummaryModel _$CatalogItemSummaryModelFromJson(
  Map<String, dynamic> json,
) {
  return _CatalogItemSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$CatalogItemSummaryModel {
  /// 도감 항목 ID
  String get id => throw _privateConstructorUsedError;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  String get category => throw _privateConstructorUsedError;

  /// 이름 — 미수집이면 null
  String? get name => throw _privateConstructorUsedError;

  /// 이미지 URL — 미수집이면 null
  String? get imageUrl => throw _privateConstructorUsedError;

  /// 현재 회원의 수집 여부
  bool get collected => throw _privateConstructorUsedError;

  /// Serializes this CatalogItemSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogItemSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogItemSummaryModelCopyWith<CatalogItemSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogItemSummaryModelCopyWith<$Res> {
  factory $CatalogItemSummaryModelCopyWith(
    CatalogItemSummaryModel value,
    $Res Function(CatalogItemSummaryModel) then,
  ) = _$CatalogItemSummaryModelCopyWithImpl<$Res, CatalogItemSummaryModel>;
  @useResult
  $Res call({
    String id,
    String category,
    String? name,
    String? imageUrl,
    bool collected,
  });
}

/// @nodoc
class _$CatalogItemSummaryModelCopyWithImpl<
  $Res,
  $Val extends CatalogItemSummaryModel
>
    implements $CatalogItemSummaryModelCopyWith<$Res> {
  _$CatalogItemSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogItemSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? collected = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            collected: null == collected
                ? _value.collected
                : collected // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CatalogItemSummaryModelImplCopyWith<$Res>
    implements $CatalogItemSummaryModelCopyWith<$Res> {
  factory _$$CatalogItemSummaryModelImplCopyWith(
    _$CatalogItemSummaryModelImpl value,
    $Res Function(_$CatalogItemSummaryModelImpl) then,
  ) = __$$CatalogItemSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String category,
    String? name,
    String? imageUrl,
    bool collected,
  });
}

/// @nodoc
class __$$CatalogItemSummaryModelImplCopyWithImpl<$Res>
    extends
        _$CatalogItemSummaryModelCopyWithImpl<
          $Res,
          _$CatalogItemSummaryModelImpl
        >
    implements _$$CatalogItemSummaryModelImplCopyWith<$Res> {
  __$$CatalogItemSummaryModelImplCopyWithImpl(
    _$CatalogItemSummaryModelImpl _value,
    $Res Function(_$CatalogItemSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogItemSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? collected = null,
  }) {
    return _then(
      _$CatalogItemSummaryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        collected: null == collected
            ? _value.collected
            : collected // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogItemSummaryModelImpl implements _CatalogItemSummaryModel {
  const _$CatalogItemSummaryModelImpl({
    required this.id,
    required this.category,
    this.name,
    this.imageUrl,
    this.collected = false,
  });

  factory _$CatalogItemSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogItemSummaryModelImplFromJson(json);

  /// 도감 항목 ID
  @override
  final String id;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  @override
  final String category;

  /// 이름 — 미수집이면 null
  @override
  final String? name;

  /// 이미지 URL — 미수집이면 null
  @override
  final String? imageUrl;

  /// 현재 회원의 수집 여부
  @override
  @JsonKey()
  final bool collected;

  @override
  String toString() {
    return 'CatalogItemSummaryModel(id: $id, category: $category, name: $name, imageUrl: $imageUrl, collected: $collected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogItemSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.collected, collected) ||
                other.collected == collected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, category, name, imageUrl, collected);

  /// Create a copy of CatalogItemSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogItemSummaryModelImplCopyWith<_$CatalogItemSummaryModelImpl>
  get copyWith =>
      __$$CatalogItemSummaryModelImplCopyWithImpl<
        _$CatalogItemSummaryModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogItemSummaryModelImplToJson(this);
  }
}

abstract class _CatalogItemSummaryModel implements CatalogItemSummaryModel {
  const factory _CatalogItemSummaryModel({
    required final String id,
    required final String category,
    final String? name,
    final String? imageUrl,
    final bool collected,
  }) = _$CatalogItemSummaryModelImpl;

  factory _CatalogItemSummaryModel.fromJson(Map<String, dynamic> json) =
      _$CatalogItemSummaryModelImpl.fromJson;

  /// 도감 항목 ID
  @override
  String get id;

  /// 카테고리 원문 (`ANIMAL`/`PLANT`/`PLACE`)
  @override
  String get category;

  /// 이름 — 미수집이면 null
  @override
  String? get name;

  /// 이미지 URL — 미수집이면 null
  @override
  String? get imageUrl;

  /// 현재 회원의 수집 여부
  @override
  bool get collected;

  /// Create a copy of CatalogItemSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogItemSummaryModelImplCopyWith<_$CatalogItemSummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
