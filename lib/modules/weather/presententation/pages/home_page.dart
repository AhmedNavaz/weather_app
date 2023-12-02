import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  bool _isAppBarPinned = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _isAppBarPinned =
              _scrollController.hasClients && _scrollController.offset > 0;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
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
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            toolbarHeight: 90,
            backgroundColor:
                _isAppBarPinned ? Colors.white.withOpacity(0.4) : Colors.black,
            expandedHeight: 125,
            collapsedHeight: 90,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Weather',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(
                    height: 25,
                    width: double.infinity,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for a city or airport',
                        hintStyle: Theme.of(context).textTheme.labelSmall,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).indicatorColor,
                          size: 17.5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // Your weather data or other content goes here
                return ListTile(
                  title: Text('Weather Data $index'),
                );
              },
              childCount: 50, // Replace with the actual number of items
            ),
          ),
        ],
      ),
    );
  }
}
