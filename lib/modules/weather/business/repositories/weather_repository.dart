import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../data/models/weather_model.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherModel>> getWeather(
      {required WeatherParams params});
}
