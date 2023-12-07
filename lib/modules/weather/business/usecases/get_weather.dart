import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../data/models/weather_model.dart';
import '../repositories/weather_repository.dart';

// A use case class responsible for retrieving weather information.
class GetWeather {
  // Repository instance used for fetching weather data.
  final WeatherRepository repository;

  // Constructor that requires a WeatherRepository instance for initialization.
  GetWeather(this.repository);

  // Call method that initiates the weather data retrieval process.
  Future<Either<Failure, WeatherModel>> call(
      {required WeatherParams params}) async {
    return await repository.getWeather(params: params);
  }
}
