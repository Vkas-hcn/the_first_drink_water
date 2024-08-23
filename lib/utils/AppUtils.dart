import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:the_first_drink_water/bean/BmiBean.dart';
import 'package:the_first_drink_water/gg/GgUtils.dart';
import '../bean/WaterIntake.dart';
import 'LocalStorage.dart';

class AppUtils {
  static GgUtils getMobUtils(BuildContext context) {
    final adManager = Provider.of<GgUtils>(context, listen: false);
    return adManager;
  }

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      // Sort the list by timestamp, newer entries first
      // waterIntakeList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
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
    print("setWaterIntakeData=1====${mutableList.length}");
    // 添加新的水摄入数据到可变列表中
    mutableList.add(waterIntake);
    print("setWaterIntakeData=2====${mutableList.length}");

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
    double completionRate = completedDays / getAllWaterDays();
    return (completionRate * 100).toInt();
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

  //------------------------------------BMI---------------------------------

  static List<BmiBean> getBMIListData() {
    String? stringValue =
        LocalStorage().getValue(LocalStorage.userBmiList) as String?;
    if (stringValue != null && stringValue.isNotEmpty) {
      List<dynamic> jsonData = jsonDecode(stringValue);
      List<BmiBean> bmiBeanList =
          jsonData.map((json) => BmiBean.fromJson(json)).toList();
      bmiBeanList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return bmiBeanList;
    } else {
      return List.empty();
    }
  }

  static void setBmiData(BmiBean bmiBean) {
    List<BmiBean> jsonBean = getBMIListData();
    List<BmiBean> mutableList = List.from(jsonBean);
    mutableList.insert(0, bmiBean);
    String jsonString = jsonEncode(mutableList);
    LocalStorage().setValue(LocalStorage.userBmiList, jsonString);
  }

  static String calculateBMINum(String heightCmStr, String weightKgStr) {
    double heightCm = double.parse(heightCmStr);
    double weightKg = double.parse(weightKgStr);
    double heightM = heightCm / 100;
    double bmi = weightKg / (heightM * heightM);
    // 返回结果和状态
    return bmi.toStringAsFixed(1);
  }

  static String calculateBMIState(String heightCmStr, String weightKgStr) {
    double heightCm = double.parse(heightCmStr);
    double weightKg = double.parse(weightKgStr);
    double heightM = heightCm / 100;
    double bmi = weightKg / (heightM * heightM);
    String status;
    if (bmi < 18.5) {
      status = 'Underweight';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      status = 'Normal';
    } else if (bmi >= 25 && bmi <= 29.9) {
      status = 'Overweight';
    } else {
      status = 'Obesity';
    }
    return status;
  }

  static void deleteBmiData(int timestamp) {
    String? stringValue =
        LocalStorage().getValue(LocalStorage.userBmiList) as String?;
    if (stringValue != null && stringValue.isNotEmpty) {
      List<dynamic> jsonData = jsonDecode(stringValue);
      List<BmiBean> bmiBeanList =
          jsonData.map((json) => BmiBean.fromJson(json)).toList();
      bmiBeanList.removeWhere((item) => item.timestamp == timestamp);
      String updatedStringValue = jsonEncode(bmiBeanList);
      LocalStorage().setValue(LocalStorage.userBmiList, updatedStringValue);
    }
  }

  static String getFormattedDate(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    String monthStr = month < 10 ? '0$month' : '$month';
    String dayStr = day < 10 ? '0$day' : '$day';
    String formattedDate = '$year-$monthStr-$dayStr';
    return formattedDate;
  }

  static String getFormattedDate2(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String monthStr = '$month';
    String dayStr = '$day';
    String hourStr = hour < 10 ? '0$hour' : '$hour';
    String minuteStr = minute < 10 ? '0$minute' : '$minute';
    String formattedDate = '$year/$monthStr/$dayStr $hourStr:$minuteStr';
    return formattedDate;
  }

  static String getBmiStats(String state) {
    List<BmiBean> bmiList = getBMIListData();
    Map<String, String> bmiStats = BmiBean.calculateBmiStatistics(bmiList);
    if (bmiStats[state] == null) {
      return "0";
    } else {
      return bmiStats[state]!;
    }
  }

  static Future<void> showScanAd(
    BuildContext context,
    AdWhere adPosition,
    int moreTime,
    Function() loadingFun,
    Function() nextFun,
  ) async {
    final Completer<void> completer = Completer<void>();
    var isCancelled = false;

    void cancel() {
      isCancelled = true;
      completer.complete();
    }

    Future<void> _checkAndShowAd() async {
      bool colckState = await GgUtils.blacklistBlocking();
      if (colckState) {
        nextFun();
        return;
      }
      if (!getMobUtils(context).canShowAd(adPosition)) {
        AppUtils.getMobUtils(context).loadAd(adPosition);
      }

      if (getMobUtils(context).canShowAd(adPosition)) {
        loadingFun();
        getMobUtils(context).showAd(context, adPosition, nextFun);
        return;
      }
      if (!isCancelled) {
        await Future.delayed(const Duration(milliseconds: 500));
        await _checkAndShowAd();
      }
    }

    Future.delayed( Duration(seconds: moreTime), cancel);
    await Future.any([
      _checkAndShowAd(),
      completer.future,
    ]);

    if (!completer.isCompleted) {
      return;
    }
    print("插屏广告展示超时");
    nextFun();
  }
  static void loadingAd(GgUtils adManager){
    adManager.loadAd(AdWhere.BACK);
    adManager.loadAd(AdWhere.SAVE);
    adManager.loadAd(AdWhere.Next);
  }
 static void backToNextPaper(
    BuildContext context,
    GgUtils adManager,
    AdWhere adPosition,
    Function() showLoadingFun,
    Function() disShowLoadingFun,
  ) async {
    if (!adManager.canShowAd(adPosition)) {
      adManager.loadAd(adPosition);
    }
    showLoadingFun();
    AppUtils.showScanAd(context, adPosition,5, () {
      disShowLoadingFun();
    }, () {
      disShowLoadingFun();
      Navigator.pop(context);
    });
  }

  static void goToNextPaper(
      BuildContext context,
      GgUtils adManager,
      AdWhere adPosition,
      Function() showLoadingFun,
      Function() disShowLoadingFun,
      Function() jumpFun,
      ) async {
    if (!adManager.canShowAd(adPosition)) {
      adManager.loadAd(adPosition);
    }
    showLoadingFun();
    AppUtils.showScanAd(context, adPosition,10, () {
      disShowLoadingFun();
    }, () {
      disShowLoadingFun();
      jumpFun();
    });
  }
}
