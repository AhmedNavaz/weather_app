import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/core/constants/constants.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';
import 'package:weather_app/modules/weather/presentation/widget/weather_details_widget.dart';

import '../modules/weather/data/models/weather_model.dart';

class Helper {
  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Widget divider(BuildContext context,
      {double height = 30, double horizontalPadding = 4}) {
    return Divider(
      color: Colors.white.withOpacity(0.25),
      thickness: 0.5,
      indent: horizontalPadding,
      endIndent: horizontalPadding,
      height: height,
    );
  }

  static Future<bool?> newCityWeatherSheet(BuildContext context) async {
    bool? result = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        String backgroundImage = cloudyDay;
        return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
          WeatherModel weatherModel = homeProvider.weatherModel!;
          if (weatherModel.current!.dt != null) {
            DateTime localTime = Helper.convertToLocalTime(
              weatherModel.current!.dt!,
              weatherModel.timezoneOffset!,
            );
            backgroundImage = context
                .watch<HomeProvider>()
                .getBackgroundImageCard(
                    weatherModel.current!.weather!.first.main!, localTime);
          }
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, true);
              return false;
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: 95.h,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('Add',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                      ],
                    ),
                  ),
                  WeatherDetailsWidget(weatherModel: weatherModel),
                ],
              ),
            ),
          );
        });
      }),
    );
    return result ?? true;
  }

  static DateTime convertToLocalTime(int dt, int timezoneOffset) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    DateTime utcDateTime = dateTime.toUtc();
    DateTime localDateTime = utcDateTime.add(Duration(seconds: timezoneOffset));
    return localDateTime;
  }

  static int celsiusToFahrenheit(int celsius) {
    return ((celsius * 9 / 5) + 32).round();
  }
}
