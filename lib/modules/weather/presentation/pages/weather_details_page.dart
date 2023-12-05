import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/business/entities/weather_entity.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';

import '../../../../utils/helper.dart';
import '../widget/weather_details_widget.dart';

class WeatherDetailsPage extends StatefulWidget {
  const WeatherDetailsPage({super.key, required this.index});

  final int index;

  @override
  State<WeatherDetailsPage> createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late final AnimationController animationController;
  late final Animation<double> animation;

  PageController pageController = PageController();

  @override
  initState() {
    _currentIndex = widget.index;
    pageController = PageController(initialPage: _currentIndex);
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider homeProvider = context.read<HomeProvider>();
    final List<WeatherEntity> cities = homeProvider.cities;
    DateTime localTime = Helper.convertToLocalTime(
      cities[_currentIndex].city.time,
      cities[_currentIndex].city.timezoneOffset,
    );
    String backgroundImage = homeProvider.getBackgroundImage(
      cities[_currentIndex].condition,
      localTime,
    );
    return Hero(
      tag: cities[widget.index].city.name,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: FadeTransition(
                opacity: animation,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    backgroundImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: pageController,
              itemCount: cities.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                animationController.reset();
                animationController.forward();
              },
              itemBuilder: (context, index) {
                return WeatherDetailsWidget(
                  weatherEntity: cities[index],
                );
              },
            ),
            Positioned(
              bottom: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.33),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            children: cities.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () {
                              _currentIndex = entry.key;
                            },
                            child: entry.key == 0
                                ? Icon(
                                    CupertinoIcons.paperplane_fill,
                                    color: _currentIndex == entry.key
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                    size: 10,
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentIndex == entry.key
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                          );
                        }).toList()),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            CupertinoIcons.list_bullet,
                            color: Colors.white,
                            size: 22.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
