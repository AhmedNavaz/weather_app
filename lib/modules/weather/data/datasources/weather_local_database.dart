import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<void> cacheWeather(WeatherModel weatherModel);

  Future<WeatherModel> getLastWeather();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final HiveInterface hive;

  WeatherLocalDataSourceImpl({required this.hive});

  @override
  Future<void> cacheWeather(WeatherModel weatherModel) async {
    final box = await hive.openBox('weather');
    await box.put('weather', weatherModel.toJson());
  }

  @override
  Future<WeatherModel> getLastWeather() async {
    final box = await hive.openBox('weather');
    if (box.isNotEmpty) {
      return WeatherModel.fromJson(box.get('weather'));
    } else {
      throw CacheException();
    }
  }
}
