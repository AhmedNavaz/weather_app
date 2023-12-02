import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/modules/weather/presententation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF1C9CF6),
        indicatorColor: Colors.grey,
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.roboto(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          labelSmall: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
