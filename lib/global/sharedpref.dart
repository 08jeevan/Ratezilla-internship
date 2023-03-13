import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const stringSharedPreference = "string shared preferences";
const boolSharedPreference = "bool shared preferences";


class SharedPref {

static Future<String> getString() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(stringSharedPreference) ?? "";
  }
  
  static Future setString(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(stringSharedPreference, value);
  }

static Future setBool() async {
	final prefs = await SharedPreferences.getInstance();
	prefs.setBool(boolSharedPreference, true);
}

static Future<bool> getBool(bool value) async {
	final prefs = await SharedPreferences.getInstance();
	return prefs.getBool(boolSharedPreference) ?? false;
}


static Future clearSharedPref() async {
	final prefs = await SharedPreferences.getInstance();

	await prefs.clear();
}
}
