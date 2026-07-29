// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nickname_availability_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NicknameAvailabilityResponseModel _$NicknameAvailabilityResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _NicknameAvailabilityResponseModel.fromJson(json);
}

/// @nodoc
mixin _$NicknameAvailabilityResponseModel {
  /// 사용 가능 여부
  bool get available => throw _privateConstructorUsedError;

  /// Serializes this NicknameAvailabilityResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NicknameAvailabilityResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NicknameAvailabilityResponseModelCopyWith<NicknameAvailabilityResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NicknameAvailabilityResponseModelCopyWith<$Res> {
  factory $NicknameAvailabilityResponseModelCopyWith(
    NicknameAvailabilityResponseModel value,
    $Res Function(NicknameAvailabilityResponseModel) then,
  ) =
      _$NicknameAvailabilityResponseModelCopyWithImpl<
        $Res,
        NicknameAvailabilityResponseModel
      >;
  @useResult
  $Res call({bool available});
}

/// @nodoc
class _$NicknameAvailabilityResponseModelCopyWithImpl<
  $Res,
  $Val extends NicknameAvailabilityResponseModel
>
    implements $NicknameAvailabilityResponseModelCopyWith<$Res> {
  _$NicknameAvailabilityResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NicknameAvailabilityResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? available = null}) {
    return _then(
      _value.copyWith(
            available: null == available
                ? _value.available
                : available // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NicknameAvailabilityResponseModelImplCopyWith<$Res>
    implements $NicknameAvailabilityResponseModelCopyWith<$Res> {
  factory _$$NicknameAvailabilityResponseModelImplCopyWith(
    _$NicknameAvailabilityResponseModelImpl value,
    $Res Function(_$NicknameAvailabilityResponseModelImpl) then,
  ) = __$$NicknameAvailabilityResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool available});
}

/// @nodoc
class __$$NicknameAvailabilityResponseModelImplCopyWithImpl<$Res>
    extends
        _$NicknameAvailabilityResponseModelCopyWithImpl<
          $Res,
          _$NicknameAvailabilityResponseModelImpl
        >
    implements _$$NicknameAvailabilityResponseModelImplCopyWith<$Res> {
  __$$NicknameAvailabilityResponseModelImplCopyWithImpl(
    _$NicknameAvailabilityResponseModelImpl _value,
    $Res Function(_$NicknameAvailabilityResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NicknameAvailabilityResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? available = null}) {
    return _then(
      _$NicknameAvailabilityResponseModelImpl(
        available: null == available
            ? _value.available
            : available // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NicknameAvailabilityResponseModelImpl
    implements _NicknameAvailabilityResponseModel {
  const _$NicknameAvailabilityResponseModelImpl({this.available = false});

  factory _$NicknameAvailabilityResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$NicknameAvailabilityResponseModelImplFromJson(json);

  /// 사용 가능 여부
  @override
  @JsonKey()
  final bool available;

  @override
  String toString() {
    return 'NicknameAvailabilityResponseModel(available: $available)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NicknameAvailabilityResponseModelImpl &&
            (identical(other.available, available) ||
                other.available == available));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, available);

  /// Create a copy of NicknameAvailabilityResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NicknameAvailabilityResponseModelImplCopyWith<
    _$NicknameAvailabilityResponseModelImpl
  >
  get copyWith =>
      __$$NicknameAvailabilityResponseModelImplCopyWithImpl<
        _$NicknameAvailabilityResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NicknameAvailabilityResponseModelImplToJson(this);
  }
}

abstract class _NicknameAvailabilityResponseModel
    implements NicknameAvailabilityResponseModel {
  const factory _NicknameAvailabilityResponseModel({final bool available}) =
      _$NicknameAvailabilityResponseModelImpl;

  factory _NicknameAvailabilityResponseModel.fromJson(
    Map<String, dynamic> json,
  ) = _$NicknameAvailabilityResponseModelImpl.fromJson;

  /// 사용 가능 여부
  @override
  bool get available;

  /// Create a copy of NicknameAvailabilityResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NicknameAvailabilityResponseModelImplCopyWith<
    _$NicknameAvailabilityResponseModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
