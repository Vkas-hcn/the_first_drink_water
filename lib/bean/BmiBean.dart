import 'dart:convert';

import '../utils/LocalStorage.dart';

class BmiBean {
  final String weight;
  final String height;
  final String remark;
  final int timestamp;
  BmiBean({
    required this.weight,
    required this.height,
    required this.remark,
    required this.timestamp,
  });

  // Factory constructor to create an instance from JSON
  factory BmiBean.fromJson(Map<String, dynamic> json) {
    return BmiBean(
      weight: json['weight'],
      height: json['height'],
      remark: json['remark'],
      timestamp: json['timestamp'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'remark': remark,
      'timestamp': timestamp,
    };
  }




  // Calculate BMI
  double calculateBmi() {
    double weightKg = double.parse(weight);
    double heightM = double.parse(height) / 100; // assuming height is in cm
    return weightKg / (heightM * heightM);
  }

  static Map<String, String> calculateBmiStatistics(List<BmiBean> bmiList) {
    if (bmiList.isEmpty) {
      return {
        'average': '0.00',
        'highest': '0.00',
        'lowest': '0.00',
      };
    }

    double totalBmi = 0.0;
    double highestBmi = double.negativeInfinity;
    double lowestBmi = double.infinity;

    for (BmiBean bmiBean in bmiList) {
      double bmi = bmiBean.calculateBmi();
      totalBmi += bmi;
      if (bmi > highestBmi) {
        highestBmi = bmi;
      }
      if (bmi < lowestBmi) {
        lowestBmi = bmi;
      }
    }

    double averageBmi = totalBmi / bmiList.length;

    return {
      'average': averageBmi.toStringAsFixed(2),
      'highest': highestBmi.toStringAsFixed(2),
      'lowest': lowestBmi.toStringAsFixed(2),
    };
  }

}
