import 'package:flutter/material.dart';

class FontProvider with ChangeNotifier {
  String _fontFamily = 'Roboto';
  double _fontSize = 16.0; // Default font size

  String get fontFamily => _fontFamily;
  double get fontSize => _fontSize;

  void updateFontFamily(String newFont) {
    _fontFamily = newFont;
    notifyListeners();
  }

  void updateFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }
}
