import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/modules/weather/presentation/pages/home_page.dart';
import 'package:weather_app/utils/hive.dart';
import 'package:sizer/sizer.dart';

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
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
            scaffoldBackgroundColor: Colors.black,
            indicatorColor: Colors.white.withOpacity(0.5),
            textTheme: TextTheme(
              displayLarge: GoogleFonts.inter(
                fontSize: 51.sp,
                color: Colors.white,
              ),
              displayMedium: GoogleFonts.inter(
                fontSize: 26.sp,
                color: Colors.white,
              ),
              headlineLarge: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headlineSmall: GoogleFonts.inter(
                fontSize: 12.6.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titleMedium: GoogleFonts.inter(
                fontSize: 15.4.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              labelMedium: GoogleFonts.inter(
                fontSize: 8.4.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              labelSmall: GoogleFonts.inter(
                fontSize: 7.sp,
                color: Colors.grey,
              ),
              bodyLarge: GoogleFonts.inter(
                fontSize: 11.2.sp,
                color: Colors.white,
              ),
              bodyMedium: GoogleFonts.inter(
                fontSize: 9.1.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodySmall: GoogleFonts.inter(
                fontSize: 8.sp,
                color: Colors.white,
              ),
            ),
          ),
          home: const HomePage(),
        );
      }),
    );
  }
}
