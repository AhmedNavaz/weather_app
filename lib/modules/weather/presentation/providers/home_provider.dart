import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/business/entities/weather_entity.dart';
import 'package:weather_app/modules/weather/business/usecases/get_weather.dart';
import 'package:weather_app/modules/weather/data/datasources/weather_local_database.dart';
import 'package:weather_app/modules/weather/data/models/weather_model.dart';
import 'package:weather_app/modules/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/modules/weather/presentation/providers/settings_provider.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/params/params.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/hive.dart';
import '../../business/entities/city_entity.dart';
import '../../data/datasources/weather_remote_database.dart';
import '../widget/weather_details_widget.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    getAllWeathers();
    getCurrentLocation();
    _scrollController = ScrollController()
      ..addListener(() {
        _isAppBarPinned = _scrollController.hasClients &&
            _scrollController.offset > _headerHeight;
        notifyListeners();
      });
  }

  // variables

  WeatherEntity? _weatherEntity;
  bool _isAppBarPinned = false;
  final double _headerHeight = 27.5;
  List<WeatherEntity> _cities = [];
  String _myLocation = '';

  late ScrollController _scrollController;

  // getters
  bool get isAppBarPinned => _isAppBarPinned;

  double get headerHeight => _headerHeight;

  List<WeatherEntity> get cities => _cities;

  ScrollController get scrollController => _scrollController;

  WeatherEntity? get weatherEntity => _weatherEntity;

  String get myLocation => _myLocation;

  // functions
  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double lon = position.longitude;
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lon);
      _myLocation = placeMarks[0].locality.toString();
      if (_cities.isEmpty) {
        eitherFailureOrWeather(
            WeatherParams(lat: lat, lon: lon, cityName: _myLocation));
      } else {
        for (var weather in _cities) {
          eitherFailureOrWeather(WeatherParams(
              lat: weather.city.lat,
              lon: weather.city.lon,
              cityName: weather.city.name));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllWeathers() async {
    _cities = await WeatherLocalDataSourceImpl().getAllWeathers();
    notifyListeners();
  }

  Future<void> eitherFailureOrWeather(WeatherParams params) async {
    WeatherRepositoryImpl repositoryImpl = WeatherRepositoryImpl(
      remoteDataSource: WeatherRemoteDataSourceImpl(dio: Dio()),
      localDataSource: WeatherLocalDataSourceImpl(),
      networkInfo: NetworkInfoImpl(connectionChecker: Connectivity()),
    );
    final failureOrWeather = await GetWeather(repositoryImpl).call(
        params: WeatherParams(
            lat: params.lat, lon: params.lon, cityName: params.cityName));
    failureOrWeather.fold(
      (failure) => null,
      (weather) {
        _weatherEntity = weather;
        addCard(_weatherEntity!);
        notifyListeners();
      },
    );
  }

  void showAddNewWeatherSheet(BuildContext context, String cityName) {
    _weatherEntity = null;
    Helper.newCityWeatherSheet(
      context,
      _weatherEntity == null
          ? WeatherEntity(
              city: CityEntity(
                name: cityName,
                time: 1,
                timezoneOffset: 0,
                lat: 0,
                lon: 0,
              ),
              temperature: 0,
              maxTemperature: 0,
              minTemperature: 0,
              condition: '',
              description: '',
              humidity: 0,
              windSpeed: 0,
              windGusts: 0,
              dewPoint: 0,
              hourly: [],
              daily: [],
            )
          : _weatherEntity!,
      _weatherEntity != null ? true : false,
    );
  }

  void addCard(WeatherEntity newWeatherEntity) {
    bool cityExists = false;
    for (int i = 0; i < _cities.length; i++) {
      if (_cities[i].city.name == newWeatherEntity.city.name) {
        _cities[i] = newWeatherEntity;
        cityExists = true;
        break;
      }
    }
    if (!cityExists) {
      _cities.add(newWeatherEntity);
    }
    notifyListeners();
  }

  void reOrderCards(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final WeatherEntity card = _cities.removeAt(oldIndex);
    _cities.insert(newIndex, card);
    WeatherLocalDataSourceImpl().reOrderWeather(_cities);
    notifyListeners();
  }

  void removeCard(int index) {
    WeatherLocalDataSourceImpl().deleteWeather(_cities[index].city.name);
    _cities.removeAt(index);
    notifyListeners();
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      30,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  String getBackgroundImage(String main, DateTime time) {
    bool isDay = time.hour > 6 && time.hour < 18;
    String dayOrNight = isDay ? 'day' : 'night';
    switch (main.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/images/$dayOrNight/cloudy.jpg';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return 'assets/images/$dayOrNight/rainy.jpg';
      case 'clear':
        return 'assets/images/$dayOrNight/clear.jpg';
      default:
        return 'assets/images/day/clear.jpg';
    }
  }

  int getTemperatureInScale(BuildContext context, int temperature) {
    TemperatureScale temperatureScale =
        context.watch<SettingsProvider>().temperatureScale;
    int newTemperature = temperatureScale == TemperatureScale.celsius
        ? temperature
        : Helper.celsiusToFahrenheit(temperature);
    return newTemperature;
  }
}
