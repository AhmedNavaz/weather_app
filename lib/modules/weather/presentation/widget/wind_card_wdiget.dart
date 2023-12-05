import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/helper.dart';

class WindCardWidget extends StatelessWidget {
  const WindCardWidget(
      {super.key,
      required this.height,
      required this.windSpeed,
      required this.windGusts,
      this.verticalPadding = 12,
      this.horizontalPadding = 10});

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
                    const SizedBox(width: 5),
                    Text(
                      'Wind'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).indicatorColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '${windSpeed.toInt()}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(width: 7.5),
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
                    const SizedBox(width: 7.5),
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
