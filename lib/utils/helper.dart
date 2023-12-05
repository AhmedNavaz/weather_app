import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/business/entities/weather_entity.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';
import 'package:weather_app/modules/weather/presentation/widget/weather_details_widget.dart';

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
      color: Colors.white.withOpacity(0.5),
      thickness: 0.5,
      indent: horizontalPadding,
      endIndent: horizontalPadding,
      height: height,
    );
  }

  static Future<bool?> newCityWeatherSheet(
      BuildContext context, WeatherEntity weatherEntity, bool refresh) async {
    bool? result = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
          if (refresh) {
            setState(() {});
          }
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/night/cloudy.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Add',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    )),
                      ),
                    ],
                  ),
                ),
                WeatherDetailsWidget(weatherEntity: weatherEntity),
              ],
            ),
          );
        });
      }),
    );
    return result;
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
