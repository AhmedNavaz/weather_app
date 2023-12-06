import '../../../../core/errors/exceptions.dart';
import '../../../../utils/hive.dart';
import '../models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(WeatherModel weatherModel);

  Future<WeatherModel> getLastWeather(String key);

  Future<List<WeatherModel>> getAllWeathers();

  Future<void> deleteWeather(String key);

  Future<void> reOrderWeather(List<WeatherModel> weatherList);
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  WeatherLocalDataSourceImpl();

  @override
  Future<void> cacheWeather(WeatherModel weatherModel) async {
    try {
      List<WeatherModel> weatherList = await getAllWeathers();

      int existingIndex = weatherList.indexWhere(
        (existingWeather) => existingWeather.timezone == weatherModel.timezone,
      );

      if (existingIndex != -1) {
        weatherList[existingIndex] = weatherModel;
      } else {
        weatherList.add(weatherModel);
      }

      HiveDatabase.storeCache(HiveDatabase.weather,
          weatherList.map((weather) => weather.toJson()).toList());
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<WeatherModel> getLastWeather(String key) async {
    final weatherBox = HiveDatabase.getCache(key);
    if (weatherBox != null) {
      return WeatherModel.fromJson(weatherBox);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<WeatherModel>> getAllWeathers() async {
    try {
      final weatherBox = HiveDatabase.getCache(HiveDatabase.weather);
      List<WeatherModel> weatherList = [];
      for (var weather in weatherBox) {
        weatherList.add(WeatherModel.fromJson(weather));
      }
      if (weatherBox.isNotEmpty) {
        return weatherList;
      } else {
        throw CacheException();
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<void> deleteWeather(String key) async {
    var getPreviousWeather = await HiveDatabase.getCache(HiveDatabase.weather);
    for (int i = 0; i < getPreviousWeather.length; i++) {
      if (WeatherModel.fromJson(getPreviousWeather[i]).timezone == key) {
        getPreviousWeather.removeAt(i);
        break;
      }
    }
    HiveDatabase.storeCache(HiveDatabase.weather, getPreviousWeather);
  }

  @override
  Future<void> reOrderWeather(List<WeatherModel> weatherList) async {
    HiveDatabase.storeCache(HiveDatabase.weather,
        weatherList.map((weather) => weather.toJson()).toList());
  }
}
