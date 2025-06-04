import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
enum prefKeys{
  userDta,
  loggedIn,
  language,
  theme,
  apiToken,
  fromLogin
}

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String getString(prefKeys key, [String defValue=""]) {
    return _prefsInstance!.getString(key.name) ?? defValue ;
  }

  static Future<bool> setString(prefKeys key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key.name, value);
  }

  static bool getBool(prefKeys key, [bool defValue=false]) {
    if (_prefsInstance == null) return defValue;
    return _prefsInstance!.getBool(key.name) ?? defValue ;
  }

  static Future<bool> setBool(prefKeys key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key.name, value);
  }

}
