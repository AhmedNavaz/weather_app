import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/business/usecases/get_weather.dart';
import 'package:weather_app/modules/weather/data/datasources/weather_local_database.dart';
import 'package:weather_app/modules/weather/data/models/weather_model.dart';
import 'package:weather_app/modules/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/modules/weather/presentation/providers/settings_provider.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/params/params.dart';
import '../../../../utils/helper.dart';
import '../../data/datasources/weather_remote_database.dart';

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

  WeatherModel? _weatherModel;
  bool _isAppBarPinned = false;
  final double _headerHeight = 27.5;
  List<WeatherModel> _cities = [];
  String _myLocation = '';

  late ScrollController _scrollController;

  // getters
  bool get isAppBarPinned => _isAppBarPinned;

  double get headerHeight => _headerHeight;

  List<WeatherModel> get cities => _cities;

  ScrollController get scrollController => _scrollController;

  WeatherModel? get weatherModel => _weatherModel;

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
            lat: weather.lat!,
            lon: weather.lon!,
            cityName: weather.timezone!,
          ));
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
        _weatherModel = weather;
        addCard(_weatherModel!);
        notifyListeners();
      },
    );
  }

  Future<void> showAddNewWeatherSheet(
      BuildContext context, String cityName) async {
    _weatherModel = WeatherModel(
      timezone: cityName,
      current: Current(
        temp: 0,
        weather: [Weather(description: 'Clear')],
        windSpeed: 0,
        windGust: 0,
        humidity: 0,
        dewPoint: 0,
      ),
      daily: [
        Daily(
            temp: Temp(max: 0, min: 0),
            weather: [Weather(description: 'Clear')],
            summary: 'Fetching')
      ],
      hourly: [
        Hourly(
          temp: 0,
          weather: [Weather(description: 'Clear')],
        )
      ],
    );
    notifyListeners();
    bool? cancel = await Helper.newCityWeatherSheet(context);
    if (cancel!) {
      int index = _cities.indexWhere((element) => element.timezone == cityName);
      removeCard(index);
      notifyListeners();
    }
  }

  void addCard(WeatherModel newWeatherModel) {
    bool cityExists = false;
    for (int i = 0; i < _cities.length; i++) {
      if (_cities[i].timezone == newWeatherModel.timezone) {
        _cities[i] = newWeatherModel;
        cityExists = true;
        break;
      }
    }
    if (!cityExists) {
      _cities.add(newWeatherModel);
    }
    notifyListeners();
  }

  void reOrderCards(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final WeatherModel card = _cities.removeAt(oldIndex);
    _cities.insert(newIndex, card);
    WeatherLocalDataSourceImpl().reOrderWeather(_cities);
    notifyListeners();
  }

  void removeCard(int index) {
    WeatherLocalDataSourceImpl().deleteWeather(_cities[index].timezone!);
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

  String getBackgroundImageCard(String main, DateTime time) {
    bool isDay = time.hour > 6 && time.hour < 18;
    switch (main.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return isDay ? cloudyDay : cloudyNight;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return isDay ? rainyDay : rainyNight;
      case 'clear':
        return isDay ? sunnyDay : clearNight;
      default:
        return 'assets/images/day/clear.jpg';
    }
  }

  String getBackgroundImageSheet(String main, DateTime time) {
    bool isDay = time.hour > 6 && time.hour < 18;
    switch (main.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return isDay ? cloudyDay : cloudyNight;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return raining;
      case 'thunderstorm':
        return thunderstorm;
      case 'clear':
        return isDay ? sunnyDay : clearNight;
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
