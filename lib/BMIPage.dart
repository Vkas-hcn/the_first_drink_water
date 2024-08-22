import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_first_drink_water/AddBmi.dart';
import 'package:the_first_drink_water/DetailBMI.dart';
import 'package:the_first_drink_water/bean/BmiBean.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';

import 'gg/GgUtils.dart';
import 'gg/LoadingOverlay.dart';

class BMIPage extends StatelessWidget {
  const BMIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BMIPageScreen(),
    );
  }
}

class BMIPageScreen extends StatefulWidget {
  const BMIPageScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<BMIPageScreen> {
  List<BmiBean> bmiBeanList = List.empty();
  late String target;
  int zongWater = 0;
  int result = 0;
  final LoadingOverlay _loadingOverlay = LoadingOverlay();
  late GgUtils adManager;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      setUiData();
    });
    adManager = AppUtils.getMobUtils(context);
    AppUtils.loadingAd(adManager);
  }

  void setUiData() {
    bmiBeanList = AppUtils.getBMIListData();
    // if (waterIntakeList.isNotEmpty) {
    //   target = waterIntakeList.first.target;
    //   zongWater = AppUtils.getWaterConsumption(widget.dateToday);
    //   result = ((zongWater / (double.parse(target))) * 100).toInt();
    //   if (result > 100) {
    //     result = 100;
    //   }
    // } else {
    //   result = 0;
    //   zongWater = 0;
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void backToNextPaper() {
    Navigator.pop(context);
  }

  void jumpToAddPaper() {
    AppUtils.goToNextPaper(context, adManager, AdWhere.Next, () {
      setState(() {
        _loadingOverlay.show(context);
      });
    }, () {
      setState(() {
        _loadingOverlay.hide();
      });
    }, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddBmi()),
      ).then((value) {
        setState(() {
          setUiData();
        });
      });
    });
  }

  void jumpToDetailPaper(BmiBean bean) {
    AppUtils.goToNextPaper(context, adManager, AdWhere.Next, () {
      setState(() {
        _loadingOverlay.show(context);
      });
    }, () {
      setState(() {
        _loadingOverlay.hide();
      });
    }, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailBMI(bean: bean)),
      );
    });
  }

  void deleteIntakeById(int timestamp) {
    AppUtils.deleteBmiData(timestamp);
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
              const Padding(
                padding: EdgeInsets.only(top: 56, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("BMI",
                        style: TextStyle(
                          fontFamily: 'plaster',
                          color: Color(0xFF262626),
                          fontSize: 16,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 110, left: 20, right: 20),
                child: Container(
                  width: 320,
                  height: 127,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/bg_toady_info.webp'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 22),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDD9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Average",
                                  style: TextStyle(
                                    color: Color(0xFFFFB763),
                                    fontSize: 10,
                                  )),
                              const SizedBox(height: 8),
                              Text(AppUtils.getBmiStats("average"),
                                  style: const TextStyle(
                                    color: Color(0xFF31C347),
                                    fontSize: 18,
                                  )),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 22),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDD9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Highest",
                                  style: TextStyle(
                                    color: Color(0xFFFFB763),
                                    fontSize: 10,
                                  )),
                              SizedBox(height: 8),
                              Text(AppUtils.getBmiStats("highest"),
                                  style: const TextStyle(
                                    color: Color(0xFF31C347),
                                    fontSize: 18,
                                  )),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 22),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDD9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Lowest",
                                  style: TextStyle(
                                    color: Color(0xFFFFB763),
                                    fontSize: 10,
                                  )),
                              SizedBox(height: 8),
                              Text(AppUtils.getBmiStats("lowest"),
                                  style: const TextStyle(
                                    color: Color(0xFF31C347),
                                    fontSize: 18,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 230.0),
                child: GestureDetector(
                  onTap: () {
                    jumpToAddPaper();
                  },
                  child: SizedBox(
                    height: 96,
                    child: Image.asset('assets/image/ic_add_bmi.webp'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300, right: 20, left: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (bmiBeanList.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: bmiBeanList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    jumpToDetailPaper(bmiBeanList[index]);
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 12),
                                        child: Container(
                                          height: 70,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/image/bg_toady_info.webp'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 12),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFFFDD9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        'BMI',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFFFC072),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                        AppUtils
                                                            .calculateBMINum(
                                                                bmiBeanList[
                                                                        index]
                                                                    .height,
                                                                bmiBeanList[
                                                                        index]
                                                                    .weight),
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFFFF801F),
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Container(
                                                  width: 90,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFFFDD9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      AppUtils
                                                          .calculateBMIState(
                                                              bmiBeanList[index]
                                                                  .height,
                                                              bmiBeanList[index]
                                                                  .weight),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    deleteIntakeById(
                                                        bmiBeanList[index]
                                                            .timestamp);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 32),
                                                          Image.asset(
                                                            'assets/image/icon_remove_bmi.webp',
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        AppUtils
                                                            .getFormattedDate(
                                                                bmiBeanList[
                                                                        index]
                                                                    .timestamp),
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFFBFBFBF),
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 122.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: 134,
                                    height: 114,
                                    child:
                                        Image.asset('assets/image/ic_em.webp'),
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
