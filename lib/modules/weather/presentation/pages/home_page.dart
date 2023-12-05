import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';
import 'package:weather_app/modules/weather/presentation/providers/searhbar_provider.dart';
import 'dart:math' as math;

import 'package:weather_app/modules/weather/presentation/widget/dropdown_widget.dart';
import 'package:weather_app/modules/weather/presentation/widget/weather_card_widget.dart';

import '../widget/searchbar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  delegate: _SliverAppBarDelegate(
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
                delegate: _SliverAppBarDelegate(
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
                          children: homeProvider.cities
                              .asMap()
                              .map(
                                (index, weatherEntity) => MapEntry(
                                    index,
                                    WeatherCardWidget(
                                      key: ValueKey(weatherEntity),
                                      weatherEntity: weatherEntity,
                                      index: index,
                                    )),
                              )
                              .values
                              .toList(),
                        ),
                        searchbarProvider.isSearching
                            ? Container(
                                height: size.height * 0.9,
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
