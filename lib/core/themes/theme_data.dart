import 'package:flutter/material.dart';
import 'package:weather_app/core/themes/text_theme.dart';

// Custom ThemeData for the application with specific visual properties.
ThemeData themeData = ThemeData(
  useMaterial3: false, // Disabling Material3 for compatibility.
  scaffoldBackgroundColor: Colors.black, // Background color for the entire app.
  indicatorColor: Colors.white
      .withOpacity(0.5), // Color for indicators with reduced opacity.
  textTheme: textTheme, // Applying the custom textTheme from text_theme.dart.
);
