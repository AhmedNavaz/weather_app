import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../utils/helper.dart';
import '../../data/models/weather_model.dart';

class HourlyCardWidget extends StatelessWidget {
  HourlyCardWidget({
    super.key,
    required this.weatherModel,
    required this.height,
  })  : verticalPadding = 1.3.h,
        horizontalPadding = 1.1.h;

  final WeatherModel weatherModel;
  final double height;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = context.read<HomeProvider>();
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
                  weatherModel.daily![0].summary!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Helper.divider(context, horizontalPadding: 2.5.w, height: 3.h),
              SizedBox(
                height: height,
                child: weatherModel.daily![0].summary == 'Fetching'
                    ? const SizedBox()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: weatherModel.hourly!.length + 1,
                        itemBuilder: (context, index) {
                          if (index == weatherModel.hourly!.length) {
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
                                              weatherModel.hourly![index].dt!,
                                              weatherModel.timezoneOffset!),
                                        ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 7.5),
                                Image.network(
                                  '$weatherIconUrl${weatherModel.hourly![index].weather![0].icon}.png',
                                  width: 30,
                                ),
                                const SizedBox(height: 7.5),
                                Text(
                                    '${homeProvider.getTemperatureInScale(context, weatherModel.hourly![index].temp!)}$degreeSymbol',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
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
