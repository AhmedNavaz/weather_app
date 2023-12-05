import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/constants/constants.dart';
import 'package:weather_app/modules/weather/presentation/providers/settings_provider.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return settingsProvider.isEditing
          ? GestureDetector(
              onTap: () {
                settingsProvider.changeEditingState(false);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 5),
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
            )
          : PopupMenuButton(
              offset: const Offset(0, 40),
              splashRadius: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              color: Colors.black87,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onTap: () {
                      settingsProvider.changeEditingState(true);
                    },
                    child: ListTile(
                        dense: true,
                        minLeadingWidth: 0,
                        leading: const SizedBox(width: 17.5),
                        title: Text(
                          'Edit List',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: const Icon(
                          CupertinoIcons.pencil,
                          color: Colors.white,
                          size: 17.5,
                        )),
                  ),
                  PopupMenuItem(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onTap: () {
                      settingsProvider
                          .changeTemperatureScale(TemperatureScale.celsius);
                    },
                    child: ListTile(
                        minLeadingWidth: 0,
                        dense: true,
                        leading: settingsProvider.temperatureScale ==
                                TemperatureScale.celsius
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 17.5,
                              )
                            : const SizedBox(width: 17.5),
                        title: Text(
                          'Celsius',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: Text(
                          '${degreeSymbol}C',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                  ),
                  PopupMenuItem(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onTap: () {
                      settingsProvider
                          .changeTemperatureScale(TemperatureScale.fahrenheit);
                    },
                    child: ListTile(
                        minLeadingWidth: 0,
                        dense: true,
                        leading: settingsProvider.temperatureScale ==
                                TemperatureScale.fahrenheit
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 17.5,
                              )
                            : const SizedBox(width: 17.5),
                        title: Text(
                          'Fahrenheit',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: Text(
                          '${degreeSymbol}F',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                  ),
                ];
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10, top: 5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            );
    });
  }
}
