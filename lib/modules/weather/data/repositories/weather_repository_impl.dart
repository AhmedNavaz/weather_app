import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../business/repositories/weather_repository.dart';
import '../datasources/weather_local_database.dart';
import '../datasources/weather_remote_database.dart';
import '../models/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  late final WeatherRemoteDataSource remoteDataSource;
  late final WeatherLocalDataSource localDataSource;
  late final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherModel>> getWeather(
      {required WeatherParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteWeather = await remoteDataSource.getWeather(params: params);
        localDataSource.cacheWeather(remoteWeather);
        return Right(remoteWeather);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'Server Error'));
      }
    } else {
      try {
        final localWeather = await localDataSource.getLastWeather();
        return Right(localWeather);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'No Cache Data Found'));
      }
    }
  }
}
