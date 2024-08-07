import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_first_drink_water/AllHistory.dart';
import 'package:the_first_drink_water/Result.dart';
import 'package:the_first_drink_water/StartPaper.dart';
import 'package:the_first_drink_water/DetailHistory.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';
import 'package:the_first_drink_water/utils/LocalStorage.dart';
import 'SavePaper.dart';
import 'bean/WaterIntake.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<HomeScreen> {
  List<String> drinkNums = [""];
  List<WaterIntake> waterTodayIntakeList = List.empty();
  late String toNum;
  int zongWater = 0;
  int days = 0;
  int avgIntake = 0;
  int result = 0;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      toNum = LocalStorage().getValue(LocalStorage.drinkingWaterGoal) as String;
      updateDailyTarget();
      setUiData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setUiData();
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/bg_setting.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 62, left: 24, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 123,
                      height: 24,
                      child: Image.asset('assets/image/ic_panda_drink.webp'),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        jumpToAllHistoryPaper();
                      },
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: Image.asset('assets/image/ic_clock.webp'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40, left: 40),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 112),
                        child: Text(
                          'Today\'s goal',
                          style: TextStyle(
                            color: Color(0xFF47B96D),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              jumpToStartPaper();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    toNum,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Color(0xFF262626),
                                    ),
                                  ),
                                ),
                                const Text(
                                  'MI',
                                  style: TextStyle(
                                    color: Color(0xFFB0B0B0),
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.asset(
                                      width: 12,
                                      height: 12,
                                      'assets/image/ic_edit.webp'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                              width: 244,
                              height: 156,
                              'assets/image/ic_home_logo.webp'),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 5),
                            child: CustomCircularRing(
                                percentage: result, zongWater: zongWater),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 36,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showCustomDialog(context);
                              },
                              child: Image.asset('assets/image/ic_add.webp',
                                  width: 36, height: 36),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: drinkNums.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        print("点击item-${drinkNums[index]}");
                                        saveWaterData(drinkNums[index]);
                                        // 延迟1秒钟执行ResultApp
                                        Future.delayed( Duration(milliseconds: 200), () {
                                          ResultApp(context, drinkNums[index]);
                                        });
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/image/bg_but.webp',
                                            width: 90,
                                            height: 36,
                                          ),
                                          Text(
                                            '+${drinkNums[index]}ml',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          jumpToTodayApp(context);
                        },
                        child: Row(
                          children: [
                            const Text(
                              "Today’s hydration records",
                              style: TextStyle(
                                color: Color(0xFF1C5A43),
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                            Image.asset(
                              'assets/image/ic_arw_2.webp',
                              width: 16,
                              height: 16,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          height: 1,
                          color: Color(0xFFE7E7E7),
                        ),
                      ),
                      if (waterTodayIntakeList.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: min(3, waterTodayIntakeList.length),
                              itemBuilder: (context, index) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/image/ic_water_droplet.webp',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${waterTodayIntakeList[index].ml}ml',
                                            style: const TextStyle(
                                              color: Color(0xFF5CE69C),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              deleteIntakeById(
                                                  waterTodayIntakeList[index]
                                                      .timestamp);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  waterTodayIntakeList[index]
                                                      .time,
                                                  style: const TextStyle(
                                                    color: Color(0xFFFFB763),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Image.asset(
                                                  'assets/image/ic_delete.webp',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                        )
                      else
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 80.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 134,
                                      height: 114,
                                      child: Image.asset(
                                          'assets/image/ic_em.webp'),
                                    ),
                                    const Text(
                                      "No records yet.",
                                      style: TextStyle(
                                        color: Color(0xFFBBC8C2),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (AppUtils.getWaterIntakeByDate().isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            jumpToAllHistoryPaper();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF262626),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 16),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 204,
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                          children: <TextSpan>[
                                            const TextSpan(
                                                text:
                                                    'You’ve been drinking water for '),
                                            TextSpan(
                                              text: '$days',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(
                                                text: ' days, averaging '),
                                            TextSpan(
                                              text: '$avgIntake',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(
                                                text: ' ml per day.'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    const Text(
                                      'All',
                                      style: TextStyle(
                                        color: Color(0xFF47B96D),
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Image.asset(
                                          'assets/image/ic_arw_2.webp'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateDailyTarget() {
    String date = AppUtils.getNowDate();
    AppUtils.updateTargetForDate(date, toNum);
  }

  void jumpToStartPaper() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  const SavePaper(),
      ),
    );
  }

  void jumpToAllHistoryPaper() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllHistory()),
    ).then((value) {
      setState(() {
        setUiData();
      });
    });
  }

  int getTodayWaterData() {
    DateTime now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');
    String formattedDate = '$year-$month-$day';
    return AppUtils.getWaterConsumption(formattedDate);
  }

  void deleteIntakeById(int timestamp) {
    AppUtils.deleteWaterIntakeData(timestamp);
    setState(() {
      waterTodayIntakeList = AppUtils.getTodayWaterIntakeData();
    });
  }

  void setUiData() {
    drinkNums = AppUtils.getDrinkNum();
    waterTodayIntakeList = AppUtils.getTodayWaterIntakeData();
    zongWater = getTodayWaterData();
    days = AppUtils.getAllWaterDays();
    int daysWater = AppUtils.getAllWaterDays();
    if (daysWater > 0) {
      avgIntake = AppUtils.getAllTotalWaterIntake() ~/ daysWater;
    } else {
      avgIntake = 0;
    }
    final double toNumDouble = double.parse(toNum);
    if(toNumDouble<=0){
      result = 100;
      return;
    }
    result = ((zongWater / toNumDouble) * 100).toInt();
    if (result > 100) {
      result = 100;
    }
  }

  void saveWaterData(String waterNum) {
    DateTime now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');
    String formattedDate = '$year-$month-$day';
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    String formattedTime = '$hour:$minute';
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    String? targetValue =
        LocalStorage().getValue(LocalStorage.drinkingWaterGoal) as String?;
    WaterIntake bean = WaterIntake(
        date: formattedDate,
        target: targetValue!,
        time: formattedTime,
        ml: waterNum,
        timestamp: timestamp);
    AppUtils.setWaterIntakeData(bean);
    setState(() {
      setUiData();
    });
    waterTodayIntakeList = AppUtils.getWaterIntakeData();
    for (var intake in waterTodayIntakeList) {
      print('总数据----=ml: ${intake.ml}, time: ${intake.time}, date: ${intake.date}, target: ${intake.target}, timestamp: ${intake.timestamp}');
    }
  }

  void ResultApp(BuildContext context, String num) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Result(nums: num,result: result),
      ),
    );
  }

  void jumpToTodayApp(BuildContext context) {
    String date = AppUtils.getNowDate();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailHistory(
                dateToday: date,
              )),
    ).then((value) {
      setState(() {
        setUiData();
      });
    });
  }

  void showCustomDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialog(
          controller: _controller,
          onConfirm: () {
            String inputValue = _controller.text;
            Navigator.of(context).pop();
            print("User input: $inputValue ml");
            if (!AppUtils.isNumeric(inputValue) || num.tryParse(inputValue)!<= 0) {
              AppUtils.showToast("Please enter legal numbers");
              return;
            }
            AppUtils.addDrinkNum(inputValue);
            setState(() {
              drinkNums = AppUtils.getDrinkNum();
            });
          },
          onCancel: () {
            Navigator.of(context).pop();
            // Handle cancel action
          },
        );
      },
    );
  }
}

class CustomCircularRing extends StatelessWidget {
  final int percentage;
  final int zongWater;

  CustomCircularRing({required this.percentage, required this.zongWater});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 77,
      height: 77,
      child: CustomPaint(
        painter:
            CircularRingPainter(percentage: percentage, zongWater: zongWater),
      ),
    );
  }
}

class CircularRingPainter extends CustomPainter {
  final int percentage;
  final int zongWater;

  CircularRingPainter({required this.percentage, required this.zongWater});

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerRingPaint = Paint()
      ..color = Color(0xFF24753F)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Paint innerCirclePaint = Paint()..color = Color(0xFF47B96D);
    Paint bgCirclePaint = Paint()..color = Colors.grey;

    double radius = (size.width / 2) - 1.5; // Adjust for stroke width
    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw outer ring
    canvas.drawCircle(center, radius, outerRingPaint);
    canvas.drawCircle(center, radius - 1, bgCirclePaint);

    // Draw inner circle
    double innerRadius = radius - 1;
    Rect innerCircleRect = Rect.fromCircle(center: center, radius: innerRadius);
    double filledHeight = innerCircleRect.height * (percentage / 100);

    // Save the current canvas state
    canvas.save();

    // Clip and draw the filled part of the inner circle
    canvas.clipRect(Rect.fromLTWH(
        innerCircleRect.left,
        innerCircleRect.bottom - filledHeight,
        innerCircleRect.width,
        filledHeight));
    canvas.drawCircle(center, innerRadius, innerCirclePaint);

    // Restore the canvas state to remove the clip
    canvas.restore();

    // Draw text
    drawCenteredText(canvas, size, "${zongWater}ML", Colors.white, -8);
    drawCenteredText(canvas, size, "${percentage.toInt()}%", Colors.white, 6);
  }

  void drawCenteredText(
      Canvas canvas, Size size, String text, Color color, double dy) {
    TextSpan span = new TextSpan(
        style: new TextStyle(color: color, fontSize: 12.0), text: text);
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2 + dy);
    tp.paint(canvas, textCenter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CustomDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  CustomDialog({
    required this.controller,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xA6000000),
      insetPadding: EdgeInsets.symmetric(horizontal: 32),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer()
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 46,
                      height: 36,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('ml'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: onCancel,
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: onConfirm,
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
