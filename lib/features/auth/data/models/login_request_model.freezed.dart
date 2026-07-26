// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginRequestModel _$LoginRequestModelFromJson(Map<String, dynamic> json) {
  return _LoginRequestModel.fromJson(json);
}

/// @nodoc
mixin _$LoginRequestModel {
  /// Firebase ID Token
  String get idToken => throw _privateConstructorUsedError;

  /// 소셜 로그인 제공자 (`GOOGLE`, `APPLE`)
  String get socialType => throw _privateConstructorUsedError;

  /// 디바이스 타입 (`IOS`, `ANDROID`)
  String get deviceType => throw _privateConstructorUsedError;

  /// 고유 디바이스 ID
  String get deviceId => throw _privateConstructorUsedError;

  /// FCM 디바이스 토큰 (선택 — null이면 전송하지 않음)
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Serializes this LoginRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestModelCopyWith<LoginRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestModelCopyWith<$Res> {
  factory $LoginRequestModelCopyWith(
    LoginRequestModel value,
    $Res Function(LoginRequestModel) then,
  ) = _$LoginRequestModelCopyWithImpl<$Res, LoginRequestModel>;
  @useResult
  $Res call({
    String idToken,
    String socialType,
    String deviceType,
    String deviceId,
    String? fcmToken,
  });
}

/// @nodoc
class _$LoginRequestModelCopyWithImpl<$Res, $Val extends LoginRequestModel>
    implements $LoginRequestModelCopyWith<$Res> {
  _$LoginRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idToken = null,
    Object? socialType = null,
    Object? deviceType = null,
    Object? deviceId = null,
    Object? fcmToken = freezed,
  }) {
    return _then(
      _value.copyWith(
            idToken: null == idToken
                ? _value.idToken
                : idToken // ignore: cast_nullable_to_non_nullable
                      as String,
            socialType: null == socialType
                ? _value.socialType
                : socialType // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceType: null == deviceType
                ? _value.deviceType
                : deviceType // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceId: null == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
                      as String,
            fcmToken: freezed == fcmToken
                ? _value.fcmToken
                : fcmToken // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginRequestModelImplCopyWith<$Res>
    implements $LoginRequestModelCopyWith<$Res> {
  factory _$$LoginRequestModelImplCopyWith(
    _$LoginRequestModelImpl value,
    $Res Function(_$LoginRequestModelImpl) then,
  ) = __$$LoginRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String idToken,
    String socialType,
    String deviceType,
    String deviceId,
    String? fcmToken,
  });
}

/// @nodoc
class __$$LoginRequestModelImplCopyWithImpl<$Res>
    extends _$LoginRequestModelCopyWithImpl<$Res, _$LoginRequestModelImpl>
    implements _$$LoginRequestModelImplCopyWith<$Res> {
  __$$LoginRequestModelImplCopyWithImpl(
    _$LoginRequestModelImpl _value,
    $Res Function(_$LoginRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idToken = null,
    Object? socialType = null,
    Object? deviceType = null,
    Object? deviceId = null,
    Object? fcmToken = freezed,
  }) {
    return _then(
      _$LoginRequestModelImpl(
        idToken: null == idToken
            ? _value.idToken
            : idToken // ignore: cast_nullable_to_non_nullable
                  as String,
        socialType: null == socialType
            ? _value.socialType
            : socialType // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceType: null == deviceType
            ? _value.deviceType
            : deviceType // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceId: null == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        fcmToken: freezed == fcmToken
            ? _value.fcmToken
            : fcmToken // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$LoginRequestModelImpl implements _LoginRequestModel {
  const _$LoginRequestModelImpl({
    required this.idToken,
    required this.socialType,
    required this.deviceType,
    required this.deviceId,
    this.fcmToken,
  });

  factory _$LoginRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestModelImplFromJson(json);

  /// Firebase ID Token
  @override
  final String idToken;

  /// 소셜 로그인 제공자 (`GOOGLE`, `APPLE`)
  @override
  final String socialType;

  /// 디바이스 타입 (`IOS`, `ANDROID`)
  @override
  final String deviceType;

  /// 고유 디바이스 ID
  @override
  final String deviceId;

  /// FCM 디바이스 토큰 (선택 — null이면 전송하지 않음)
  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'LoginRequestModel(idToken: $idToken, socialType: $socialType, deviceType: $deviceType, deviceId: $deviceId, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestModelImpl &&
            (identical(other.idToken, idToken) || other.idToken == idToken) &&
            (identical(other.socialType, socialType) ||
                other.socialType == socialType) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    idToken,
    socialType,
    deviceType,
    deviceId,
    fcmToken,
  );

  /// Create a copy of LoginRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestModelImplCopyWith<_$LoginRequestModelImpl> get copyWith =>
      __$$LoginRequestModelImplCopyWithImpl<_$LoginRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestModelImplToJson(this);
  }
}

abstract class _LoginRequestModel implements LoginRequestModel {
  const factory _LoginRequestModel({
    required final String idToken,
    required final String socialType,
    required final String deviceType,
    required final String deviceId,
    final String? fcmToken,
  }) = _$LoginRequestModelImpl;

  factory _LoginRequestModel.fromJson(Map<String, dynamic> json) =
      _$LoginRequestModelImpl.fromJson;

  /// Firebase ID Token
  @override
  String get idToken;

  /// 소셜 로그인 제공자 (`GOOGLE`, `APPLE`)
  @override
  String get socialType;

  /// 디바이스 타입 (`IOS`, `ANDROID`)
  @override
  String get deviceType;

  /// 고유 디바이스 ID
  @override
  String get deviceId;

  /// FCM 디바이스 토큰 (선택 — null이면 전송하지 않음)
  @override
  String? get fcmToken;

  /// Create a copy of LoginRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestModelImplCopyWith<_$LoginRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
