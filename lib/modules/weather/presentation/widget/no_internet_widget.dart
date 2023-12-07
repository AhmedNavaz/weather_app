import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/connection/connection.dart';
import '../../../../utils/helper.dart';
import '../../data/models/weather_model.dart';
import '../providers/home_provider.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isOnline = context.watch<ConnectionNotifier>().isOnline;
    if (context.read<HomeProvider>().cities.isEmpty) {
      return const SizedBox();
    }
    WeatherModel weatherModel = context.read<HomeProvider>().cities[0];
    DateTime lastConnectedTime = Helper.convertToLocalTime(
      weatherModel.current!.dt!,
      weatherModel.timezoneOffset!,
    );
    return isOnline
        ? const SizedBox()
        : ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Column(
                children: [
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.wifi_slash,
                        color: Colors.white,
                        size: 17.5,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'No Internet Connection',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Last online: ${Helper().getLastConnectedTime(lastConnectedTime)}, ${DateFormat('hh:mm a').format(lastConnectedTime)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 9.1.sp),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          );
  }
}
