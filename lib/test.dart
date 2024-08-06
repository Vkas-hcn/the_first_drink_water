import 'package:flutter/material.dart';
import 'dart:convert';

import 'bean/WaterIntake.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Intake App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final String waterDataJson = '[{"ml":"1200","time":"16:49","date":"2024-08-07","target":"1500"},{"ml":"1200","time":"16:49","date":"2024-08-07","target":"1500"},{"ml":"300","time":"12:30","date":"2024-08-06","target":"1500"},{"ml":"400","time":"08:00","date":"2024-08-05","target":"1500"}]';

  @override
  Widget build(BuildContext context) {
    // 解析 JSON 数据
    List<dynamic> jsonData = jsonDecode(waterDataJson);
    List<WaterIntake> waterIntakeList = jsonData.map((json) => WaterIntake.fromJson(json)).toList();

    // 统计数据
    Map<String, List<WaterIntake>> waterIntakeByDate = {};
    for (var record in waterIntakeList) {
      if (!waterIntakeByDate.containsKey(record.date)) {
        waterIntakeByDate[record.date] = [];
      }
      waterIntakeByDate[record.date]!.add(record);
    }

    int drinkingDays = waterIntakeByDate.length;
    int totalWaterIntake = waterIntakeList.fold(0, (sum, item) => sum + int.parse(item.ml));
    int avgWaterIntake = (totalWaterIntake / drinkingDays).floor();

    int completedDays = waterIntakeByDate.entries.fold(0, (count, entry) {
      int dailyTotal = entry.value.fold(0, (sum, item) => sum + int.parse(item.ml));
      int target = int.parse(entry.value.first.target);
      if (dailyTotal >= target) {
        count += 1;
      }
      return count;
    });

    double completionRate = completedDays / drinkingDays;

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Intake App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'You’ve been drinking water for '),
                  TextSpan(
                    text: '$drinkingDays',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' days, averaging '),
                  TextSpan(
                    text: '$avgWaterIntake',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' ml per day.'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Completion Rate: ${(completionRate * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
