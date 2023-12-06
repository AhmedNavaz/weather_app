import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/core/connection/connection.dart';
import 'package:weather_app/modules/weather/presentation/providers/home_provider.dart';
import 'package:weather_app/modules/weather/presentation/providers/searhbar_provider.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key, required this.isAppBarPinned});

  bool isAppBarPinned = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchBarProvider>(
        builder: (context, searchBarProvider, child) {
      return ClipRRect(
        child: BackdropFilter(
          filter: isAppBarPinned && !searchBarProvider.isSearching
              ? ImageFilter.blur(sigmaX: 50, sigmaY: 50)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: TextField(
                    controller: searchBarProvider.searchbarController,
                    focusNode: searchBarProvider.searchbarFocusNode,
                    onTap: () {
                      context.read<HomeProvider>().scrollToBottom();
                      searchBarProvider.changeSearchingState(true);
                    },
                    cursorColor: Colors.white,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: InputDecoration(
                      hintText: 'Search for a city or airport',
                      hintStyle: Theme.of(context).textTheme.labelMedium,
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: Theme.of(context).indicatorColor,
                        size: 17.5,
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 27.5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      searchBarProvider.onChangeSearch(value);
                    },
                    onSubmitted: (value) {
                      searchBarProvider.onSearchSubmitted(context);
                    },
                  ),
                ),
              ),
              searchBarProvider.isSearching
                  ? GestureDetector(
                      onTap: () {
                        context.read<HomeProvider>().scrollToTop();
                        searchBarProvider.changeSearchingState(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text('Cancel',
                            style: Theme.of(context).textTheme.bodyMedium!),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    });
  }
}
