import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';
import 'bean/WaterIntake.dart';

class DetailHistory extends StatelessWidget {
  final String dateToday;

  const DetailHistory({super.key, required this.dateToday});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TodayHistoryScreen(
        dateToday: dateToday,
      ),
    );
  }
}

class TodayHistoryScreen extends StatefulWidget {
  final String dateToday;

  const TodayHistoryScreen({super.key, required this.dateToday});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<TodayHistoryScreen> {
  List<WaterIntake> waterIntakeList = List.empty();
  late String target;
  int zongWater = 0;
  int result = 0;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      setUiData();
    });
  }

  void setUiData() {
    waterIntakeList = AppUtils.getWaterListDay(widget.dateToday);
    if (waterIntakeList.isNotEmpty) {
      target = waterIntakeList.first.target;
      zongWater = AppUtils.getWaterConsumption(widget.dateToday);
      double num = double.parse(target);
      if(num<=0){
        result = 100;
        return;
      }
      result = ((zongWater / num) * 100).toInt();
      if (result > 100) {
        result = 100;
      }
    } else {
      result = 0;
      zongWater = 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void backToNextPaper() {
    Navigator.pop(context);
  }

  void deleteIntakeById(int timestamp) {
    AppUtils.deleteWaterIntakeData(timestamp);
    setState(() {
      setUiData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          backToNextPaper();
          return false;
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/img_today_bg.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 62, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        backToNextPaper();
                      },
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset('assets/image/ic_back.webp'),
                      ),
                    ),
                    Spacer(),
                    Text(widget.dateToday,
                        style: const TextStyle(
                          fontFamily: 'plaster',
                          color: Color(0xFF262626),
                          fontSize: 16,
                        )),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
                child: Container(
                  width: 320,
                  height: 90,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/bg_toady_info.webp'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: Row(
                      children: [
                        Text("$result%",
                            style: const TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 16,
                            )),
                        Spacer(),
                        Text("$zongWater ml",
                            style: const TextStyle(
                              color: Color(0xFF00BA34),
                              fontSize: 16,
                            )),
                        Spacer(),
                        Text("${waterIntakeList.length} cup",
                            style: const TextStyle(
                              color: Color(0xFF00BA34),
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200, right: 20, left: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      waterIntakeList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: waterIntakeList.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 8),
                                              Text(
                                                '${waterIntakeList[index].ml}ml',
                                                style: const TextStyle(
                                                  fontFamily: 'plaster',
                                                  color: Color(0xFF262626),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  deleteIntakeById(
                                                      waterIntakeList[index]
                                                          .timestamp);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      waterIntakeList[index]
                                                          .time,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFFFFB763),
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
                          : Padding(
                              padding: const EdgeInsets.only(top: 122.0),
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
}
