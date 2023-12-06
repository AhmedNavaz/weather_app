import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/helper.dart';

class WindCardWidget extends StatelessWidget {
  WindCardWidget({
    super.key,
    required this.height,
    required this.windSpeed,
    required this.windGusts,
  })  : verticalPadding = 1.3.h,
        horizontalPadding = 1.1.h;

  final double height;
  final double windSpeed;
  final double windGusts;

  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
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
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.wind,
                      color: Theme.of(context).indicatorColor,
                      size: 15,
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Wind'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).indicatorColor),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Text(
                      '${windSpeed.toInt()}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'km/h'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).indicatorColor,
                                  ),
                        ),
                        Text(
                          'Wind',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Helper.divider(context, height: 0, horizontalPadding: 0),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      '${windGusts.toInt()}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'km/h'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).indicatorColor,
                                  ),
                        ),
                        Text(
                          'Gusts',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
