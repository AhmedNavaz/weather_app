import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';

import '../../../../core/constants/constants.dart';

class HumidityCardWidget extends StatelessWidget {
  HumidityCardWidget({
    super.key,
    required this.height,
    required this.humidity,
    required this.dewPoint,
  })  : verticalPadding = 1.3.h,
        horizontalPadding = 1.1.h;

  final double height;
  final int humidity;
  final int dewPoint;

  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = context.read<HomeProvider>();
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(
                vertical: verticalPadding, horizontal: horizontalPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.drop,
                      color: Theme.of(context).indicatorColor,
                      size: 15,
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Humidity'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).indicatorColor),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text('${humidity.toInt()}%',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15.4.sp,
                        )),
                const Spacer(),
                Text(
                  'The dew point is ${homeProvider.getTemperatureInScale(context, dewPoint)}$degreeSymbol right now.',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 10.sp,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
