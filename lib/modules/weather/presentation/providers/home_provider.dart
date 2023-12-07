import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

// Provider class for managing the state and logic of the home page.
class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    // Initialization logic for the provider.
    getAllWeathers();
    getCurrentLocation();
    syncData();
    _scrollController = ScrollController()
      ..addListener(() {
        _isAppBarPinned = _scrollController.hasClients &&
            _scrollController.offset > _headerHeight;
        notifyListeners();
      });
  }

  // Variables
  WeatherModel? _weatherModel;
  bool _isAppBarPinned = false;
  bool _isLoading = true;
  final double _headerHeight = 27.5;
  List<WeatherModel> _cities = [];
  String _myLocation = '';

  late ScrollController _scrollController;

  // Getters
  bool get isAppBarPinned => _isAppBarPinned;
  double get headerHeight => _headerHeight;
  List<WeatherModel> get cities => _cities;
  ScrollController get scrollController => _scrollController;
  WeatherModel? get weatherModel => _weatherModel;
  String get myLocation => _myLocation;
  bool get isLoading => _isLoading;

  // Functions

  // Fetch the current device location.
  Future<void> getCurrentLocation() async {
    try {
      // Check and request location permission if needed.
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      // Retrieve the current device position.
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double lon = position.longitude;

      // Get the locality (city name) from the obtained coordinates.
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lon);
      _myLocation = placeMarks[0].locality.toString();

      // Fetch weather data for the current location or for saved cities.
      if (_cities.isEmpty) {
        await eitherFailureOrWeather(
            WeatherParams(lat: lat, lon: lon, cityName: _myLocation));
      } else {
        for (var weather in _cities) {
          await eitherFailureOrWeather(WeatherParams(
            lat: weather.lat!,
            lon: weather.lon!,
            cityName: weather.timezone!,
          ));
        }
      }

      // Update loading state and notify listeners.
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Handle exceptions and print debug information in debug mode.
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Periodically sync weather data every 15 minutes.
  void syncData() {
    Timer.periodic(const Duration(minutes: 15), (timer) {
      _isLoading = true;
      notifyListeners();
      getCurrentLocation();
    });
  }

  // Fetch and update the list of saved weather data.
  Future<void> getAllWeathers() async {
    _cities = await WeatherLocalDataSourceImpl().getAllWeathers();
    notifyListeners();
  }

  // Fetch weather data based on provided parameters.
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

  // Show the bottom sheet for adding new weather data.
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

  // Add or update a weather card in the list.
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

  // Reorder weather cards based on user interaction.
  void reOrderCards(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final WeatherModel card = _cities.removeAt(oldIndex);
    _cities.insert(newIndex, card);
    WeatherLocalDataSourceImpl().reOrderWeather(_cities);
    notifyListeners();
  }

  // Remove a weather card from the list.
  void removeCard(int index) {
    WeatherLocalDataSourceImpl().deleteWeather(_cities[index].timezone!);
    _cities.removeAt(index);
    notifyListeners();
  }

  // Scroll to the top of the weather list.
  void scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  // Scroll to the bottom a little bit, so that the bottom sheet is visible.
  void scrollToBottom() {
    _scrollController.animateTo(
      30,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  // Determine the background image for a weather card based on weather conditions.
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
        return 'assets/images/day/sunny.jpg';
    }
  }

  // Determine the background image for the bottom sheet based on weather conditions.
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
        return 'assets/images/day/sunny.jpg';
    }
  }

  // Convert temperature to the selected temperature scale.
  int getTemperatureInScale(BuildContext context, int temperature) {
    TemperatureScale temperatureScale =
        context.watch<SettingsProvider>().temperatureScale;
    int newTemperature = temperatureScale == TemperatureScale.celsius
        ? temperature
        : Helper.celsiusToFahrenheit(temperature);
    return newTemperature;
  }
}
