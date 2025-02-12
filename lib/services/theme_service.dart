import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// themes

class ThemeService {
  StreamController<Color> themeStreamController =
  StreamController<Color>.broadcast();

  StreamController<double> fontStreamController =
  StreamController<double>.broadcast();

  SharedPreferences? prefs;

  Stream<Color> getThemeStream() {
    return themeStreamController.stream;
  }

  Stream<double> getFontStream() {
    return fontStreamController.stream;
  }

 

// setting the chosen theme
  void setTheme(Color selectedTheme, String stringTheme) {
    themeStreamController.add(selectedTheme);
    prefs!.setString('selectedTheme', stringTheme);
    debugPrint('Theme: ' + stringTheme);
  }

  void setFontSize(double fontSize) {
    fontStreamController.add(fontSize);
    prefs!.setDouble('fontSize', fontSize);
    debugPrint('Font Size: ' + fontSize.toString());
  }



  void loadPreference() async {
    prefs = await SharedPreferences.getInstance();

    Color currentTheme = Colors.deepPurple;
    if (prefs!.containsKey('selectedTheme')) {
      String selectedTheme = prefs!.getString('selectedTheme')!;
      if (selectedTheme == 'deepPurple')
        currentTheme = Colors.deepPurple;
      else if (selectedTheme == 'blue')
        currentTheme = Colors.blue;
      else if (selectedTheme == 'green')
        currentTheme = Colors.green;
      else if (selectedTheme == 'red') currentTheme = Colors.red;
    }
    themeStreamController.add(currentTheme);

    double currentFontSize = 16.0;
    if ( prefs!.containsKey('fontSize')){
      currentFontSize = prefs!.getDouble('fontSize')!;
    }
    fontStreamController.add(currentFontSize);

  }
}
