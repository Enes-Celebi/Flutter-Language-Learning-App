import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/themes/dark_mode.dart';
import 'package:lingoneer_beta_0_0_1/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  ThemeData getInitialTheme() {
    // Return the initial light mode theme
    return lightMode;
  }

  static of(BuildContext context) {}
}
