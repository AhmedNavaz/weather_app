import 'package:flutter/material.dart';
import 'package:weather_app/core/themes/theme_data.dart';
import 'package:weather_app/modules/weather/presentation/pages/home_page.dart';
import 'package:weather_app/utils/hive.dart';
import 'package:sizer/sizer.dart';

import 'core/providers/multi_providers.dart';

// Entry point for the application
Future<void> main() async {
  // Ensure that Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  await HiveDatabase.init();

  // Run the application
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the MultiProviders widget to provide multiple ChangeNotifierProviders
    return MultiProviders(
      child: Sizer(builder: (context, orientation, deviceType) {
        // MaterialApp is the root of the application
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeData, // Set the theme data for the entire application
          home: const HomePage(), // Set the home page of the application
        );
      }),
    );
  }
}
