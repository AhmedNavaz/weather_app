import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../utils/helper.dart';
import '../../business/entities/weather_entity.dart';

class HourlyCardWidget extends StatelessWidget {
  const HourlyCardWidget({
    super.key,
    required this.weatherEntity,
    required this.height,
    this.verticalPadding = 12,
    this.horizontalPadding = 10,
  });

  final WeatherEntity weatherEntity;
  final double height;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  weatherEntity.daily![0].summary!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Helper.divider(context, horizontalPadding: 10),
              SizedBox(
                height: height,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: weatherEntity.hourly!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == weatherEntity.hourly!.length) {
                      return SizedBox(width: horizontalPadding);
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: horizontalPadding),
                      child: Column(
                        children: [
                          Text(
                            index == 0
                                ? 'Now'
                                : DateFormat('h a').format(
                                    Helper.convertToLocalTime(
                                        weatherEntity.hourly![index].dt!,
                                        weatherEntity.city.timezoneOffset),
                                  ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 7.5),
                          Image.network(
                            '$weatherIconUrl${weatherEntity.hourly![index].weather![0].icon}.png',
                            width: 30,
                          ),
                          const SizedBox(height: 7.5),
                          Text(
                              '${weatherEntity.hourly![index].temp!.round()}$degreeSymbol',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
