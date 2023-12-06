import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../data/models/weather_model.dart';
import '../repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<Either<Failure, WeatherModel>> call(
      {required WeatherParams params}) async {
    return await repository.getWeather(params: params);
  }
}
