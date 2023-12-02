import '../../business/entities/city_entity.dart';
import '../../business/entities/weather_entity.dart';
import 'city_model.dart';

class WeatherModel extends WeatherEntity {
  WeatherModel({
    required CityEntity city,
    required double temperature,
    required String description,
    required double humidity,
    required double windSpeed,
  }) : super(
          city: city,
          temperature: temperature,
          description: description,
          humidity: humidity,
          windSpeed: windSpeed,
        );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: CityModel.fromJson(json['city']),
      temperature: json['temperature'],
      description: json['description'],
      humidity: json['humidity'],
      windSpeed: json['wind_speed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperature,
      'description': description,
      'humidity': humidity,
      'wind_speed': windSpeed,
    };
  }
}
