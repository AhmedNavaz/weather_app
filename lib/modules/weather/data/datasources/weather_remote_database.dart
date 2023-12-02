import 'package:dio/dio.dart';

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
    String apiKey = '83c58183aacfc5dea87c7266d44ad0f5';
    String lat = '35';
    String lon = '139';
    final response = await dio.get(
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey');

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
