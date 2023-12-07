import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/core/connection/connection.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';
import 'package:weather_app/modules/weather/presentation/providers/searchbar_provider.dart';

import 'package:weather_app/modules/weather/presentation/widget/dropdown_widget.dart';
import 'package:weather_app/modules/weather/presentation/widget/no_internet_widget.dart';
import 'package:weather_app/modules/weather/presentation/widget/weather_card_widget.dart';

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
    // Use Consumer to rebuild the widget when the state of HomeProvider changes
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return Scaffold(
        // AppBar with conditional rendering based on search state
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
                  // DropDownWidget for additional actions
                  DropDownWidget(),
                ],
              ),
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          controller: homeProvider.scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // SliverPersistentHeader for persistent header with search bar
            return [
              Consumer<SearchBarProvider>(
                  builder: (context, searchBarProvider, child) {
                return SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                    minHeight: homeProvider.headerHeight,
                    maxHeight: homeProvider.headerHeight,
                    child: searchBarProvider.isSearching
                        ? const SizedBox(height: 12)
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
              // SliverPersistentHeader for pinned search bar
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
          // Body of NestedScrollView
          body: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: Consumer<SearchBarProvider>(
                builder: (context, searchbarProvider, child) {
              return Stack(
                children: [
                  // ReorderableListView for displaying weather cards
                  ReorderableListView(
                    physics: const BouncingScrollPhysics(),
                    onReorder: (int oldIndex, int newIndex) {
                      homeProvider.reOrderCards(oldIndex, newIndex);
                    },
                    children: [
                      // Loading indicator when syncing data online
                      homeProvider.isLoading &&
                              context.watch<ConnectionNotifier>().isOnline
                          ? Center(
                              key: UniqueKey(),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Syncing Weather Data ...',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            )
                          : SizedBox(key: UniqueKey()),
                      // Widget for displaying no internet connection message
                      NoInternetWidget(key: UniqueKey()),
                      // Display weather cards
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
                  // Dark overlay when searching
                  searchbarProvider.isSearching
                      ? Container(
                          height: 90.h,
                          color: Colors.black87,
                        )
                      : const SizedBox(),
                ],
              );
            }),
          ),
        ),
      );
    });
  }
}
