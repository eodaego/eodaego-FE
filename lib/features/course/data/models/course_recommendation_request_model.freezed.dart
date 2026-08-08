// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_recommendation_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CourseRecommendationRequestModel _$CourseRecommendationRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _CourseRecommendationRequestModel.fromJson(json);
}

/// @nodoc
mixin _$CourseRecommendationRequestModel {
  /// 입구 원문 — 필수
  String get entrance => throw _privateConstructorUsedError;

  /// 출구 원문 — 필수
  String get exit => throw _privateConstructorUsedError;

  /// 관심 태그 원문 목록. null이면 AI가 전체 태그를 대상으로 추천한다
  List<String>? get interestTypes => throw _privateConstructorUsedError;

  /// 희망 체류시간(분). null이면 AI가 알아서 정한다
  int? get stayDurationMinutes => throw _privateConstructorUsedError;

  /// 동행 유형 원문. null이면 AI가 알아서 정한다
  String? get companionType => throw _privateConstructorUsedError;

  /// Serializes this CourseRecommendationRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseRecommendationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseRecommendationRequestModelCopyWith<CourseRecommendationRequestModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseRecommendationRequestModelCopyWith<$Res> {
  factory $CourseRecommendationRequestModelCopyWith(
    CourseRecommendationRequestModel value,
    $Res Function(CourseRecommendationRequestModel) then,
  ) =
      _$CourseRecommendationRequestModelCopyWithImpl<
        $Res,
        CourseRecommendationRequestModel
      >;
  @useResult
  $Res call({
    String entrance,
    String exit,
    List<String>? interestTypes,
    int? stayDurationMinutes,
    String? companionType,
  });
}

/// @nodoc
class _$CourseRecommendationRequestModelCopyWithImpl<
  $Res,
  $Val extends CourseRecommendationRequestModel
>
    implements $CourseRecommendationRequestModelCopyWith<$Res> {
  _$CourseRecommendationRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseRecommendationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entrance = null,
    Object? exit = null,
    Object? interestTypes = freezed,
    Object? stayDurationMinutes = freezed,
    Object? companionType = freezed,
  }) {
    return _then(
      _value.copyWith(
            entrance: null == entrance
                ? _value.entrance
                : entrance // ignore: cast_nullable_to_non_nullable
                      as String,
            exit: null == exit
                ? _value.exit
                : exit // ignore: cast_nullable_to_non_nullable
                      as String,
            interestTypes: freezed == interestTypes
                ? _value.interestTypes
                : interestTypes // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            stayDurationMinutes: freezed == stayDurationMinutes
                ? _value.stayDurationMinutes
                : stayDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            companionType: freezed == companionType
                ? _value.companionType
                : companionType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseRecommendationRequestModelImplCopyWith<$Res>
    implements $CourseRecommendationRequestModelCopyWith<$Res> {
  factory _$$CourseRecommendationRequestModelImplCopyWith(
    _$CourseRecommendationRequestModelImpl value,
    $Res Function(_$CourseRecommendationRequestModelImpl) then,
  ) = __$$CourseRecommendationRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String entrance,
    String exit,
    List<String>? interestTypes,
    int? stayDurationMinutes,
    String? companionType,
  });
}

/// @nodoc
class __$$CourseRecommendationRequestModelImplCopyWithImpl<$Res>
    extends
        _$CourseRecommendationRequestModelCopyWithImpl<
          $Res,
          _$CourseRecommendationRequestModelImpl
        >
    implements _$$CourseRecommendationRequestModelImplCopyWith<$Res> {
  __$$CourseRecommendationRequestModelImplCopyWithImpl(
    _$CourseRecommendationRequestModelImpl _value,
    $Res Function(_$CourseRecommendationRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseRecommendationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entrance = null,
    Object? exit = null,
    Object? interestTypes = freezed,
    Object? stayDurationMinutes = freezed,
    Object? companionType = freezed,
  }) {
    return _then(
      _$CourseRecommendationRequestModelImpl(
        entrance: null == entrance
            ? _value.entrance
            : entrance // ignore: cast_nullable_to_non_nullable
                  as String,
        exit: null == exit
            ? _value.exit
            : exit // ignore: cast_nullable_to_non_nullable
                  as String,
        interestTypes: freezed == interestTypes
            ? _value._interestTypes
            : interestTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        stayDurationMinutes: freezed == stayDurationMinutes
            ? _value.stayDurationMinutes
            : stayDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        companionType: freezed == companionType
            ? _value.companionType
            : companionType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$CourseRecommendationRequestModelImpl
    implements _CourseRecommendationRequestModel {
  const _$CourseRecommendationRequestModelImpl({
    required this.entrance,
    required this.exit,
    final List<String>? interestTypes,
    this.stayDurationMinutes,
    this.companionType,
  }) : _interestTypes = interestTypes;

  factory _$CourseRecommendationRequestModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CourseRecommendationRequestModelImplFromJson(json);

  /// 입구 원문 — 필수
  @override
  final String entrance;

  /// 출구 원문 — 필수
  @override
  final String exit;

  /// 관심 태그 원문 목록. null이면 AI가 전체 태그를 대상으로 추천한다
  final List<String>? _interestTypes;

  /// 관심 태그 원문 목록. null이면 AI가 전체 태그를 대상으로 추천한다
  @override
  List<String>? get interestTypes {
    final value = _interestTypes;
    if (value == null) return null;
    if (_interestTypes is EqualUnmodifiableListView) return _interestTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 희망 체류시간(분). null이면 AI가 알아서 정한다
  @override
  final int? stayDurationMinutes;

  /// 동행 유형 원문. null이면 AI가 알아서 정한다
  @override
  final String? companionType;

  @override
  String toString() {
    return 'CourseRecommendationRequestModel(entrance: $entrance, exit: $exit, interestTypes: $interestTypes, stayDurationMinutes: $stayDurationMinutes, companionType: $companionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseRecommendationRequestModelImpl &&
            (identical(other.entrance, entrance) ||
                other.entrance == entrance) &&
            (identical(other.exit, exit) || other.exit == exit) &&
            const DeepCollectionEquality().equals(
              other._interestTypes,
              _interestTypes,
            ) &&
            (identical(other.stayDurationMinutes, stayDurationMinutes) ||
                other.stayDurationMinutes == stayDurationMinutes) &&
            (identical(other.companionType, companionType) ||
                other.companionType == companionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    entrance,
    exit,
    const DeepCollectionEquality().hash(_interestTypes),
    stayDurationMinutes,
    companionType,
  );

  /// Create a copy of CourseRecommendationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseRecommendationRequestModelImplCopyWith<
    _$CourseRecommendationRequestModelImpl
  >
  get copyWith =>
      __$$CourseRecommendationRequestModelImplCopyWithImpl<
        _$CourseRecommendationRequestModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseRecommendationRequestModelImplToJson(this);
  }
}

abstract class _CourseRecommendationRequestModel
    implements CourseRecommendationRequestModel {
  const factory _CourseRecommendationRequestModel({
    required final String entrance,
    required final String exit,
    final List<String>? interestTypes,
    final int? stayDurationMinutes,
    final String? companionType,
  }) = _$CourseRecommendationRequestModelImpl;

  factory _CourseRecommendationRequestModel.fromJson(
    Map<String, dynamic> json,
  ) = _$CourseRecommendationRequestModelImpl.fromJson;

  /// 입구 원문 — 필수
  @override
  String get entrance;

  /// 출구 원문 — 필수
  @override
  String get exit;

  /// 관심 태그 원문 목록. null이면 AI가 전체 태그를 대상으로 추천한다
  @override
  List<String>? get interestTypes;

  /// 희망 체류시간(분). null이면 AI가 알아서 정한다
  @override
  int? get stayDurationMinutes;

  /// 동행 유형 원문. null이면 AI가 알아서 정한다
  @override
  String? get companionType;

  /// Create a copy of CourseRecommendationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseRecommendationRequestModelImplCopyWith<
    _$CourseRecommendationRequestModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
