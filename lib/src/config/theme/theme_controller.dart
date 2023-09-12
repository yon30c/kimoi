import 'package:flutter/material.dart';
import '../theme/theme_service.dart';

class ThemeController with ChangeNotifier {
  final ThemeService _themeService;
  late ThemeMode _themeMode;
  late Color _selectedColor;

  ThemeController(this._themeService);

  ThemeMode get themeMode => _themeMode;

  Color get selectedColor => _selectedColor;

  Future<ThemeMode> loadTheme() async {
    _selectedColor = await _themeService.selectedColor();
    _themeMode = await _themeService.themeMode();

    notifyListeners();
    return _themeMode;
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();

    await _themeService.updateThemeMode(newThemeMode);
  }

  Future<void> updateSelectedColor(Color newColor) async {
    _selectedColor = newColor;

    notifyListeners();
    await _themeService.updateThemeColor(newColor);
  }
}