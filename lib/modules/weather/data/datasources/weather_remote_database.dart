import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/params.dart';
import '../models/weather_model.dart';

// An abstract class defining the contract for remote data source operations related to weather.
abstract class WeatherRemoteDataSource {
  // Retrieves weather information based on the provided parameters.
  Future<WeatherModel> getWeather({required WeatherParams params});
}

// A concrete implementation of the WeatherRemoteDataSource abstract class.
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  // Dio instance for making HTTP requests.
  final Dio dio;

  // Constructor that requires a Dio instance for initialization.
  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<WeatherModel> getWeather({required WeatherParams params}) async {
    try {
      // Retrieve the location information from the provided city name.
      List<Location> locations = await locationFromAddress(params.cityName);

      // Fetch weather data using the obtained latitude, longitude, and city name.
      return _fetchWeather(
          locations[0].latitude, locations[0].longitude, params.cityName);
    } catch (_) {
      // Throw a ServerException in case of any errors during the process.
      throw ServerException();
    }
  }

  // Internal method to make the actual API request and parse the response.
  Future<WeatherModel> _fetchWeather(
      double lat, double lon, String cityName) async {
    // Make a GET request to the weather API endpoint using Dio.
    final response = await dio.get(
      weatherUrl,
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'units': 'metric',
        'appid': apiKey,
      },
    );

    // Check the HTTP status code and handle the response accordingly.
    if (response.statusCode == 200) {
      // Parse the response and customize the WeatherModel with the city name.
      WeatherModel weatherModel = WeatherModel.fromJson(response.data);
      weatherModel.timezone = cityName;
      return weatherModel;
    } else {
      // Throw a ServerException if the API request is not successful.
      throw ServerException();
    }
  }
}
