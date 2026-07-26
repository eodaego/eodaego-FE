// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agreement_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AgreementRequestModel _$AgreementRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _AgreementRequestModel.fromJson(json);
}

/// @nodoc
mixin _$AgreementRequestModel {
  /// 이용약관 동의 여부 (필수, true여야 함)
  bool get termsOfServiceAgreed => throw _privateConstructorUsedError;

  /// 개인정보처리방침 동의 여부 (필수, true여야 함)
  bool get privacyPolicyAgreed => throw _privateConstructorUsedError;

  /// 위치정보 수집 동의 여부 (필수, true여야 함)
  bool get locationInfoAgreed => throw _privateConstructorUsedError;

  /// 마케팅 정보 수신 동의 여부 (선택)
  bool get marketingAgreed => throw _privateConstructorUsedError;

  /// Serializes this AgreementRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AgreementRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgreementRequestModelCopyWith<AgreementRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgreementRequestModelCopyWith<$Res> {
  factory $AgreementRequestModelCopyWith(
    AgreementRequestModel value,
    $Res Function(AgreementRequestModel) then,
  ) = _$AgreementRequestModelCopyWithImpl<$Res, AgreementRequestModel>;
  @useResult
  $Res call({
    bool termsOfServiceAgreed,
    bool privacyPolicyAgreed,
    bool locationInfoAgreed,
    bool marketingAgreed,
  });
}

/// @nodoc
class _$AgreementRequestModelCopyWithImpl<
  $Res,
  $Val extends AgreementRequestModel
>
    implements $AgreementRequestModelCopyWith<$Res> {
  _$AgreementRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgreementRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termsOfServiceAgreed = null,
    Object? privacyPolicyAgreed = null,
    Object? locationInfoAgreed = null,
    Object? marketingAgreed = null,
  }) {
    return _then(
      _value.copyWith(
            termsOfServiceAgreed: null == termsOfServiceAgreed
                ? _value.termsOfServiceAgreed
                : termsOfServiceAgreed // ignore: cast_nullable_to_non_nullable
                      as bool,
            privacyPolicyAgreed: null == privacyPolicyAgreed
                ? _value.privacyPolicyAgreed
                : privacyPolicyAgreed // ignore: cast_nullable_to_non_nullable
                      as bool,
            locationInfoAgreed: null == locationInfoAgreed
                ? _value.locationInfoAgreed
                : locationInfoAgreed // ignore: cast_nullable_to_non_nullable
                      as bool,
            marketingAgreed: null == marketingAgreed
                ? _value.marketingAgreed
                : marketingAgreed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AgreementRequestModelImplCopyWith<$Res>
    implements $AgreementRequestModelCopyWith<$Res> {
  factory _$$AgreementRequestModelImplCopyWith(
    _$AgreementRequestModelImpl value,
    $Res Function(_$AgreementRequestModelImpl) then,
  ) = __$$AgreementRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool termsOfServiceAgreed,
    bool privacyPolicyAgreed,
    bool locationInfoAgreed,
    bool marketingAgreed,
  });
}

/// @nodoc
class __$$AgreementRequestModelImplCopyWithImpl<$Res>
    extends
        _$AgreementRequestModelCopyWithImpl<$Res, _$AgreementRequestModelImpl>
    implements _$$AgreementRequestModelImplCopyWith<$Res> {
  __$$AgreementRequestModelImplCopyWithImpl(
    _$AgreementRequestModelImpl _value,
    $Res Function(_$AgreementRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AgreementRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termsOfServiceAgreed = null,
    Object? privacyPolicyAgreed = null,
    Object? locationInfoAgreed = null,
    Object? marketingAgreed = null,
  }) {
    return _then(
      _$AgreementRequestModelImpl(
        termsOfServiceAgreed: null == termsOfServiceAgreed
            ? _value.termsOfServiceAgreed
            : termsOfServiceAgreed // ignore: cast_nullable_to_non_nullable
                  as bool,
        privacyPolicyAgreed: null == privacyPolicyAgreed
            ? _value.privacyPolicyAgreed
            : privacyPolicyAgreed // ignore: cast_nullable_to_non_nullable
                  as bool,
        locationInfoAgreed: null == locationInfoAgreed
            ? _value.locationInfoAgreed
            : locationInfoAgreed // ignore: cast_nullable_to_non_nullable
                  as bool,
        marketingAgreed: null == marketingAgreed
            ? _value.marketingAgreed
            : marketingAgreed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AgreementRequestModelImpl implements _AgreementRequestModel {
  const _$AgreementRequestModelImpl({
    required this.termsOfServiceAgreed,
    required this.privacyPolicyAgreed,
    required this.locationInfoAgreed,
    required this.marketingAgreed,
  });

  factory _$AgreementRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgreementRequestModelImplFromJson(json);

  /// 이용약관 동의 여부 (필수, true여야 함)
  @override
  final bool termsOfServiceAgreed;

  /// 개인정보처리방침 동의 여부 (필수, true여야 함)
  @override
  final bool privacyPolicyAgreed;

  /// 위치정보 수집 동의 여부 (필수, true여야 함)
  @override
  final bool locationInfoAgreed;

  /// 마케팅 정보 수신 동의 여부 (선택)
  @override
  final bool marketingAgreed;

  @override
  String toString() {
    return 'AgreementRequestModel(termsOfServiceAgreed: $termsOfServiceAgreed, privacyPolicyAgreed: $privacyPolicyAgreed, locationInfoAgreed: $locationInfoAgreed, marketingAgreed: $marketingAgreed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgreementRequestModelImpl &&
            (identical(other.termsOfServiceAgreed, termsOfServiceAgreed) ||
                other.termsOfServiceAgreed == termsOfServiceAgreed) &&
            (identical(other.privacyPolicyAgreed, privacyPolicyAgreed) ||
                other.privacyPolicyAgreed == privacyPolicyAgreed) &&
            (identical(other.locationInfoAgreed, locationInfoAgreed) ||
                other.locationInfoAgreed == locationInfoAgreed) &&
            (identical(other.marketingAgreed, marketingAgreed) ||
                other.marketingAgreed == marketingAgreed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    termsOfServiceAgreed,
    privacyPolicyAgreed,
    locationInfoAgreed,
    marketingAgreed,
  );

  /// Create a copy of AgreementRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgreementRequestModelImplCopyWith<_$AgreementRequestModelImpl>
  get copyWith =>
      __$$AgreementRequestModelImplCopyWithImpl<_$AgreementRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AgreementRequestModelImplToJson(this);
  }
}

abstract class _AgreementRequestModel implements AgreementRequestModel {
  const factory _AgreementRequestModel({
    required final bool termsOfServiceAgreed,
    required final bool privacyPolicyAgreed,
    required final bool locationInfoAgreed,
    required final bool marketingAgreed,
  }) = _$AgreementRequestModelImpl;

  factory _AgreementRequestModel.fromJson(Map<String, dynamic> json) =
      _$AgreementRequestModelImpl.fromJson;

  /// 이용약관 동의 여부 (필수, true여야 함)
  @override
  bool get termsOfServiceAgreed;

  /// 개인정보처리방침 동의 여부 (필수, true여야 함)
  @override
  bool get privacyPolicyAgreed;

  /// 위치정보 수집 동의 여부 (필수, true여야 함)
  @override
  bool get locationInfoAgreed;

  /// 마케팅 정보 수신 동의 여부 (선택)
  @override
  bool get marketingAgreed;

  /// Create a copy of AgreementRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgreementRequestModelImplCopyWith<_$AgreementRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
