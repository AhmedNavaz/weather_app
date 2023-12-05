import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../utils/helper.dart';

class HumidityCardWidget extends StatelessWidget {
  const HumidityCardWidget(
      {super.key,
      required this.height,
      required this.humidity,
      required this.dewPoint,
      this.verticalPadding = 12,
      this.horizontalPadding = 10});

  final double height;
  final double humidity;
  final double dewPoint;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.drop,
                      color: Theme.of(context).indicatorColor,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Humidity'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).indicatorColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${humidity.toInt()}%',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  'The dew point is $dewPoint$degreeSymbol right now.',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 13,
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
