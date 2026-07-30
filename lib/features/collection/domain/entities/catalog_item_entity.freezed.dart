// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CatalogItemEntity {
  String get id => throw _privateConstructorUsedError;
  DogamCategory get category => throw _privateConstructorUsedError;
  bool get collected => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
  String? get code => throw _privateConstructorUsedError;

  /// Create a copy of CatalogItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogItemEntityCopyWith<CatalogItemEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogItemEntityCopyWith<$Res> {
  factory $CatalogItemEntityCopyWith(
    CatalogItemEntity value,
    $Res Function(CatalogItemEntity) then,
  ) = _$CatalogItemEntityCopyWithImpl<$Res, CatalogItemEntity>;
  @useResult
  $Res call({
    String id,
    DogamCategory category,
    bool collected,
    String? name,
    String? imageUrl,
    String? code,
  });
}

/// @nodoc
class _$CatalogItemEntityCopyWithImpl<$Res, $Val extends CatalogItemEntity>
    implements $CatalogItemEntityCopyWith<$Res> {
  _$CatalogItemEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? collected = null,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? code = freezed,
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
                      as DogamCategory,
            collected: null == collected
                ? _value.collected
                : collected // ignore: cast_nullable_to_non_nullable
                      as bool,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CatalogItemEntityImplCopyWith<$Res>
    implements $CatalogItemEntityCopyWith<$Res> {
  factory _$$CatalogItemEntityImplCopyWith(
    _$CatalogItemEntityImpl value,
    $Res Function(_$CatalogItemEntityImpl) then,
  ) = __$$CatalogItemEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DogamCategory category,
    bool collected,
    String? name,
    String? imageUrl,
    String? code,
  });
}

/// @nodoc
class __$$CatalogItemEntityImplCopyWithImpl<$Res>
    extends _$CatalogItemEntityCopyWithImpl<$Res, _$CatalogItemEntityImpl>
    implements _$$CatalogItemEntityImplCopyWith<$Res> {
  __$$CatalogItemEntityImplCopyWithImpl(
    _$CatalogItemEntityImpl _value,
    $Res Function(_$CatalogItemEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? collected = null,
    Object? name = freezed,
    Object? imageUrl = freezed,
    Object? code = freezed,
  }) {
    return _then(
      _$CatalogItemEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as DogamCategory,
        collected: null == collected
            ? _value.collected
            : collected // ignore: cast_nullable_to_non_nullable
                  as bool,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
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

class _$CatalogItemEntityImpl implements _CatalogItemEntity {
  const _$CatalogItemEntityImpl({
    required this.id,
    required this.category,
    required this.collected,
    this.name,
    this.imageUrl,
    this.code,
  });

  @override
  final String id;
  @override
  final DogamCategory category;
  @override
  final bool collected;
  @override
  final String? name;
  @override
  final String? imageUrl;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
  @override
  final String? code;

  @override
  String toString() {
    return 'CatalogItemEntity(id: $id, category: $category, collected: $collected, name: $name, imageUrl: $imageUrl, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogItemEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.collected, collected) ||
                other.collected == collected) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, category, collected, name, imageUrl, code);

  /// Create a copy of CatalogItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogItemEntityImplCopyWith<_$CatalogItemEntityImpl> get copyWith =>
      __$$CatalogItemEntityImplCopyWithImpl<_$CatalogItemEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _CatalogItemEntity implements CatalogItemEntity {
  const factory _CatalogItemEntity({
    required final String id,
    required final DogamCategory category,
    required final bool collected,
    final String? name,
    final String? imageUrl,
    final String? code,
  }) = _$CatalogItemEntityImpl;

  @override
  String get id;
  @override
  DogamCategory get category;
  @override
  bool get collected;
  @override
  String? get name;
  @override
  String? get imageUrl;

  /// 에셋 코드 — 일러스트 파일명(`A001.png`)으로 쓰인다. 없으면 카테고리 아이콘으로 대체
  @override
  String? get code;

  /// Create a copy of CatalogItemEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogItemEntityImplCopyWith<_$CatalogItemEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
