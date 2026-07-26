// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nickname_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NicknameResponseModel _$NicknameResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _NicknameResponseModel.fromJson(json);
}

/// @nodoc
mixin _$NicknameResponseModel {
  /// 변경된 닉네임
  String get nickname => throw _privateConstructorUsedError;

  /// Serializes this NicknameResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NicknameResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NicknameResponseModelCopyWith<NicknameResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NicknameResponseModelCopyWith<$Res> {
  factory $NicknameResponseModelCopyWith(
    NicknameResponseModel value,
    $Res Function(NicknameResponseModel) then,
  ) = _$NicknameResponseModelCopyWithImpl<$Res, NicknameResponseModel>;
  @useResult
  $Res call({String nickname});
}

/// @nodoc
class _$NicknameResponseModelCopyWithImpl<
  $Res,
  $Val extends NicknameResponseModel
>
    implements $NicknameResponseModelCopyWith<$Res> {
  _$NicknameResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NicknameResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nickname = null}) {
    return _then(
      _value.copyWith(
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NicknameResponseModelImplCopyWith<$Res>
    implements $NicknameResponseModelCopyWith<$Res> {
  factory _$$NicknameResponseModelImplCopyWith(
    _$NicknameResponseModelImpl value,
    $Res Function(_$NicknameResponseModelImpl) then,
  ) = __$$NicknameResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nickname});
}

/// @nodoc
class __$$NicknameResponseModelImplCopyWithImpl<$Res>
    extends
        _$NicknameResponseModelCopyWithImpl<$Res, _$NicknameResponseModelImpl>
    implements _$$NicknameResponseModelImplCopyWith<$Res> {
  __$$NicknameResponseModelImplCopyWithImpl(
    _$NicknameResponseModelImpl _value,
    $Res Function(_$NicknameResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NicknameResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nickname = null}) {
    return _then(
      _$NicknameResponseModelImpl(
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NicknameResponseModelImpl implements _NicknameResponseModel {
  const _$NicknameResponseModelImpl({this.nickname = ''});

  factory _$NicknameResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NicknameResponseModelImplFromJson(json);

  /// 변경된 닉네임
  @override
  @JsonKey()
  final String nickname;

  @override
  String toString() {
    return 'NicknameResponseModel(nickname: $nickname)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NicknameResponseModelImpl &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickname);

  /// Create a copy of NicknameResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NicknameResponseModelImplCopyWith<_$NicknameResponseModelImpl>
  get copyWith =>
      __$$NicknameResponseModelImplCopyWithImpl<_$NicknameResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NicknameResponseModelImplToJson(this);
  }
}

abstract class _NicknameResponseModel implements NicknameResponseModel {
  const factory _NicknameResponseModel({final String nickname}) =
      _$NicknameResponseModelImpl;

  factory _NicknameResponseModel.fromJson(Map<String, dynamic> json) =
      _$NicknameResponseModelImpl.fromJson;

  /// 변경된 닉네임
  @override
  String get nickname;

  /// Create a copy of NicknameResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NicknameResponseModelImplCopyWith<_$NicknameResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
