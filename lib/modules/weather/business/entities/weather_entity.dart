import '../../data/models/weather_model.dart';
import 'city_entity.dart';

class WeatherEntity {
  final CityEntity city;
  final int temperature;
  final int maxTemperature;
  final int minTemperature;
  final String condition;
  final String description;
  final double humidity;
  final double dewPoint;
  final double windSpeed;

  final double windGusts;

  List<Hourly>? hourly;
  List<Daily>? daily;

  WeatherEntity({
    required this.city,
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.dewPoint,
    required this.windSpeed,
    required this.windGusts,
    required this.hourly,
    required this.daily,
  });
}
