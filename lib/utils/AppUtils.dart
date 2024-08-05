import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../bean/WaterIntake.dart';
import 'LocalStorage.dart';

class AppUtils {
  static bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    final number = num.tryParse(s);
    return number != null;
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void addDrinkNum(String num) {
    String? stringValue =
        LocalStorage().getValue(LocalStorage.drinkingWaterNumArray) as String?;
    if (stringValue!=null && stringValue.isNotEmpty) {
      stringValue = "$stringValue,$num";
    } else {
      stringValue = num;
    }
    LocalStorage().setValue(LocalStorage.drinkingWaterNumArray, stringValue);
  }

  static List<String> getDrinkNum() {
    String? stringValue =
        LocalStorage().getValue(LocalStorage.drinkingWaterNumArray) as String?;
    print("getDrinkNum==${stringValue}");

    if (stringValue!=null && stringValue.isNotEmpty) {
      return stringValue.split(',');
    } else {
      return ["200"];
    }
  }

  static List<WaterIntake> getWaterIntakeData() {
    String? stringValue =
        LocalStorage().getValue(LocalStorage.drinkingWaterList) as String?;
    print("getWaterIntakeData==${stringValue}");
    if (stringValue!=null && stringValue.isNotEmpty) {
      // Parse JSON string
      List<dynamic> jsonData = jsonDecode(stringValue);
      // Convert parsed JSON to list of WaterIntake objects
      List<WaterIntake> waterIntakeList =
          jsonData.map((json) => WaterIntake.fromJson(json)).toList();
      return waterIntakeList;
    } else {
      return List.empty();
    }
  }

  static void setWaterIntakeData(WaterIntake waterIntake) {
    // 获取现有的水摄入数据
    List<WaterIntake> jsonBean = getWaterIntakeData();

    // 创建一个新的可变列表并添加现有数据
    List<WaterIntake> mutableList = List.from(jsonBean);

    // 添加新的水摄入数据到可变列表中
    mutableList.add(waterIntake);

    // 将可变列表编码为JSON字符串
    String jsonString = jsonEncode(mutableList);

    // 保存JSON字符串到本地存储
    LocalStorage().setValue(LocalStorage.drinkingWaterList, jsonString);
  }

}
