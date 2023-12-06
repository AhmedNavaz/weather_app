import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/core/constants/constants.dart';
import 'package:weather_app/modules/weather/presentation/extension/string_extention.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';
import 'package:weather_app/modules/weather/presentation/providers/settings_provider.dart';

import '../../../../utils/helper.dart';
import '../../data/models/weather_model.dart';
import '../pages/weather_details_page.dart';

class WeatherCardWidget extends StatelessWidget {
  const WeatherCardWidget(
      {super.key, required this.index, required this.weatherModel});

  final int index;
  final WeatherModel weatherModel;

  @override
  Widget build(BuildContext context) {
    DateTime localTime = Helper.convertToLocalTime(
      weatherModel.current!.dt!,
      weatherModel.timezoneOffset!,
    );

    return Consumer2<HomeProvider, SettingsProvider>(
        builder: (context, homeProvider, settingsProvider, child) {
      String condition = weatherModel.current!.weather!.first.main!;
      String backgroundImage = homeProvider.getBackgroundImageCard(
        condition,
        localTime,
      );
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5.5.w),
        child: Slidable(
          key: key,
          enabled: index != 0,
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {
              homeProvider.removeCard(index);
            }),
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    homeProvider.removeCard(index);
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFFE4A49),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: Builder(builder: (context) {
            final SlidableController slidableController = Slidable.of(context)!;
            return Row(
              children: [
                settingsProvider.isEditing && index != 0
                    ? GestureDetector(
                        onTap: () {
                          slidableController.openEndActionPane();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (settingsProvider.isEditing) {
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              WeatherDetailsPage(index: index),
                        ),
                      );
                    },
                    child: Hero(
                      tag: weatherModel.timezone!,
                      child: Container(
                          height: settingsProvider.isEditing ? 10.h : 14.h,
                          margin: EdgeInsets.symmetric(vertical: 0.8.h),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(backgroundImage),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.25),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    index != 0
                                        ? weatherModel.timezone!
                                        : 'My Location',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 2.5),
                                  Text(
                                    index == 0
                                        ? weatherModel.timezone!
                                        : DateFormat('hh:mm a')
                                            .format(localTime),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  settingsProvider.isEditing
                                      ? const SizedBox()
                                      : const Spacer(),
                                  settingsProvider.isEditing
                                      ? const SizedBox()
                                      : Text(
                                          condition.capitalizeByWord(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${homeProvider.getTemperatureInScale(context, weatherModel.current!.temp!)}$degreeSymbol',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  settingsProvider.isEditing
                                      ? const SizedBox()
                                      : const Spacer(),
                                  settingsProvider.isEditing
                                      ? const SizedBox()
                                      : Text(
                                          'H:${homeProvider.getTemperatureInScale(context, weatherModel.daily!.first.temp!.max!)}$degreeSymbol  L:${homeProvider.getTemperatureInScale(context, weatherModel.daily!.first.temp!.min!)}$degreeSymbol',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                settingsProvider.isEditing && index != 0
                    ? ReorderableDragStartListener(
                        key: key,
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(Icons.drag_handle,
                              color: Theme.of(context).indicatorColor),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          }),
        ),
      );
    });
  }
}
