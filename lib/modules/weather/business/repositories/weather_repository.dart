import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../data/models/weather_model.dart';

// An abstract class defining the contract for the WeatherRepository.
abstract class WeatherRepository {
  // Retrieves weather information based on the provided parameters.
  Future<Either<Failure, WeatherModel>> getWeather(
      {required WeatherParams params});
}
