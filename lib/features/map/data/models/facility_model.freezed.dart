// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FacilityModel _$FacilityModelFromJson(Map<String, dynamic> json) {
  return _FacilityModel.fromJson(json);
}

/// @nodoc
mixin _$FacilityModel {
  int get id => throw _privateConstructorUsedError;

  /// 시설 분류 (`출입문`, `편의시설` 등)
  String get category => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get facilityType => throw _privateConstructorUsedError;

  /// Serializes this FacilityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacilityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacilityModelCopyWith<FacilityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacilityModelCopyWith<$Res> {
  factory $FacilityModelCopyWith(
    FacilityModel value,
    $Res Function(FacilityModel) then,
  ) = _$FacilityModelCopyWithImpl<$Res, FacilityModel>;
  @useResult
  $Res call({
    int id,
    String category,
    String name,
    double? latitude,
    double? longitude,
    String? facilityType,
  });
}

/// @nodoc
class _$FacilityModelCopyWithImpl<$Res, $Val extends FacilityModel>
    implements $FacilityModelCopyWith<$Res> {
  _$FacilityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacilityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? name = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? facilityType = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            facilityType: freezed == facilityType
                ? _value.facilityType
                : facilityType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FacilityModelImplCopyWith<$Res>
    implements $FacilityModelCopyWith<$Res> {
  factory _$$FacilityModelImplCopyWith(
    _$FacilityModelImpl value,
    $Res Function(_$FacilityModelImpl) then,
  ) = __$$FacilityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String category,
    String name,
    double? latitude,
    double? longitude,
    String? facilityType,
  });
}

/// @nodoc
class __$$FacilityModelImplCopyWithImpl<$Res>
    extends _$FacilityModelCopyWithImpl<$Res, _$FacilityModelImpl>
    implements _$$FacilityModelImplCopyWith<$Res> {
  __$$FacilityModelImplCopyWithImpl(
    _$FacilityModelImpl _value,
    $Res Function(_$FacilityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FacilityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? name = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? facilityType = freezed,
  }) {
    return _then(
      _$FacilityModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        facilityType: freezed == facilityType
            ? _value.facilityType
            : facilityType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FacilityModelImpl implements _FacilityModel {
  const _$FacilityModelImpl({
    this.id = 0,
    this.category = '',
    this.name = '',
    this.latitude,
    this.longitude,
    this.facilityType,
  });

  factory _$FacilityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacilityModelImplFromJson(json);

  @override
  @JsonKey()
  final int id;

  /// 시설 분류 (`출입문`, `편의시설` 등)
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String name;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? facilityType;

  @override
  String toString() {
    return 'FacilityModel(id: $id, category: $category, name: $name, latitude: $latitude, longitude: $longitude, facilityType: $facilityType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacilityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.facilityType, facilityType) ||
                other.facilityType == facilityType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    category,
    name,
    latitude,
    longitude,
    facilityType,
  );

  /// Create a copy of FacilityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacilityModelImplCopyWith<_$FacilityModelImpl> get copyWith =>
      __$$FacilityModelImplCopyWithImpl<_$FacilityModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacilityModelImplToJson(this);
  }
}

abstract class _FacilityModel implements FacilityModel {
  const factory _FacilityModel({
    final int id,
    final String category,
    final String name,
    final double? latitude,
    final double? longitude,
    final String? facilityType,
  }) = _$FacilityModelImpl;

  factory _FacilityModel.fromJson(Map<String, dynamic> json) =
      _$FacilityModelImpl.fromJson;

  @override
  int get id;

  /// 시설 분류 (`출입문`, `편의시설` 등)
  @override
  String get category;
  @override
  String get name;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get facilityType;

  /// Create a copy of FacilityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacilityModelImplCopyWith<_$FacilityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FacilityDetailModel _$FacilityDetailModelFromJson(Map<String, dynamic> json) {
  return _FacilityDetailModel.fromJson(json);
}

/// @nodoc
mixin _$FacilityDetailModel {
  int get id => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get intro => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get facilityType => throw _privateConstructorUsedError;
  String? get openTime => throw _privateConstructorUsedError;
  String? get closeTime => throw _privateConstructorUsedError;
  String? get operatingNote => throw _privateConstructorUsedError;

  /// Serializes this FacilityDetailModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacilityDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacilityDetailModelCopyWith<FacilityDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacilityDetailModelCopyWith<$Res> {
  factory $FacilityDetailModelCopyWith(
    FacilityDetailModel value,
    $Res Function(FacilityDetailModel) then,
  ) = _$FacilityDetailModelCopyWithImpl<$Res, FacilityDetailModel>;
  @useResult
  $Res call({
    int id,
    String category,
    String name,
    String? intro,
    String? description,
    double? latitude,
    double? longitude,
    String? facilityType,
    String? openTime,
    String? closeTime,
    String? operatingNote,
  });
}

/// @nodoc
class _$FacilityDetailModelCopyWithImpl<$Res, $Val extends FacilityDetailModel>
    implements $FacilityDetailModelCopyWith<$Res> {
  _$FacilityDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacilityDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? name = null,
    Object? intro = freezed,
    Object? description = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? facilityType = freezed,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? operatingNote = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            intro: freezed == intro
                ? _value.intro
                : intro // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            facilityType: freezed == facilityType
                ? _value.facilityType
                : facilityType // ignore: cast_nullable_to_non_nullable
                      as String?,
            openTime: freezed == openTime
                ? _value.openTime
                : openTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            closeTime: freezed == closeTime
                ? _value.closeTime
                : closeTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            operatingNote: freezed == operatingNote
                ? _value.operatingNote
                : operatingNote // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FacilityDetailModelImplCopyWith<$Res>
    implements $FacilityDetailModelCopyWith<$Res> {
  factory _$$FacilityDetailModelImplCopyWith(
    _$FacilityDetailModelImpl value,
    $Res Function(_$FacilityDetailModelImpl) then,
  ) = __$$FacilityDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String category,
    String name,
    String? intro,
    String? description,
    double? latitude,
    double? longitude,
    String? facilityType,
    String? openTime,
    String? closeTime,
    String? operatingNote,
  });
}

/// @nodoc
class __$$FacilityDetailModelImplCopyWithImpl<$Res>
    extends _$FacilityDetailModelCopyWithImpl<$Res, _$FacilityDetailModelImpl>
    implements _$$FacilityDetailModelImplCopyWith<$Res> {
  __$$FacilityDetailModelImplCopyWithImpl(
    _$FacilityDetailModelImpl _value,
    $Res Function(_$FacilityDetailModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FacilityDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? name = null,
    Object? intro = freezed,
    Object? description = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? facilityType = freezed,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? operatingNote = freezed,
  }) {
    return _then(
      _$FacilityDetailModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        intro: freezed == intro
            ? _value.intro
            : intro // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        facilityType: freezed == facilityType
            ? _value.facilityType
            : facilityType // ignore: cast_nullable_to_non_nullable
                  as String?,
        openTime: freezed == openTime
            ? _value.openTime
            : openTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        closeTime: freezed == closeTime
            ? _value.closeTime
            : closeTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        operatingNote: freezed == operatingNote
            ? _value.operatingNote
            : operatingNote // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FacilityDetailModelImpl implements _FacilityDetailModel {
  const _$FacilityDetailModelImpl({
    this.id = 0,
    this.category = '',
    this.name = '',
    this.intro,
    this.description,
    this.latitude,
    this.longitude,
    this.facilityType,
    this.openTime,
    this.closeTime,
    this.operatingNote,
  });

  factory _$FacilityDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacilityDetailModelImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String name;
  @override
  final String? intro;
  @override
  final String? description;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? facilityType;
  @override
  final String? openTime;
  @override
  final String? closeTime;
  @override
  final String? operatingNote;

  @override
  String toString() {
    return 'FacilityDetailModel(id: $id, category: $category, name: $name, intro: $intro, description: $description, latitude: $latitude, longitude: $longitude, facilityType: $facilityType, openTime: $openTime, closeTime: $closeTime, operatingNote: $operatingNote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacilityDetailModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.intro, intro) || other.intro == intro) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.facilityType, facilityType) ||
                other.facilityType == facilityType) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime) &&
            (identical(other.operatingNote, operatingNote) ||
                other.operatingNote == operatingNote));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    category,
    name,
    intro,
    description,
    latitude,
    longitude,
    facilityType,
    openTime,
    closeTime,
    operatingNote,
  );

  /// Create a copy of FacilityDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacilityDetailModelImplCopyWith<_$FacilityDetailModelImpl> get copyWith =>
      __$$FacilityDetailModelImplCopyWithImpl<_$FacilityDetailModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FacilityDetailModelImplToJson(this);
  }
}

abstract class _FacilityDetailModel implements FacilityDetailModel {
  const factory _FacilityDetailModel({
    final int id,
    final String category,
    final String name,
    final String? intro,
    final String? description,
    final double? latitude,
    final double? longitude,
    final String? facilityType,
    final String? openTime,
    final String? closeTime,
    final String? operatingNote,
  }) = _$FacilityDetailModelImpl;

  factory _FacilityDetailModel.fromJson(Map<String, dynamic> json) =
      _$FacilityDetailModelImpl.fromJson;

  @override
  int get id;
  @override
  String get category;
  @override
  String get name;
  @override
  String? get intro;
  @override
  String? get description;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get facilityType;
  @override
  String? get openTime;
  @override
  String? get closeTime;
  @override
  String? get operatingNote;

  /// Create a copy of FacilityDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacilityDetailModelImplCopyWith<_$FacilityDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
