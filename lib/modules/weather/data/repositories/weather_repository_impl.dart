import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../business/repositories/weather_repository.dart';
import '../datasources/weather_local_database.dart';
import '../datasources/weather_remote_database.dart';
import '../models/weather_model.dart';

// A concrete implementation of the WeatherRepository abstract class.
class WeatherRepositoryImpl implements WeatherRepository {
  // Instances of remote and local data sources, and network information.
  late final WeatherRemoteDataSource remoteDataSource;
  late final WeatherLocalDataSource localDataSource;
  late final NetworkInfo networkInfo;

  // Constructor for initializing the repository with required dependencies.
  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherModel>> getWeather(
      {required WeatherParams params}) async {
    // Check if the device is connected to the internet.
    if (await networkInfo.isConnected!) {
      try {
        // Attempt to fetch weather data from the remote data source.
        final remoteWeather = await remoteDataSource.getWeather(params: params);

        // Cache the remote weather data locally.
        localDataSource.cacheWeather(remoteWeather);

        // Return the fetched remote weather data.
        return Right(remoteWeather);
      } on ServerException {
        // Handle server-related exceptions and return a Left with a ServerFailure.
        return Left(ServerFailure(errorMessage: 'Server Error'));
      }
    } else {
      try {
        // Retrieve the last cached weather data for the provided city name.
        final localWeather =
            await localDataSource.getLastWeather(params.cityName);

        // Return the fetched local weather data.
        return Right(localWeather);
      } on CacheException {
        // Handle cache-related exceptions and return a Left with a CacheFailure.
        return Left(CacheFailure(errorMessage: 'No Cache Data Found'));
      }
    }
  }
}
