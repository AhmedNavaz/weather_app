import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather({required WeatherParams params});
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<WeatherModel> getWeather({required WeatherParams params}) async {
    try {
      List<Location> locations = await locationFromAddress(params.cityName);
      return _fetchWeather(
          locations[0].latitude, locations[0].longitude, params.cityName);
    } catch (_) {
      throw ServerException();
    }
  }

  Future<WeatherModel> _fetchWeather(
      double lat, double lon, String cityName) async {
    final response = await dio.get(
      weatherUrl,
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'units': 'metric',
        'appid': apiKey,
      },
    );
    if (response.statusCode == 200) {
      WeatherModel weatherModel = WeatherModel.fromJson(response.data);
      weatherModel.city.name = cityName;
      weatherModel.timezone = cityName;
      return weatherModel;
    } else {
      throw ServerException();
    }
  }
}
