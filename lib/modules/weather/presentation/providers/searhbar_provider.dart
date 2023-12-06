import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/presentation/extension/string_extention.dart';
import 'package:weather_app/utils/helper.dart';

import '../../../../core/params/params.dart';
import 'home_provider.dart';

class SearchBarProvider extends ChangeNotifier {
  // variables

  final TextEditingController _searchbarController = TextEditingController();

  String _searchingCity = '';
  final FocusNode _searchbarFocusNode = FocusNode();
  bool _isSearching = false;

  // getters
  TextEditingController get searchbarController => _searchbarController;
  FocusNode get searchbarFocusNode => _searchbarFocusNode;
  bool get isSearching => _isSearching;

  // functions

  void onChangeSearch(value) {
    _searchingCity = value;
    notifyListeners();
  }

  void changeSearchingState(bool state) {
    _isSearching = state;
    if (state == false) {
      _searchbarController.clear();
      _searchbarFocusNode.unfocus();
    }
    notifyListeners();
  }

  Future<void> onSearchSubmitted(BuildContext context) async {
    context.read<HomeProvider>().scrollToTop();
    changeSearchingState(false);
    notifyListeners();
    try {
      print(_searchingCity);
      List<Location> locations =
          await locationFromAddress(_searchingCity.trim());
      print(locations[0].longitude);
      print(locations[0].latitude);
      context
          .read<HomeProvider>()
          .showAddNewWeatherSheet(context, _searchingCity.capitalizeByWord());
      context.read<HomeProvider>().eitherFailureOrWeather(
            WeatherParams(
              lat: locations[0].latitude,
              lon: locations[0].longitude,
              cityName: _searchingCity.capitalizeByWord(),
            ),
          );
    } catch (e) {
      print(e);
      Helper.showAlertDialog(context, 'Error', 'Location not found');
    }
  }
}
