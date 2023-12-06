import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/presentation/extension/string_extention.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';
import 'package:weather_app/modules/weather/presentation/widget/wind_card_wdiget.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/constants.dart';
import '../../data/models/weather_model.dart';
import 'hourly_card_widget.dart';
import 'humidity_card_widget.dart';

class WeatherDetailsWidget extends StatelessWidget {
  const WeatherDetailsWidget({super.key, required this.weatherModel});

  final WeatherModel weatherModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 05.h),
              Text(
                weatherModel.timezone!,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                '${homeProvider.getTemperatureInScale(context, weatherModel.current!.temp!)}$degreeSymbol',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                weatherModel.current!.weather!.first.description!
                    .capitalizeByWord(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'H:${homeProvider.getTemperatureInScale(context, weatherModel.daily!.first.temp!.max!)}$degreeSymbol  L:${homeProvider.getTemperatureInScale(context, weatherModel.daily!.first.temp!.min!)}$degreeSymbol',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 4.h),
              HourlyCardWidget(
                weatherModel: weatherModel,
                height: 10.4.h,
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  WindCardWidget(
                    height: 19.h,
                    windSpeed: weatherModel.current!.windSpeed!,
                    windGusts: weatherModel.current!.windGust ?? 0,
                  ),
                  SizedBox(width: 2.w),
                  HumidityCardWidget(
                    height: 19.h,
                    humidity: weatherModel.current!.humidity!,
                    dewPoint: weatherModel.current!.dewPoint!,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
