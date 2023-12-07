import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../utils/hive.dart';
import '../models/weather_model.dart';

// An abstract class defining the contract for local data source operations related to weather.
abstract class WeatherLocalDataSource {
  // Caches the provided weather model.
  Future<void> cacheWeather(WeatherModel weatherModel);

  // Retrieves the last cached weather using the specified key.
  Future<WeatherModel> getLastWeather(String key);

  // Retrieves all cached weather entries.
  Future<List<WeatherModel>> getAllWeathers();

  // Deletes the cached weather entry with the specified key.
  Future<void> deleteWeather(String key);

  // Reorders the list of cached weather entries.
  Future<void> reOrderWeather(List<WeatherModel> weatherList);
}

// A concrete implementation of the WeatherLocalDataSource abstract class.
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  // Default constructor for initializing the WeatherLocalDataSourceImpl.
  WeatherLocalDataSourceImpl();

  @override
  Future<void> cacheWeather(WeatherModel weatherModel) async {
    try {
      // Retrieve the list of existing weather entries.
      List<WeatherModel> weatherList = await getAllWeathers();

      // Find the index of the existing weather entry with the same timezone.
      int existingIndex = weatherList.indexWhere(
        (existingWeather) => existingWeather.timezone == weatherModel.timezone,
      );

      // Update the existing weather entry or add a new one to the list.
      if (existingIndex != -1) {
        weatherList[existingIndex] = weatherModel;
      } else {
        weatherList.add(weatherModel);
      }

      // Store the updated weather list in the cache.
      HiveDatabase.storeCache(
        HiveDatabase.weather,
        weatherList.map((weather) => weather.toJson()).toList(),
      );
    } catch (e) {
      // Handle exceptions and print debug information in debug mode.
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<WeatherModel> getLastWeather(String key) async {
    // Retrieve the weather entry with the specified key from the cache.
    final weatherBox = HiveDatabase.getCache(key);
    if (weatherBox != null) {
      return WeatherModel.fromJson(weatherBox);
    } else {
      // Throw a CacheException if the weather entry is not found.
      throw CacheException();
    }
  }

  @override
  Future<List<WeatherModel>> getAllWeathers() async {
    try {
      // Retrieve the weather entries from the cache.
      final weatherBox = HiveDatabase.getCache(HiveDatabase.weather);
      List<WeatherModel> weatherList = [];
      for (var weather in weatherBox) {
        weatherList.add(WeatherModel.fromJson(weather));
      }

      // Check if the weather entries list is not empty.
      if (weatherBox.isNotEmpty) {
        return weatherList;
      } else {
        // Throw a CacheException if no weather entries are found.
        throw CacheException();
      }
    } catch (e) {
      // Handle exceptions and return an empty list in case of an error.
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  @override
  Future<void> deleteWeather(String key) async {
    // Retrieve the list of previous weather entries.
    var getPreviousWeather = await HiveDatabase.getCache(HiveDatabase.weather);

    // Iterate through the list to find and remove the weather entry with the specified key.
    for (int i = 0; i < getPreviousWeather.length; i++) {
      if (WeatherModel.fromJson(getPreviousWeather[i]).timezone == key) {
        getPreviousWeather.removeAt(i);
        break;
      }
    }

    // Store the updated weather list in the cache.
    HiveDatabase.storeCache(HiveDatabase.weather, getPreviousWeather);
  }

  @override
  Future<void> reOrderWeather(List<WeatherModel> weatherList) async {
    // Store the reordered weather list in the cache.
    HiveDatabase.storeCache(
      HiveDatabase.weather,
      weatherList.map((weather) => weather.toJson()).toList(),
    );
  }
}
