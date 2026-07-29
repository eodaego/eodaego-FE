// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HourlyWeatherModel _$HourlyWeatherModelFromJson(Map<String, dynamic> json) {
  return _HourlyWeatherModel.fromJson(json);
}

/// @nodoc
mixin _$HourlyWeatherModel {
  /// 예보 시각 (오프셋 없음)
  String? get datetime => throw _privateConstructorUsedError;

  /// 예상 기온 — 서버가 정수로 내려도 double로 읽는다
  double get temperature => throw _privateConstructorUsedError;

  /// 강수 확률 백분율
  int get precipitationProbability => throw _privateConstructorUsedError;

  /// 강수 형태 원문
  String get precipitationType => throw _privateConstructorUsedError;

  /// 하늘 상태 원문
  String get skyCondition => throw _privateConstructorUsedError;

  /// Serializes this HourlyWeatherModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HourlyWeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HourlyWeatherModelCopyWith<HourlyWeatherModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourlyWeatherModelCopyWith<$Res> {
  factory $HourlyWeatherModelCopyWith(
    HourlyWeatherModel value,
    $Res Function(HourlyWeatherModel) then,
  ) = _$HourlyWeatherModelCopyWithImpl<$Res, HourlyWeatherModel>;
  @useResult
  $Res call({
    String? datetime,
    double temperature,
    int precipitationProbability,
    String precipitationType,
    String skyCondition,
  });
}

/// @nodoc
class _$HourlyWeatherModelCopyWithImpl<$Res, $Val extends HourlyWeatherModel>
    implements $HourlyWeatherModelCopyWith<$Res> {
  _$HourlyWeatherModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HourlyWeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datetime = freezed,
    Object? temperature = null,
    Object? precipitationProbability = null,
    Object? precipitationType = null,
    Object? skyCondition = null,
  }) {
    return _then(
      _value.copyWith(
            datetime: freezed == datetime
                ? _value.datetime
                : datetime // ignore: cast_nullable_to_non_nullable
                      as String?,
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double,
            precipitationProbability: null == precipitationProbability
                ? _value.precipitationProbability
                : precipitationProbability // ignore: cast_nullable_to_non_nullable
                      as int,
            precipitationType: null == precipitationType
                ? _value.precipitationType
                : precipitationType // ignore: cast_nullable_to_non_nullable
                      as String,
            skyCondition: null == skyCondition
                ? _value.skyCondition
                : skyCondition // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HourlyWeatherModelImplCopyWith<$Res>
    implements $HourlyWeatherModelCopyWith<$Res> {
  factory _$$HourlyWeatherModelImplCopyWith(
    _$HourlyWeatherModelImpl value,
    $Res Function(_$HourlyWeatherModelImpl) then,
  ) = __$$HourlyWeatherModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? datetime,
    double temperature,
    int precipitationProbability,
    String precipitationType,
    String skyCondition,
  });
}

/// @nodoc
class __$$HourlyWeatherModelImplCopyWithImpl<$Res>
    extends _$HourlyWeatherModelCopyWithImpl<$Res, _$HourlyWeatherModelImpl>
    implements _$$HourlyWeatherModelImplCopyWith<$Res> {
  __$$HourlyWeatherModelImplCopyWithImpl(
    _$HourlyWeatherModelImpl _value,
    $Res Function(_$HourlyWeatherModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HourlyWeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datetime = freezed,
    Object? temperature = null,
    Object? precipitationProbability = null,
    Object? precipitationType = null,
    Object? skyCondition = null,
  }) {
    return _then(
      _$HourlyWeatherModelImpl(
        datetime: freezed == datetime
            ? _value.datetime
            : datetime // ignore: cast_nullable_to_non_nullable
                  as String?,
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double,
        precipitationProbability: null == precipitationProbability
            ? _value.precipitationProbability
            : precipitationProbability // ignore: cast_nullable_to_non_nullable
                  as int,
        precipitationType: null == precipitationType
            ? _value.precipitationType
            : precipitationType // ignore: cast_nullable_to_non_nullable
                  as String,
        skyCondition: null == skyCondition
            ? _value.skyCondition
            : skyCondition // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HourlyWeatherModelImpl implements _HourlyWeatherModel {
  const _$HourlyWeatherModelImpl({
    this.datetime,
    this.temperature = 0,
    this.precipitationProbability = 0,
    this.precipitationType = '',
    this.skyCondition = '',
  });

  factory _$HourlyWeatherModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HourlyWeatherModelImplFromJson(json);

  /// 예보 시각 (오프셋 없음)
  @override
  final String? datetime;

  /// 예상 기온 — 서버가 정수로 내려도 double로 읽는다
  @override
  @JsonKey()
  final double temperature;

  /// 강수 확률 백분율
  @override
  @JsonKey()
  final int precipitationProbability;

  /// 강수 형태 원문
  @override
  @JsonKey()
  final String precipitationType;

  /// 하늘 상태 원문
  @override
  @JsonKey()
  final String skyCondition;

  @override
  String toString() {
    return 'HourlyWeatherModel(datetime: $datetime, temperature: $temperature, precipitationProbability: $precipitationProbability, precipitationType: $precipitationType, skyCondition: $skyCondition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlyWeatherModelImpl &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(
                  other.precipitationProbability,
                  precipitationProbability,
                ) ||
                other.precipitationProbability == precipitationProbability) &&
            (identical(other.precipitationType, precipitationType) ||
                other.precipitationType == precipitationType) &&
            (identical(other.skyCondition, skyCondition) ||
                other.skyCondition == skyCondition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    datetime,
    temperature,
    precipitationProbability,
    precipitationType,
    skyCondition,
  );

  /// Create a copy of HourlyWeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlyWeatherModelImplCopyWith<_$HourlyWeatherModelImpl> get copyWith =>
      __$$HourlyWeatherModelImplCopyWithImpl<_$HourlyWeatherModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HourlyWeatherModelImplToJson(this);
  }
}

abstract class _HourlyWeatherModel implements HourlyWeatherModel {
  const factory _HourlyWeatherModel({
    final String? datetime,
    final double temperature,
    final int precipitationProbability,
    final String precipitationType,
    final String skyCondition,
  }) = _$HourlyWeatherModelImpl;

  factory _HourlyWeatherModel.fromJson(Map<String, dynamic> json) =
      _$HourlyWeatherModelImpl.fromJson;

  /// 예보 시각 (오프셋 없음)
  @override
  String? get datetime;

  /// 예상 기온 — 서버가 정수로 내려도 double로 읽는다
  @override
  double get temperature;

  /// 강수 확률 백분율
  @override
  int get precipitationProbability;

  /// 강수 형태 원문
  @override
  String get precipitationType;

  /// 하늘 상태 원문
  @override
  String get skyCondition;

  /// Create a copy of HourlyWeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HourlyWeatherModelImplCopyWith<_$HourlyWeatherModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) {
  return _WeatherModel.fromJson(json);
}

/// @nodoc
mixin _$WeatherModel {
  /// 현재 기온
  double get temperature => throw _privateConstructorUsedError;

  /// 현재 습도 백분율
  int get humidity => throw _privateConstructorUsedError;

  /// 현재 풍속 (m/s)
  double get windSpeed => throw _privateConstructorUsedError;

  /// 강수 형태 원문
  String get precipitationType => throw _privateConstructorUsedError;

  /// 하늘 상태 원문
  String get skyCondition => throw _privateConstructorUsedError;

  /// 관측 시각 (오프셋 없음)
  String? get observedAt => throw _privateConstructorUsedError;

  /// 시간대별 예보
  List<HourlyWeatherModel> get hourlyForecast =>
      throw _privateConstructorUsedError;

  /// Serializes this WeatherModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherModelCopyWith<WeatherModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherModelCopyWith<$Res> {
  factory $WeatherModelCopyWith(
    WeatherModel value,
    $Res Function(WeatherModel) then,
  ) = _$WeatherModelCopyWithImpl<$Res, WeatherModel>;
  @useResult
  $Res call({
    double temperature,
    int humidity,
    double windSpeed,
    String precipitationType,
    String skyCondition,
    String? observedAt,
    List<HourlyWeatherModel> hourlyForecast,
  });
}

/// @nodoc
class _$WeatherModelCopyWithImpl<$Res, $Val extends WeatherModel>
    implements $WeatherModelCopyWith<$Res> {
  _$WeatherModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? humidity = null,
    Object? windSpeed = null,
    Object? precipitationType = null,
    Object? skyCondition = null,
    Object? observedAt = freezed,
    Object? hourlyForecast = null,
  }) {
    return _then(
      _value.copyWith(
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double,
            humidity: null == humidity
                ? _value.humidity
                : humidity // ignore: cast_nullable_to_non_nullable
                      as int,
            windSpeed: null == windSpeed
                ? _value.windSpeed
                : windSpeed // ignore: cast_nullable_to_non_nullable
                      as double,
            precipitationType: null == precipitationType
                ? _value.precipitationType
                : precipitationType // ignore: cast_nullable_to_non_nullable
                      as String,
            skyCondition: null == skyCondition
                ? _value.skyCondition
                : skyCondition // ignore: cast_nullable_to_non_nullable
                      as String,
            observedAt: freezed == observedAt
                ? _value.observedAt
                : observedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            hourlyForecast: null == hourlyForecast
                ? _value.hourlyForecast
                : hourlyForecast // ignore: cast_nullable_to_non_nullable
                      as List<HourlyWeatherModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeatherModelImplCopyWith<$Res>
    implements $WeatherModelCopyWith<$Res> {
  factory _$$WeatherModelImplCopyWith(
    _$WeatherModelImpl value,
    $Res Function(_$WeatherModelImpl) then,
  ) = __$$WeatherModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double temperature,
    int humidity,
    double windSpeed,
    String precipitationType,
    String skyCondition,
    String? observedAt,
    List<HourlyWeatherModel> hourlyForecast,
  });
}

/// @nodoc
class __$$WeatherModelImplCopyWithImpl<$Res>
    extends _$WeatherModelCopyWithImpl<$Res, _$WeatherModelImpl>
    implements _$$WeatherModelImplCopyWith<$Res> {
  __$$WeatherModelImplCopyWithImpl(
    _$WeatherModelImpl _value,
    $Res Function(_$WeatherModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? humidity = null,
    Object? windSpeed = null,
    Object? precipitationType = null,
    Object? skyCondition = null,
    Object? observedAt = freezed,
    Object? hourlyForecast = null,
  }) {
    return _then(
      _$WeatherModelImpl(
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double,
        humidity: null == humidity
            ? _value.humidity
            : humidity // ignore: cast_nullable_to_non_nullable
                  as int,
        windSpeed: null == windSpeed
            ? _value.windSpeed
            : windSpeed // ignore: cast_nullable_to_non_nullable
                  as double,
        precipitationType: null == precipitationType
            ? _value.precipitationType
            : precipitationType // ignore: cast_nullable_to_non_nullable
                  as String,
        skyCondition: null == skyCondition
            ? _value.skyCondition
            : skyCondition // ignore: cast_nullable_to_non_nullable
                  as String,
        observedAt: freezed == observedAt
            ? _value.observedAt
            : observedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        hourlyForecast: null == hourlyForecast
            ? _value._hourlyForecast
            : hourlyForecast // ignore: cast_nullable_to_non_nullable
                  as List<HourlyWeatherModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherModelImpl implements _WeatherModel {
  const _$WeatherModelImpl({
    this.temperature = 0,
    this.humidity = 0,
    this.windSpeed = 0,
    this.precipitationType = '',
    this.skyCondition = '',
    this.observedAt,
    final List<HourlyWeatherModel> hourlyForecast =
        const <HourlyWeatherModel>[],
  }) : _hourlyForecast = hourlyForecast;

  factory _$WeatherModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherModelImplFromJson(json);

  /// 현재 기온
  @override
  @JsonKey()
  final double temperature;

  /// 현재 습도 백분율
  @override
  @JsonKey()
  final int humidity;

  /// 현재 풍속 (m/s)
  @override
  @JsonKey()
  final double windSpeed;

  /// 강수 형태 원문
  @override
  @JsonKey()
  final String precipitationType;

  /// 하늘 상태 원문
  @override
  @JsonKey()
  final String skyCondition;

  /// 관측 시각 (오프셋 없음)
  @override
  final String? observedAt;

  /// 시간대별 예보
  final List<HourlyWeatherModel> _hourlyForecast;

  /// 시간대별 예보
  @override
  @JsonKey()
  List<HourlyWeatherModel> get hourlyForecast {
    if (_hourlyForecast is EqualUnmodifiableListView) return _hourlyForecast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hourlyForecast);
  }

  @override
  String toString() {
    return 'WeatherModel(temperature: $temperature, humidity: $humidity, windSpeed: $windSpeed, precipitationType: $precipitationType, skyCondition: $skyCondition, observedAt: $observedAt, hourlyForecast: $hourlyForecast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherModelImpl &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.windSpeed, windSpeed) ||
                other.windSpeed == windSpeed) &&
            (identical(other.precipitationType, precipitationType) ||
                other.precipitationType == precipitationType) &&
            (identical(other.skyCondition, skyCondition) ||
                other.skyCondition == skyCondition) &&
            (identical(other.observedAt, observedAt) ||
                other.observedAt == observedAt) &&
            const DeepCollectionEquality().equals(
              other._hourlyForecast,
              _hourlyForecast,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    temperature,
    humidity,
    windSpeed,
    precipitationType,
    skyCondition,
    observedAt,
    const DeepCollectionEquality().hash(_hourlyForecast),
  );

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherModelImplCopyWith<_$WeatherModelImpl> get copyWith =>
      __$$WeatherModelImplCopyWithImpl<_$WeatherModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherModelImplToJson(this);
  }
}

abstract class _WeatherModel implements WeatherModel {
  const factory _WeatherModel({
    final double temperature,
    final int humidity,
    final double windSpeed,
    final String precipitationType,
    final String skyCondition,
    final String? observedAt,
    final List<HourlyWeatherModel> hourlyForecast,
  }) = _$WeatherModelImpl;

  factory _WeatherModel.fromJson(Map<String, dynamic> json) =
      _$WeatherModelImpl.fromJson;

  /// 현재 기온
  @override
  double get temperature;

  /// 현재 습도 백분율
  @override
  int get humidity;

  /// 현재 풍속 (m/s)
  @override
  double get windSpeed;

  /// 강수 형태 원문
  @override
  String get precipitationType;

  /// 하늘 상태 원문
  @override
  String get skyCondition;

  /// 관측 시각 (오프셋 없음)
  @override
  String? get observedAt;

  /// 시간대별 예보
  @override
  List<HourlyWeatherModel> get hourlyForecast;

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherModelImplCopyWith<_$WeatherModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
