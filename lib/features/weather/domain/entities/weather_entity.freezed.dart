// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HourlyForecastEntity {
  /// 예보 시각 (KST 벽시계)
  DateTime get dateTime => throw _privateConstructorUsedError;

  /// 예상 기온
  double get temperature => throw _privateConstructorUsedError;

  /// 강수 확률 백분율
  int get precipitationProbability => throw _privateConstructorUsedError;

  /// 하늘 상태 서버 원문
  String get skyLabel => throw _privateConstructorUsedError;

  /// 강수 형태 서버 원문
  String get precipitationLabel => throw _privateConstructorUsedError;

  /// 매핑된 하늘 상태 — 모르는 값이면 null
  WeatherSky? get sky => throw _privateConstructorUsedError;

  /// 매핑된 강수 형태 — 모르는 값이면 null
  WeatherPrecipitation? get precipitation => throw _privateConstructorUsedError;

  /// Create a copy of HourlyForecastEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HourlyForecastEntityCopyWith<HourlyForecastEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourlyForecastEntityCopyWith<$Res> {
  factory $HourlyForecastEntityCopyWith(
    HourlyForecastEntity value,
    $Res Function(HourlyForecastEntity) then,
  ) = _$HourlyForecastEntityCopyWithImpl<$Res, HourlyForecastEntity>;
  @useResult
  $Res call({
    DateTime dateTime,
    double temperature,
    int precipitationProbability,
    String skyLabel,
    String precipitationLabel,
    WeatherSky? sky,
    WeatherPrecipitation? precipitation,
  });
}

/// @nodoc
class _$HourlyForecastEntityCopyWithImpl<
  $Res,
  $Val extends HourlyForecastEntity
>
    implements $HourlyForecastEntityCopyWith<$Res> {
  _$HourlyForecastEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HourlyForecastEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = null,
    Object? temperature = null,
    Object? precipitationProbability = null,
    Object? skyLabel = null,
    Object? precipitationLabel = null,
    Object? sky = freezed,
    Object? precipitation = freezed,
  }) {
    return _then(
      _value.copyWith(
            dateTime: null == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double,
            precipitationProbability: null == precipitationProbability
                ? _value.precipitationProbability
                : precipitationProbability // ignore: cast_nullable_to_non_nullable
                      as int,
            skyLabel: null == skyLabel
                ? _value.skyLabel
                : skyLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            precipitationLabel: null == precipitationLabel
                ? _value.precipitationLabel
                : precipitationLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            sky: freezed == sky
                ? _value.sky
                : sky // ignore: cast_nullable_to_non_nullable
                      as WeatherSky?,
            precipitation: freezed == precipitation
                ? _value.precipitation
                : precipitation // ignore: cast_nullable_to_non_nullable
                      as WeatherPrecipitation?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HourlyForecastEntityImplCopyWith<$Res>
    implements $HourlyForecastEntityCopyWith<$Res> {
  factory _$$HourlyForecastEntityImplCopyWith(
    _$HourlyForecastEntityImpl value,
    $Res Function(_$HourlyForecastEntityImpl) then,
  ) = __$$HourlyForecastEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime dateTime,
    double temperature,
    int precipitationProbability,
    String skyLabel,
    String precipitationLabel,
    WeatherSky? sky,
    WeatherPrecipitation? precipitation,
  });
}

/// @nodoc
class __$$HourlyForecastEntityImplCopyWithImpl<$Res>
    extends _$HourlyForecastEntityCopyWithImpl<$Res, _$HourlyForecastEntityImpl>
    implements _$$HourlyForecastEntityImplCopyWith<$Res> {
  __$$HourlyForecastEntityImplCopyWithImpl(
    _$HourlyForecastEntityImpl _value,
    $Res Function(_$HourlyForecastEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HourlyForecastEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = null,
    Object? temperature = null,
    Object? precipitationProbability = null,
    Object? skyLabel = null,
    Object? precipitationLabel = null,
    Object? sky = freezed,
    Object? precipitation = freezed,
  }) {
    return _then(
      _$HourlyForecastEntityImpl(
        dateTime: null == dateTime
            ? _value.dateTime
            : dateTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double,
        precipitationProbability: null == precipitationProbability
            ? _value.precipitationProbability
            : precipitationProbability // ignore: cast_nullable_to_non_nullable
                  as int,
        skyLabel: null == skyLabel
            ? _value.skyLabel
            : skyLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        precipitationLabel: null == precipitationLabel
            ? _value.precipitationLabel
            : precipitationLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        sky: freezed == sky
            ? _value.sky
            : sky // ignore: cast_nullable_to_non_nullable
                  as WeatherSky?,
        precipitation: freezed == precipitation
            ? _value.precipitation
            : precipitation // ignore: cast_nullable_to_non_nullable
                  as WeatherPrecipitation?,
      ),
    );
  }
}

/// @nodoc

class _$HourlyForecastEntityImpl extends _HourlyForecastEntity {
  const _$HourlyForecastEntityImpl({
    required this.dateTime,
    required this.temperature,
    required this.precipitationProbability,
    required this.skyLabel,
    required this.precipitationLabel,
    this.sky,
    this.precipitation,
  }) : super._();

  /// 예보 시각 (KST 벽시계)
  @override
  final DateTime dateTime;

  /// 예상 기온
  @override
  final double temperature;

  /// 강수 확률 백분율
  @override
  final int precipitationProbability;

  /// 하늘 상태 서버 원문
  @override
  final String skyLabel;

  /// 강수 형태 서버 원문
  @override
  final String precipitationLabel;

  /// 매핑된 하늘 상태 — 모르는 값이면 null
  @override
  final WeatherSky? sky;

  /// 매핑된 강수 형태 — 모르는 값이면 null
  @override
  final WeatherPrecipitation? precipitation;

  @override
  String toString() {
    return 'HourlyForecastEntity(dateTime: $dateTime, temperature: $temperature, precipitationProbability: $precipitationProbability, skyLabel: $skyLabel, precipitationLabel: $precipitationLabel, sky: $sky, precipitation: $precipitation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlyForecastEntityImpl &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(
                  other.precipitationProbability,
                  precipitationProbability,
                ) ||
                other.precipitationProbability == precipitationProbability) &&
            (identical(other.skyLabel, skyLabel) ||
                other.skyLabel == skyLabel) &&
            (identical(other.precipitationLabel, precipitationLabel) ||
                other.precipitationLabel == precipitationLabel) &&
            (identical(other.sky, sky) || other.sky == sky) &&
            (identical(other.precipitation, precipitation) ||
                other.precipitation == precipitation));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    dateTime,
    temperature,
    precipitationProbability,
    skyLabel,
    precipitationLabel,
    sky,
    precipitation,
  );

  /// Create a copy of HourlyForecastEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlyForecastEntityImplCopyWith<_$HourlyForecastEntityImpl>
  get copyWith =>
      __$$HourlyForecastEntityImplCopyWithImpl<_$HourlyForecastEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _HourlyForecastEntity extends HourlyForecastEntity {
  const factory _HourlyForecastEntity({
    required final DateTime dateTime,
    required final double temperature,
    required final int precipitationProbability,
    required final String skyLabel,
    required final String precipitationLabel,
    final WeatherSky? sky,
    final WeatherPrecipitation? precipitation,
  }) = _$HourlyForecastEntityImpl;
  const _HourlyForecastEntity._() : super._();

  /// 예보 시각 (KST 벽시계)
  @override
  DateTime get dateTime;

  /// 예상 기온
  @override
  double get temperature;

  /// 강수 확률 백분율
  @override
  int get precipitationProbability;

  /// 하늘 상태 서버 원문
  @override
  String get skyLabel;

  /// 강수 형태 서버 원문
  @override
  String get precipitationLabel;

  /// 매핑된 하늘 상태 — 모르는 값이면 null
  @override
  WeatherSky? get sky;

  /// 매핑된 강수 형태 — 모르는 값이면 null
  @override
  WeatherPrecipitation? get precipitation;

  /// Create a copy of HourlyForecastEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HourlyForecastEntityImplCopyWith<_$HourlyForecastEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WeatherEntity {
  /// 현재 기온
  double get temperature => throw _privateConstructorUsedError;

  /// 현재 습도 백분율
  int get humidity => throw _privateConstructorUsedError;

  /// 현재 풍속 (m/s)
  double get windSpeed => throw _privateConstructorUsedError;

  /// 하늘 상태 서버 원문
  String get skyLabel => throw _privateConstructorUsedError;

  /// 강수 형태 서버 원문
  String get precipitationLabel => throw _privateConstructorUsedError;

  /// 시간대별 예보. 지나간 시각이 섞여 있으므로 [upcomingFrom]으로 거른다.
  List<HourlyForecastEntity> get hourlyForecast =>
      throw _privateConstructorUsedError;

  /// 매핑된 하늘 상태 — 모르는 값이면 null
  WeatherSky? get sky => throw _privateConstructorUsedError;

  /// 매핑된 강수 형태 — 모르는 값이면 null
  WeatherPrecipitation? get precipitation => throw _privateConstructorUsedError;

  /// 관측 시각 (KST 벽시계)
  DateTime? get observedAt => throw _privateConstructorUsedError;

  /// Create a copy of WeatherEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherEntityCopyWith<WeatherEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherEntityCopyWith<$Res> {
  factory $WeatherEntityCopyWith(
    WeatherEntity value,
    $Res Function(WeatherEntity) then,
  ) = _$WeatherEntityCopyWithImpl<$Res, WeatherEntity>;
  @useResult
  $Res call({
    double temperature,
    int humidity,
    double windSpeed,
    String skyLabel,
    String precipitationLabel,
    List<HourlyForecastEntity> hourlyForecast,
    WeatherSky? sky,
    WeatherPrecipitation? precipitation,
    DateTime? observedAt,
  });
}

/// @nodoc
class _$WeatherEntityCopyWithImpl<$Res, $Val extends WeatherEntity>
    implements $WeatherEntityCopyWith<$Res> {
  _$WeatherEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? humidity = null,
    Object? windSpeed = null,
    Object? skyLabel = null,
    Object? precipitationLabel = null,
    Object? hourlyForecast = null,
    Object? sky = freezed,
    Object? precipitation = freezed,
    Object? observedAt = freezed,
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
            skyLabel: null == skyLabel
                ? _value.skyLabel
                : skyLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            precipitationLabel: null == precipitationLabel
                ? _value.precipitationLabel
                : precipitationLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            hourlyForecast: null == hourlyForecast
                ? _value.hourlyForecast
                : hourlyForecast // ignore: cast_nullable_to_non_nullable
                      as List<HourlyForecastEntity>,
            sky: freezed == sky
                ? _value.sky
                : sky // ignore: cast_nullable_to_non_nullable
                      as WeatherSky?,
            precipitation: freezed == precipitation
                ? _value.precipitation
                : precipitation // ignore: cast_nullable_to_non_nullable
                      as WeatherPrecipitation?,
            observedAt: freezed == observedAt
                ? _value.observedAt
                : observedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeatherEntityImplCopyWith<$Res>
    implements $WeatherEntityCopyWith<$Res> {
  factory _$$WeatherEntityImplCopyWith(
    _$WeatherEntityImpl value,
    $Res Function(_$WeatherEntityImpl) then,
  ) = __$$WeatherEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double temperature,
    int humidity,
    double windSpeed,
    String skyLabel,
    String precipitationLabel,
    List<HourlyForecastEntity> hourlyForecast,
    WeatherSky? sky,
    WeatherPrecipitation? precipitation,
    DateTime? observedAt,
  });
}

/// @nodoc
class __$$WeatherEntityImplCopyWithImpl<$Res>
    extends _$WeatherEntityCopyWithImpl<$Res, _$WeatherEntityImpl>
    implements _$$WeatherEntityImplCopyWith<$Res> {
  __$$WeatherEntityImplCopyWithImpl(
    _$WeatherEntityImpl _value,
    $Res Function(_$WeatherEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? humidity = null,
    Object? windSpeed = null,
    Object? skyLabel = null,
    Object? precipitationLabel = null,
    Object? hourlyForecast = null,
    Object? sky = freezed,
    Object? precipitation = freezed,
    Object? observedAt = freezed,
  }) {
    return _then(
      _$WeatherEntityImpl(
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
        skyLabel: null == skyLabel
            ? _value.skyLabel
            : skyLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        precipitationLabel: null == precipitationLabel
            ? _value.precipitationLabel
            : precipitationLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        hourlyForecast: null == hourlyForecast
            ? _value._hourlyForecast
            : hourlyForecast // ignore: cast_nullable_to_non_nullable
                  as List<HourlyForecastEntity>,
        sky: freezed == sky
            ? _value.sky
            : sky // ignore: cast_nullable_to_non_nullable
                  as WeatherSky?,
        precipitation: freezed == precipitation
            ? _value.precipitation
            : precipitation // ignore: cast_nullable_to_non_nullable
                  as WeatherPrecipitation?,
        observedAt: freezed == observedAt
            ? _value.observedAt
            : observedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$WeatherEntityImpl extends _WeatherEntity {
  const _$WeatherEntityImpl({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.skyLabel,
    required this.precipitationLabel,
    required final List<HourlyForecastEntity> hourlyForecast,
    this.sky,
    this.precipitation,
    this.observedAt,
  }) : _hourlyForecast = hourlyForecast,
       super._();

  /// 현재 기온
  @override
  final double temperature;

  /// 현재 습도 백분율
  @override
  final int humidity;

  /// 현재 풍속 (m/s)
  @override
  final double windSpeed;

  /// 하늘 상태 서버 원문
  @override
  final String skyLabel;

  /// 강수 형태 서버 원문
  @override
  final String precipitationLabel;

  /// 시간대별 예보. 지나간 시각이 섞여 있으므로 [upcomingFrom]으로 거른다.
  final List<HourlyForecastEntity> _hourlyForecast;

  /// 시간대별 예보. 지나간 시각이 섞여 있으므로 [upcomingFrom]으로 거른다.
  @override
  List<HourlyForecastEntity> get hourlyForecast {
    if (_hourlyForecast is EqualUnmodifiableListView) return _hourlyForecast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hourlyForecast);
  }

  /// 매핑된 하늘 상태 — 모르는 값이면 null
  @override
  final WeatherSky? sky;

  /// 매핑된 강수 형태 — 모르는 값이면 null
  @override
  final WeatherPrecipitation? precipitation;

  /// 관측 시각 (KST 벽시계)
  @override
  final DateTime? observedAt;

  @override
  String toString() {
    return 'WeatherEntity(temperature: $temperature, humidity: $humidity, windSpeed: $windSpeed, skyLabel: $skyLabel, precipitationLabel: $precipitationLabel, hourlyForecast: $hourlyForecast, sky: $sky, precipitation: $precipitation, observedAt: $observedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherEntityImpl &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.windSpeed, windSpeed) ||
                other.windSpeed == windSpeed) &&
            (identical(other.skyLabel, skyLabel) ||
                other.skyLabel == skyLabel) &&
            (identical(other.precipitationLabel, precipitationLabel) ||
                other.precipitationLabel == precipitationLabel) &&
            const DeepCollectionEquality().equals(
              other._hourlyForecast,
              _hourlyForecast,
            ) &&
            (identical(other.sky, sky) || other.sky == sky) &&
            (identical(other.precipitation, precipitation) ||
                other.precipitation == precipitation) &&
            (identical(other.observedAt, observedAt) ||
                other.observedAt == observedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    temperature,
    humidity,
    windSpeed,
    skyLabel,
    precipitationLabel,
    const DeepCollectionEquality().hash(_hourlyForecast),
    sky,
    precipitation,
    observedAt,
  );

  /// Create a copy of WeatherEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherEntityImplCopyWith<_$WeatherEntityImpl> get copyWith =>
      __$$WeatherEntityImplCopyWithImpl<_$WeatherEntityImpl>(this, _$identity);
}

abstract class _WeatherEntity extends WeatherEntity {
  const factory _WeatherEntity({
    required final double temperature,
    required final int humidity,
    required final double windSpeed,
    required final String skyLabel,
    required final String precipitationLabel,
    required final List<HourlyForecastEntity> hourlyForecast,
    final WeatherSky? sky,
    final WeatherPrecipitation? precipitation,
    final DateTime? observedAt,
  }) = _$WeatherEntityImpl;
  const _WeatherEntity._() : super._();

  /// 현재 기온
  @override
  double get temperature;

  /// 현재 습도 백분율
  @override
  int get humidity;

  /// 현재 풍속 (m/s)
  @override
  double get windSpeed;

  /// 하늘 상태 서버 원문
  @override
  String get skyLabel;

  /// 강수 형태 서버 원문
  @override
  String get precipitationLabel;

  /// 시간대별 예보. 지나간 시각이 섞여 있으므로 [upcomingFrom]으로 거른다.
  @override
  List<HourlyForecastEntity> get hourlyForecast;

  /// 매핑된 하늘 상태 — 모르는 값이면 null
  @override
  WeatherSky? get sky;

  /// 매핑된 강수 형태 — 모르는 값이면 null
  @override
  WeatherPrecipitation? get precipitation;

  /// 관측 시각 (KST 벽시계)
  @override
  DateTime? get observedAt;

  /// Create a copy of WeatherEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherEntityImplCopyWith<_$WeatherEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
