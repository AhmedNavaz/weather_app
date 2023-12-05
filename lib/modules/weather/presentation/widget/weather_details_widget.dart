import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/business/entities/weather_entity.dart';
import 'package:weather_app/modules/weather/presentation/extension/string_extention.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';
import 'package:weather_app/modules/weather/presentation/widget/wind_card_wdiget.dart';

import '../../../../core/constants/constants.dart';
import 'hourly_card_widget.dart';
import 'humidity_card_widget.dart';

class WeatherDetailsWidget extends StatelessWidget {
  const WeatherDetailsWidget({super.key, required this.weatherEntity});

  final WeatherEntity weatherEntity;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                weatherEntity.city.name,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                '${weatherEntity.temperature}$degreeSymbol',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                weatherEntity.description.capitalizeByWord(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 5),
              Text(
                'H:${weatherEntity.maxTemperature}$degreeSymbol  L:${weatherEntity.minTemperature}$degreeSymbol',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 40),
              homeProvider.weatherEntity != null
                  ? HourlyCardWidget(
                      weatherEntity: weatherEntity,
                      height: size.height * 0.09,
                    )
                  : const SizedBox(),
              const SizedBox(height: 5),
              homeProvider.weatherEntity != null
                  ? Row(
                      children: [
                        WindCardWidget(
                          height: size.height * 0.18,
                          windSpeed: weatherEntity.windSpeed,
                          windGusts: weatherEntity.windGusts,
                        ),
                        const SizedBox(width: 5),
                        HumidityCardWidget(
                          height: size.height * 0.18,
                          humidity: weatherEntity.humidity,
                          dewPoint: weatherEntity.dewPoint,
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    });
  }
}
