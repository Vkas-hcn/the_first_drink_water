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
    if (stringValue != null && stringValue.isNotEmpty) {
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

    if (stringValue != null && stringValue.isNotEmpty) {
      return stringValue.split(',');
    } else {
      LocalStorage().setValue(LocalStorage.drinkingWaterNumArray, "200");
      return ["200"];
    }
  }

  static void deleteWaterIntakeData(int timestamp) {
    String? stringValue =
        LocalStorage().getValue(LocalStorage.drinkingWaterList) as String?;
    if (stringValue != null && stringValue.isNotEmpty) {
      List<dynamic> jsonData = jsonDecode(stringValue);
      List<WaterIntake> waterIntakeList =
          jsonData.map((json) => WaterIntake.fromJson(json)).toList();

      // 删除匹配 timestamp 的数据
      waterIntakeList.removeWhere((item) => item.timestamp == timestamp);

      // 更新本地存储数据
      String updatedStringValue = jsonEncode(waterIntakeList);
      LocalStorage()
          .setValue(LocalStorage.drinkingWaterList, updatedStringValue);
    }
  }

  static List<WaterIntake> getWaterIntakeData() {
    String? stringValue =
        LocalStorage().getValue(LocalStorage.drinkingWaterList) as String?;
    if (stringValue != null && stringValue.isNotEmpty) {
      // Parse JSON string
      List<dynamic> jsonData = jsonDecode(stringValue);
      // Convert parsed JSON to list of WaterIntake objects
      List<WaterIntake> waterIntakeList =
          jsonData.map((json) => WaterIntake.fromJson(json)).toList();
      waterIntakeList.sort((a, b) {
        DateTime dateTimeA = DateTime.parse('${a.date} ${a.time}');
        DateTime dateTimeB = DateTime.parse('${b.date} ${b.time}');
        return dateTimeB.compareTo(dateTimeA);
      });
      return waterIntakeList;
    } else {
      return List.empty();
    }
  }

  static String getNowDate() {
    DateTime now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static List<WaterIntake> getTodayWaterIntakeData() {
    final List<WaterIntake> waterIntakeList = getWaterIntakeData();
    final todayWaterIntakeList = waterIntakeList.where((waterIntake) {
      return waterIntake.date == getNowDate();
    }).toList();
    return todayWaterIntakeList;
  }

  static List<WaterIntake> getWaterListDay(String formattedDate) {
    final List<WaterIntake> waterIntakeList = getWaterIntakeData();
    final todayWaterIntakeList = waterIntakeList.where((waterIntake) {
      return waterIntake.date == formattedDate;
    }).toList();

    return todayWaterIntakeList;
  }

  static int getWaterConsumption(String formattedDate) {
    final List<WaterIntake> waterIntakeList = getWaterIntakeData();
    // 过滤出日期的喝水记录
    final todayWaterIntakeList = waterIntakeList.where((waterIntake) {
      return waterIntake.date == formattedDate;
    }).toList();
    // 计算日期的喝水总量
    final int todayTotalWaterIntake = todayWaterIntakeList.fold(0, (sum, item) {
      return sum + int.parse(item.ml);
    });
    return todayTotalWaterIntake;
  }

  //日期完成率
  static int completionRateOnACertainDay(String formattedDate) {
    final List<WaterIntake> waterIntakeList = getWaterIntakeData();
    final todayWaterIntakeList = waterIntakeList.where((waterIntake) {
      return waterIntake.date == formattedDate;
    }).toList();
    int target = int.parse(todayWaterIntakeList.first.target);

    double result = (getWaterConsumption(formattedDate) / target) * 100;
    if (result > 100) {
      result = 100;
    }
    return result.toInt();
  }

  static void setWaterIntakeData(WaterIntake waterIntake) {
    // 获取现有的水摄入数据
    List<WaterIntake> jsonBean = getWaterIntakeData();

    // 创建一个新的可变列表并添加现有数据
    List<WaterIntake> mutableList = List.from(jsonBean);

    // 添加新的水摄入数据到可变列表中
    mutableList.insert(0, waterIntake);

    // 将可变列表编码为JSON字符串
    String jsonString = jsonEncode(mutableList);

    // 保存JSON字符串到本地存储
    LocalStorage().setValue(LocalStorage.drinkingWaterList, jsonString);
  }

  static Map<String, List<WaterIntake>> getWaterIntakeByDate() {
    List<WaterIntake> waterIntakeList = getWaterIntakeData();
    Map<String, List<WaterIntake>> waterIntakeByDate = {};
    for (var record in waterIntakeList) {
      if (!waterIntakeByDate.containsKey(record.date)) {
        waterIntakeByDate[record.date] = [];
      }
      waterIntakeByDate[record.date]!.add(record);
    }
    return waterIntakeByDate;
  }

  //喝水天数
  static int getAllWaterDays() {
    return getWaterIntakeByDate().length;
  }

  //总喝水量
  static int getAllTotalWaterIntake() {
    List<WaterIntake> waterIntakeList = getWaterIntakeData();
    int totalWaterIntake =
        waterIntakeList.fold(0, (sum, item) => sum + int.parse(item.ml));
    if (totalWaterIntake.isNaN) {
      totalWaterIntake = 0;
    }
    return totalWaterIntake;
  }

  //总完成比
  static int getAllCompletionRate() {
    int completedDays = getWaterIntakeByDate().entries.fold(0, (count, entry) {
      int dailyTotal =
          entry.value.fold(0, (sum, item) => sum + int.parse(item.ml));
      int target = int.parse(entry.value.first.target);
      if (dailyTotal >= target) {
        count += 1;
      }
      return count;
    });
    print("总完成比-completedDays${completedDays}");
    print("总完成比-getAllWaterDays${getAllWaterDays()}");

    double completionRate = completedDays / getAllWaterDays();
    return (completionRate*100).toInt();
  }

  //修改数组中日期目标值
  static void updateTargetForDate(String date, String newTarget) {
    // 获取现有的水摄入数据
    List<WaterIntake> waterIntakeList = getWaterIntakeData();

    // 遍历列表并更新匹配日期的项目
    for (int i = 0; i < waterIntakeList.length; i++) {
      if (waterIntakeList[i].date == date) {
        waterIntakeList[i] = WaterIntake(
          ml: waterIntakeList[i].ml,
          time: waterIntakeList[i].time,
          date: waterIntakeList[i].date,
          target: newTarget,
          timestamp: waterIntakeList[i].timestamp,
        );
      }
    }

    // 将更新后的列表编码为JSON字符串
    String jsonString = jsonEncode(waterIntakeList);

    // 保存JSON字符串到本地存储
    LocalStorage().setValue(LocalStorage.drinkingWaterList, jsonString);
  }

}
