import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

// Custom text theme using Google Fonts and Sizer for responsive font sizes.
// Adjustments are made to font sizes, weights, and colors for various text elements.
TextTheme textTheme = TextTheme(
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
    color: Colors.white.withOpacity(0.5),
  ),
  labelSmall: GoogleFonts.inter(
    fontSize: 7.sp,
    color: Colors.white.withOpacity(0.5),
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
);
