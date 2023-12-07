import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/presentation/extension/string_extention.dart';
import 'package:weather_app/utils/helper.dart';

import '../../../../core/params/params.dart';
import 'home_provider.dart';

// Provider class for managing the state and logic of the search bar.
class SearchBarProvider extends ChangeNotifier {
  // Variables

  final TextEditingController _searchbarController = TextEditingController();
  String _searchingCity = '';
  final FocusNode _searchbarFocusNode = FocusNode();
  bool _isSearching = false;

  // Getters

  TextEditingController get searchbarController => _searchbarController;
  FocusNode get searchbarFocusNode => _searchbarFocusNode;
  bool get isSearching => _isSearching;

  // Functions

  // Handle changes in the search bar input.
  void onChangeSearch(value) {
    _searchingCity = value;
    notifyListeners();
  }

  // Change the state of searching and clear the search bar when not searching.
  void changeSearchingState(bool state) {
    _isSearching = state;
    if (state == false) {
      _searchbarController.clear();
      _searchbarFocusNode.unfocus();
    }
    notifyListeners();
  }

  // Handle the submission of a search query.
  Future<void> onSearchSubmitted(BuildContext context) async {
    context.read<HomeProvider>().scrollToTop();
    changeSearchingState(false);
    notifyListeners();
    try {
      // Get the location from the provided search query.
      List<Location> locations =
          await locationFromAddress(_searchingCity.trim());

      // Show the bottom sheet for adding new weather data and fetch weather details.
      if (context.mounted) {
        context.read<HomeProvider>().showAddNewWeatherSheet(
              context,
              _searchingCity.capitalizeByWord(),
            );
        context.read<HomeProvider>().eitherFailureOrWeather(
              WeatherParams(
                lat: locations[0].latitude,
                lon: locations[0].longitude,
                cityName: _searchingCity.capitalizeByWord(),
              ),
            );
      }
    } catch (e) {
      // Handle exceptions and print debug information in debug mode.
      if (kDebugMode) {
        print(e);
      }
      if (context.mounted) {
        Helper.showAlertDialog(context, 'Error', 'Location not found');
      }
    }
  }
}
