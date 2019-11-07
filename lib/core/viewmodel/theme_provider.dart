import 'package:flutter/foundation.dart';
import 'package:intelligent_ordering_system/core/shared/shared_preferences_helper.dart';

class ThemeProvider with ChangeNotifier {
  static bool isLightTheme = true;

  setTheme(value) {
    isLightTheme = value;
    notifyListeners();
  }

  get getTheme {
    return isLightTheme;
  }

  void switchTheme() {
    isLightTheme = !isLightTheme;
    setTheme(isLightTheme);
    SharedPreferencesHelper.setTheme(isLightTheme);
  }
}
