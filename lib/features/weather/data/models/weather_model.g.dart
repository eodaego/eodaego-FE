// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HourlyWeatherModelImpl _$$HourlyWeatherModelImplFromJson(
  Map<String, dynamic> json,
) => _$HourlyWeatherModelImpl(
  datetime: json['datetime'] as String?,
  temperature: (json['temperature'] as num?)?.toDouble() ?? 0,
  precipitationProbability:
      (json['precipitationProbability'] as num?)?.toInt() ?? 0,
  precipitationType: json['precipitationType'] as String? ?? '',
  skyCondition: json['skyCondition'] as String? ?? '',
);

Map<String, dynamic> _$$HourlyWeatherModelImplToJson(
  _$HourlyWeatherModelImpl instance,
) => <String, dynamic>{
  'datetime': instance.datetime,
  'temperature': instance.temperature,
  'precipitationProbability': instance.precipitationProbability,
  'precipitationType': instance.precipitationType,
  'skyCondition': instance.skyCondition,
};

_$WeatherModelImpl _$$WeatherModelImplFromJson(Map<String, dynamic> json) =>
    _$WeatherModelImpl(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0,
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 0,
      precipitationType: json['precipitationType'] as String? ?? '',
      skyCondition: json['skyCondition'] as String? ?? '',
      observedAt: json['observedAt'] as String?,
      hourlyForecast:
          (json['hourlyForecast'] as List<dynamic>?)
              ?.map(
                (e) => HourlyWeatherModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <HourlyWeatherModel>[],
    );

Map<String, dynamic> _$$WeatherModelImplToJson(_$WeatherModelImpl instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'precipitationType': instance.precipitationType,
      'skyCondition': instance.skyCondition,
      'observedAt': instance.observedAt,
      'hourlyForecast': instance.hourlyForecast,
    };
