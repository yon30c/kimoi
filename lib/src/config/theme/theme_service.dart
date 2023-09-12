import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

class ThemeService  {
  static late SharedPreferences prefs;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  ThemeMode getThemeMode() {
    final sTheme = prefs.getInt('theme');

    ThemeMode theme = ThemeMode.system;

    switch (sTheme) {
      case 0:
        theme = ThemeMode.system;
        break;
      case 1:
        theme = ThemeMode.light;
        break;
      case 2:
        theme = ThemeMode.dark;
        break;
      default:
    }

    return theme;
  }

  Color getColor() {
    final sColor = prefs.getInt('color');

    Color color = colors[0];

    switch (sColor) {
      case 0:
        color = Colors.blue;
        break;
      case 1:
        color = Colors.teal;
        break;
      case 2:
        color = Colors.redAccent;
        break;
      case 3:
        color = Colors.deepOrangeAccent;
        break;
      case 4:
        color = Colors.indigo;
        break;
      default:
    }
    return color;
  }

  Future<ThemeMode> themeMode() async => getThemeMode();

  Future<Color> selectedColor() async => getColor();

  Future<void> updateThemeMode(ThemeMode theme) async {
    int selectedTheme;
    switch (theme) {
      case ThemeMode.system:
        selectedTheme = 0;
        break;
      case ThemeMode.light:
        selectedTheme = 1;
        break;
      case ThemeMode.dark:
        selectedTheme = 2;
        break;
      default:
        selectedTheme = 0;
        break;
    }
    prefs.setInt('theme', selectedTheme);
  }

  Future<void> updateThemeColor(Color color) async {
    int selectedColor;
    switch (color) {
      case Colors.blue:
        selectedColor = 0;
        break;
      case Colors.teal:
        selectedColor = 1;
        break;
      case Colors.redAccent:
        selectedColor = 2;
        break;
      case Colors.deepOrangeAccent:
        selectedColor = 3;
        break;
      case Colors.indigo:
        selectedColor = 4;
        break;
      default:
        selectedColor = 0;
    }

    prefs.setInt('color', selectedColor);
  }
}