import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/presentation/pages/home_page.dart';
import 'package:weather_app/utils/hive.dart';

import 'modules/weather/presentation/providers/home_provider.dart';
import 'modules/weather/presentation/providers/searhbar_provider.dart';
import 'modules/weather/presentation/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SearchBarProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: const Color(0xFF1C9CF6),
          indicatorColor: Colors.grey,
          textTheme: TextTheme(
            displayLarge: GoogleFonts.inter(
              fontSize: 72,
              color: Colors.white,
            ),
            displayMedium: GoogleFonts.inter(
              fontSize: 38,
              color: Colors.white,
            ),
            headlineLarge: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headlineSmall: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titleMedium: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            labelMedium: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            labelSmall: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.grey,
            ),
            bodyLarge: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
            ),
            bodyMedium: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodySmall: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
