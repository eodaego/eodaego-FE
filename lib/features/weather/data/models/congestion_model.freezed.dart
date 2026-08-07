// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'congestion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CongestionModel _$CongestionModelFromJson(Map<String, dynamic> json) {
  return _CongestionModel.fromJson(json);
}

/// @nodoc
mixin _$CongestionModel {
  /// 혼잡도 등급 원문 (`RELAXED`/`NORMAL`/`SLIGHTLY_CROWDED`/`CROWDED`)
  String? get level => throw _privateConstructorUsedError;

  /// 등급의 한글 표기 — 원본 문자열이라 항상 값이 있다
  String get label => throw _privateConstructorUsedError;

  /// 수집 시각 (KST, 오프셋 없는 ISO)
  String? get collectedAt => throw _privateConstructorUsedError;

  /// Serializes this CongestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CongestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CongestionModelCopyWith<CongestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CongestionModelCopyWith<$Res> {
  factory $CongestionModelCopyWith(
    CongestionModel value,
    $Res Function(CongestionModel) then,
  ) = _$CongestionModelCopyWithImpl<$Res, CongestionModel>;
  @useResult
  $Res call({String? level, String label, String? collectedAt});
}

/// @nodoc
class _$CongestionModelCopyWithImpl<$Res, $Val extends CongestionModel>
    implements $CongestionModelCopyWith<$Res> {
  _$CongestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CongestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = freezed,
    Object? label = null,
    Object? collectedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            level: freezed == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as String?,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$CongestionModelImplCopyWith<$Res>
    implements $CongestionModelCopyWith<$Res> {
  factory _$$CongestionModelImplCopyWith(
    _$CongestionModelImpl value,
    $Res Function(_$CongestionModelImpl) then,
  ) = __$$CongestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? level, String label, String? collectedAt});
}

/// @nodoc
class __$$CongestionModelImplCopyWithImpl<$Res>
    extends _$CongestionModelCopyWithImpl<$Res, _$CongestionModelImpl>
    implements _$$CongestionModelImplCopyWith<$Res> {
  __$$CongestionModelImplCopyWithImpl(
    _$CongestionModelImpl _value,
    $Res Function(_$CongestionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CongestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = freezed,
    Object? label = null,
    Object? collectedAt = freezed,
  }) {
    return _then(
      _$CongestionModelImpl(
        level: freezed == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as String?,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$CongestionModelImpl implements _CongestionModel {
  const _$CongestionModelImpl({this.level, this.label = '', this.collectedAt});

  factory _$CongestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CongestionModelImplFromJson(json);

  /// 혼잡도 등급 원문 (`RELAXED`/`NORMAL`/`SLIGHTLY_CROWDED`/`CROWDED`)
  @override
  final String? level;

  /// 등급의 한글 표기 — 원본 문자열이라 항상 값이 있다
  @override
  @JsonKey()
  final String label;

  /// 수집 시각 (KST, 오프셋 없는 ISO)
  @override
  final String? collectedAt;

  @override
  String toString() {
    return 'CongestionModel(level: $level, label: $label, collectedAt: $collectedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CongestionModelImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.collectedAt, collectedAt) ||
                other.collectedAt == collectedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, label, collectedAt);

  /// Create a copy of CongestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CongestionModelImplCopyWith<_$CongestionModelImpl> get copyWith =>
      __$$CongestionModelImplCopyWithImpl<_$CongestionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CongestionModelImplToJson(this);
  }
}

abstract class _CongestionModel implements CongestionModel {
  const factory _CongestionModel({
    final String? level,
    final String label,
    final String? collectedAt,
  }) = _$CongestionModelImpl;

  factory _CongestionModel.fromJson(Map<String, dynamic> json) =
      _$CongestionModelImpl.fromJson;

  /// 혼잡도 등급 원문 (`RELAXED`/`NORMAL`/`SLIGHTLY_CROWDED`/`CROWDED`)
  @override
  String? get level;

  /// 등급의 한글 표기 — 원본 문자열이라 항상 값이 있다
  @override
  String get label;

  /// 수집 시각 (KST, 오프셋 없는 ISO)
  @override
  String? get collectedAt;

  /// Create a copy of CongestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CongestionModelImplCopyWith<_$CongestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
