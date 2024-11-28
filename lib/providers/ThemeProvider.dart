import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    // if (_isDarkMode == true) {
    //   return ThemeData.dark();
    // } else {
    //   return ThemeData.light();
    // }
    return _isDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}
