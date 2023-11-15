import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState extends ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void toggleDarkMode() async {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkModeEnabled', _isDarkModeEnabled);
  }

  Future<void> loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;
    notifyListeners();
  }
}
