import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<Either<Failure, WeatherEntity>> call(
      {required WeatherParams params}) async {
    return await repository.getWeather(params: params);
  }
}
