import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontService {
  StreamController<double> fontStreamController = StreamController<double>.broadcast();
  SharedPreferences? prefs;

  Stream<double> getFontStream() {
    return fontStreamController.stream;
  }

  void setFont(double selectedFontSize) async {
    prefs ??= await SharedPreferences.getInstance();
    fontStreamController.add(selectedFontSize);
    prefs!.setDouble('selectedFont', selectedFontSize);
    debugPrint('Font Size: $selectedFontSize');
  }

  void loadFont() async {
    prefs = await SharedPreferences.getInstance();
    double currentFont = 16.0;
    if (prefs!.containsKey('selectedFont')) {
      currentFont = prefs!.getDouble('selectedFont')!;
    }
    fontStreamController.add(currentFont);
  }
}
