import 'package:flutter/material.dart';
import 'package:weather_app/utils/hive.dart';

enum TemperatureScale { celsius, fahrenheit }

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    var data = HiveDatabase.getCache(HiveDatabase.temperatureUnit);
    if (data != null) {
      _temperatureScale =
          data == 0 ? TemperatureScale.celsius : TemperatureScale.fahrenheit;
    }
  }

  // variables
  TemperatureScale _temperatureScale = TemperatureScale.celsius;
  bool _isEditing = false;

  // getters
  TemperatureScale get temperatureScale => _temperatureScale;
  bool get isEditing => _isEditing;

  // functions
  void changeTemperatureScale(TemperatureScale scale) {
    HiveDatabase.storeCache(HiveDatabase.temperatureUnit, scale.index);
    _temperatureScale = scale;
    notifyListeners();
  }

  void changeEditingState(bool state) {
    _isEditing = state;
    notifyListeners();
  }
}
