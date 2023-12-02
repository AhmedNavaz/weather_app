import 'city_entity.dart';

class WeatherEntity {
  final CityEntity city;
  final double temperature;
  final String description;
  final double humidity;
  final double windSpeed;

  WeatherEntity({
    required this.city,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });
}
