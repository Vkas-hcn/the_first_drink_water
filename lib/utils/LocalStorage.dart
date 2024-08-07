import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static String drinkingWaterGoal = "drinkingWaterGoal";
  static String drinkingWaterNumArray = "drinkingWaterNumArray";
  static String drinkingWaterList = "drinkingWaterList";
  static String userBmiList = "userBmiList";

  static final LocalStorage _instance = LocalStorage._internal();
  late SharedPreferences _prefs;

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Set value by key
  Future<void> setValue(String key, dynamic value) async {
    if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  // Get value by key
  dynamic getValue(String key) {
    return _prefs.get(key);
  }

}
