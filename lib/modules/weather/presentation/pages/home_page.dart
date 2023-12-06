import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/core/connection/connection.dart';
import 'package:weather_app/modules/weather/data/models/weather_model.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';
import 'package:weather_app/modules/weather/presentation/providers/searhbar_provider.dart';

import 'package:weather_app/modules/weather/presentation/widget/dropdown_widget.dart';
import 'package:weather_app/modules/weather/presentation/widget/no_internet_widget.dart';
import 'package:weather_app/modules/weather/presentation/widget/weather_card_widget.dart';

import '../../../../utils/helper.dart';
import '../extension/sliver_appbar_delegate_extention.dart';
import '../widget/searchbar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return Scaffold(
        appBar: context.read<SearchBarProvider>().isSearching
            ? AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            : AppBar(
                toolbarHeight: 30,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: AnimatedOpacity(
                  opacity: homeProvider.isAppBarPinned ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Text('Weather',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
                actions: const [
                  DropDownWidget(),
                ],
              ),
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          controller: homeProvider.scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              Consumer<SearchBarProvider>(
                  builder: (context, searchBarProvider, child) {
                return SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                    minHeight: homeProvider.headerHeight,
                    maxHeight: homeProvider.headerHeight,
                    child: searchBarProvider.isSearching
                        ? const SizedBox(
                            height: 12,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Weather',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                  ),
                );
              }),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  minHeight: 60,
                  maxHeight: 60,
                  child: SearchBarWidget(
                      isAppBarPinned: homeProvider.isAppBarPinned),
                ),
              ),
            ];
          },
          body: homeProvider.cities.isNotEmpty
              ? Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Consumer<SearchBarProvider>(
                      builder: (context, searchbarProvider, child) {
                    return Stack(
                      children: [
                        ReorderableListView(
                          physics: const BouncingScrollPhysics(),
                          onReorder: (int oldIndex, int newIndex) {
                            homeProvider.reOrderCards(oldIndex, newIndex);
                          },
                          children: [
                            NoInternetWidget(key: UniqueKey()),
                            ...homeProvider.cities
                                .asMap()
                                .map(
                                  (index, weatherModel) => MapEntry(
                                    index,
                                    WeatherCardWidget(
                                      key: ValueKey(weatherModel),
                                      weatherModel: weatherModel,
                                      index: index,
                                    ),
                                  ),
                                )
                                .values
                                .toList(),
                          ],
                        ),
                        searchbarProvider.isSearching
                            ? Container(
                                height: 90.h,
                                color: Colors.black87,
                              )
                            : const SizedBox(),
                      ],
                    );
                  }),
                )
              : const Center(child: Text('Getting Weather Data...')),
        ),
      );
    });
  }
}
