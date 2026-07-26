// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) {
  return _LoginResponseModel.fromJson(json);
}

/// @nodoc
mixin _$LoginResponseModel {
  /// JWT Access Token — 없으면 세션이 성립하지 않으므로 파싱 실패가 맞다
  String get accessToken => throw _privateConstructorUsedError;

  /// JWT Refresh Token
  String get refreshToken => throw _privateConstructorUsedError;

  /// 회원 고유 ID (UUID)
  String get userId => throw _privateConstructorUsedError;

  /// 필수 약관 미동의 여부
  ///
  /// 신규 회원은 항상 true. 기존 회원도 필수 약관 미동의면 매 로그인마다 true.
  /// **누락 시 true(fail-closed)** — 약관 게이트를 열지 않는다.
  bool get requiresAgreement => throw _privateConstructorUsedError;

  /// 이번 요청에서 신규 가입이 함께 처리되었는지 여부
  ///
  /// 누락 시 false — 기존 회원으로 취급해 추가 온보딩을 띄우지 않는다.
  bool get firstLogin => throw _privateConstructorUsedError;

  /// 회원 닉네임 (서버 자동 발급)
  String get nickname => throw _privateConstructorUsedError;

  /// Serializes this LoginResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseModelCopyWith<LoginResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseModelCopyWith<$Res> {
  factory $LoginResponseModelCopyWith(
    LoginResponseModel value,
    $Res Function(LoginResponseModel) then,
  ) = _$LoginResponseModelCopyWithImpl<$Res, LoginResponseModel>;
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    String userId,
    bool requiresAgreement,
    bool firstLogin,
    String nickname,
  });
}

/// @nodoc
class _$LoginResponseModelCopyWithImpl<$Res, $Val extends LoginResponseModel>
    implements $LoginResponseModelCopyWith<$Res> {
  _$LoginResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? userId = null,
    Object? requiresAgreement = null,
    Object? firstLogin = null,
    Object? nickname = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            requiresAgreement: null == requiresAgreement
                ? _value.requiresAgreement
                : requiresAgreement // ignore: cast_nullable_to_non_nullable
                      as bool,
            firstLogin: null == firstLogin
                ? _value.firstLogin
                : firstLogin // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$LoginResponseModelImplCopyWith<$Res>
    implements $LoginResponseModelCopyWith<$Res> {
  factory _$$LoginResponseModelImplCopyWith(
    _$LoginResponseModelImpl value,
    $Res Function(_$LoginResponseModelImpl) then,
  ) = __$$LoginResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    String userId,
    bool requiresAgreement,
    bool firstLogin,
    String nickname,
  });
}

/// @nodoc
class __$$LoginResponseModelImplCopyWithImpl<$Res>
    extends _$LoginResponseModelCopyWithImpl<$Res, _$LoginResponseModelImpl>
    implements _$$LoginResponseModelImplCopyWith<$Res> {
  __$$LoginResponseModelImplCopyWithImpl(
    _$LoginResponseModelImpl _value,
    $Res Function(_$LoginResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? userId = null,
    Object? requiresAgreement = null,
    Object? firstLogin = null,
    Object? nickname = null,
  }) {
    return _then(
      _$LoginResponseModelImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        requiresAgreement: null == requiresAgreement
            ? _value.requiresAgreement
            : requiresAgreement // ignore: cast_nullable_to_non_nullable
                  as bool,
        firstLogin: null == firstLogin
            ? _value.firstLogin
            : firstLogin // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$LoginResponseModelImpl implements _LoginResponseModel {
  const _$LoginResponseModelImpl({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    this.requiresAgreement = true,
    this.firstLogin = false,
    this.nickname = '',
  });

  factory _$LoginResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseModelImplFromJson(json);

  /// JWT Access Token — 없으면 세션이 성립하지 않으므로 파싱 실패가 맞다
  @override
  final String accessToken;

  /// JWT Refresh Token
  @override
  final String refreshToken;

  /// 회원 고유 ID (UUID)
  @override
  final String userId;

  /// 필수 약관 미동의 여부
  ///
  /// 신규 회원은 항상 true. 기존 회원도 필수 약관 미동의면 매 로그인마다 true.
  /// **누락 시 true(fail-closed)** — 약관 게이트를 열지 않는다.
  @override
  @JsonKey()
  final bool requiresAgreement;

  /// 이번 요청에서 신규 가입이 함께 처리되었는지 여부
  ///
  /// 누락 시 false — 기존 회원으로 취급해 추가 온보딩을 띄우지 않는다.
  @override
  @JsonKey()
  final bool firstLogin;

  /// 회원 닉네임 (서버 자동 발급)
  @override
  @JsonKey()
  final String nickname;

  @override
  String toString() {
    return 'LoginResponseModel(accessToken: $accessToken, refreshToken: $refreshToken, userId: $userId, requiresAgreement: $requiresAgreement, firstLogin: $firstLogin, nickname: $nickname)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.requiresAgreement, requiresAgreement) ||
                other.requiresAgreement == requiresAgreement) &&
            (identical(other.firstLogin, firstLogin) ||
                other.firstLogin == firstLogin) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessToken,
    refreshToken,
    userId,
    requiresAgreement,
    firstLogin,
    nickname,
  );

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseModelImplCopyWith<_$LoginResponseModelImpl> get copyWith =>
      __$$LoginResponseModelImplCopyWithImpl<_$LoginResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseModelImplToJson(this);
  }
}

abstract class _LoginResponseModel implements LoginResponseModel {
  const factory _LoginResponseModel({
    required final String accessToken,
    required final String refreshToken,
    required final String userId,
    final bool requiresAgreement,
    final bool firstLogin,
    final String nickname,
  }) = _$LoginResponseModelImpl;

  factory _LoginResponseModel.fromJson(Map<String, dynamic> json) =
      _$LoginResponseModelImpl.fromJson;

  /// JWT Access Token — 없으면 세션이 성립하지 않으므로 파싱 실패가 맞다
  @override
  String get accessToken;

  /// JWT Refresh Token
  @override
  String get refreshToken;

  /// 회원 고유 ID (UUID)
  @override
  String get userId;

  /// 필수 약관 미동의 여부
  ///
  /// 신규 회원은 항상 true. 기존 회원도 필수 약관 미동의면 매 로그인마다 true.
  /// **누락 시 true(fail-closed)** — 약관 게이트를 열지 않는다.
  @override
  bool get requiresAgreement;

  /// 이번 요청에서 신규 가입이 함께 처리되었는지 여부
  ///
  /// 누락 시 false — 기존 회원으로 취급해 추가 온보딩을 띄우지 않는다.
  @override
  bool get firstLogin;

  /// 회원 닉네임 (서버 자동 발급)
  @override
  String get nickname;

  /// Create a copy of LoginResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseModelImplCopyWith<_$LoginResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
