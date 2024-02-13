import 'package:flutter/material.dart';
import 'package:balagh/core/constants/constants.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    // Your other theme configurations...
    bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: kBackgroundColor,
      backgroundColor: kBackgroundColor,
    ),
    scaffoldBackgroundColor: kBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackgroundColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFC4C4C4).withOpacity(0.2),

      // labelStyle: TextStyle(
      //   color: primaryColor,
      //   fontWeight: FontWeight.w600,
      //   fontSize: 16,
      // ),

      iconColor: kMidtBlue,
      prefixIconColor: kDarkBlue,
      suffixIconColor: kDarkBlue,
      contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),

      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(0.6),
      ),
      errorStyle: const TextStyle(fontSize: 12, color: Colors.redAccent),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 0, color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 0.7, color: kDarkBlue),
          borderRadius: BorderRadius.circular(10)),
      errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 0.7, color: Colors.redAccent),
          borderRadius: BorderRadius.circular(10)),
      prefixStyle: const TextStyle(
        color: kLightBlue,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: kMidtBlue,
    brightness: Brightness.dark,
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all<Color>(Colors.grey),
      thumbColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            overlayColor: MaterialStateProperty.all<Color>(Colors.black26))),
  );
}
