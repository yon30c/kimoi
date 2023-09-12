

import 'package:flutter/material.dart';

import '../../../main.dart';
const List<Color> colors = [
  Colors.blue,
  Colors.greenAccent,
  Colors.redAccent,
  Colors.purple,
];

class AppTheme {
  final int selectedColor;



  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0, 'Selected color must be grater than 0'),
        assert(selectedColor <= colors.length -1  , 'Selected color must be less or equal than ${colors.length - 1}');

  // ThemeData getTheme() => ThemeData(
  //   useMaterial3: true,
  //   colorSchemeSeed: themeController.selectedColor,
  //   // appBarTheme: const AppBarTheme(centerTitle: true),
  //   sliderTheme: const SliderThemeData(
  //     showValueIndicator: ShowValueIndicator.always
  //   ),
  // );

  ThemeData getDarkTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: themeController.selectedColor,
    // appBarTheme: const AppBarTheme(centerTitle: true),
    sliderTheme: const SliderThemeData(
      showValueIndicator: ShowValueIndicator.always
    )
  );
}