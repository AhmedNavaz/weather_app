import 'package:flutter/material.dart';
import 'package:weather_app/utils/hive.dart';

// Enum to represent temperature scales.
enum TemperatureScale { celsius, fahrenheit }

// Provider class for managing application settings.
class SettingsProvider extends ChangeNotifier {
  // Variables
  TemperatureScale _temperatureScale = TemperatureScale.celsius;
  bool _isEditing = false;

  // Getters
  TemperatureScale get temperatureScale => _temperatureScale;
  bool get isEditing => _isEditing;

  // Functions
  // Constructor to initialize the temperature scale from cached data.
  SettingsProvider() {
    var data = HiveDatabase.getCache(HiveDatabase.temperatureUnit);
    if (data != null) {
      _temperatureScale =
          data == 0 ? TemperatureScale.celsius : TemperatureScale.fahrenheit;
    }
  }

  // Change the temperature scale and store the updated value in the cache.
  void changeTemperatureScale(TemperatureScale scale) {
    HiveDatabase.storeCache(HiveDatabase.temperatureUnit, scale.index);
    _temperatureScale = scale;
    notifyListeners();
  }

  // Change the editing state of the settings.
  void changeEditingState(bool state) {
    _isEditing = state;
    notifyListeners();
  }
}
