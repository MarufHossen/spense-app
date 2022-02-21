import '../constants.dart';
import 'package:flutter/material.dart';

class MyThemes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.red,
    primaryColor: colorPrimary,
    appBarTheme: const AppBarTheme(
      backgroundColor: colorPrimary,
      // color: Colors.black,
      // titleTextStyle: TextStyle(
      //   color: Colors.black,
      // )
    ),
    buttonTheme: const ButtonThemeData(
        buttonColor: colorPrimary, textTheme: ButtonTextTheme.primary),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: colorPrimary,
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                wordSpacing: 2,
                letterSpacing: 1))),

    // buttonColor: C
  );
  static final dark = ThemeData.dark().copyWith(
      // backgroundColor: Colors.black,
      // primaryColorDark: Colors.red,
      //   buttonTheme: const ButtonThemeData(
      //       buttonColor: colorPrimaryDark, textTheme: ButtonTextTheme.primary),
      );
}
