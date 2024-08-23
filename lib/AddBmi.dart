import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_first_drink_water/bean/BmiBean.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';

import 'DetailBMI.dart';
import 'Result.dart';
import 'gg/GgUtils.dart';
import 'gg/LoadingOverlay.dart';

class AddBmi extends StatelessWidget {
  const AddBmi({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AddBmiScreen(),
    );
  }
}

class AddBmiScreen extends StatefulWidget {
  const AddBmiScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<AddBmiScreen> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final notesController = TextEditingController();
  final LoadingOverlay _loadingOverlay = LoadingOverlay();
  late GgUtils adManager;
  late BmiBean bean;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      setUiData();
    });
    heightController.addListener(showHeight);
    heightController.text = "163";
    weightController.addListener(showHeight);
    weightController.text = "60";
    notesController.addListener(showHeight);
    adManager = AppUtils.getMobUtils(context);
    AppUtils.loadingAd(adManager);
  }

  void setUiData() {
    // waterIntakeList = AppUtils.getWaterListDay(widget.dateToday);
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
    heightController.removeListener(showHeight);
    weightController.removeListener(showWeightController);
    notesController.removeListener(showNotesController);
  }

  void showHeight() async {
    heightController.text.trim();
  }

  void showNotesController() async {
    notesController.text.trim();
  }

  void showWeightController() async {
    weightController.text.trim();
  }

  void backToNextPaper() async {
    AppUtils.backToNextPaper(context, adManager, AdWhere.BACK, () {
      setState(() {
        _loadingOverlay.show(context);
      });
    }, () {
      setState(() {
        _loadingOverlay.hide();
      });
    });
  }

  void saveToNextPaper() async {
    if (!adManager.canShowAd(AdWhere.SAVE)) {
      adManager.loadAd(AdWhere.SAVE);
    }
    setState(() {
      _loadingOverlay.show(context);
    });
    AppUtils.showScanAd(context, AdWhere.SAVE, 5, () {
      setState(() {
        _loadingOverlay.hide();
      });
    }, () {
      setState(() {
        _loadingOverlay.hide();
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DetailBMI(bean: bean)),
            (Route<dynamic> route) => route.isFirst,  // 只保留第一个路由，即 A
      );
    });

  }

  void deleteIntakeById(int timestamp) {
    AppUtils.deleteWaterIntakeData(timestamp);
    setState(() {
      setUiData();
    });
  }

  void saveWaterData() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    bean = BmiBean(
        weight: weightController.text,
        height: heightController.text,
        remark: notesController.text,
        timestamp: timestamp);
    AppUtils.setBmiData(bean);
  }

  void saveBmiNum() {
    if (weightController.text.trim().isEmpty ||
        heightController.text.trim().isEmpty) {
      AppUtils.showToast("Please enter a numeric value");
      return;
    }
    if (num.tryParse(weightController.text)! <= 0 ||
        num.tryParse(heightController.text)! <= 0) {
      AppUtils.showToast("Please enter a value greater than zero");
      return;
    }
    saveWaterData();
    saveToNextPaper();
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40, left: 20, right: 20),
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
                      const Text("BMI",
                          style: TextStyle(
                            fontFamily: 'plaster',
                            color: Color(0xFF262626),
                            fontSize: 16,
                          )),
                      Spacer(),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Weight',
                        style: TextStyle(
                          fontFamily: 'plaster',
                          color: Color(0xFF262626),
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 20, left: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/bg_bmi_item.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 250,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: weightController,
                            maxLines: 1,
                            maxLength: 5,
                            buildCounter: (
                              BuildContext context, {
                              required int currentLength,
                              required bool isFocused,
                              required int? maxLength,
                            }) {
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF262626),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'weight',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF999999),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Spacer(),
                        const Text(
                          'KG',
                          style: TextStyle(
                            fontFamily: 'plaster',
                            color: Color(0xFF262626),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Height',
                        style: TextStyle(
                          fontFamily: 'plaster',
                          color: Color(0xFF262626),
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, right: 20, left: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/bg_bmi_item.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 250,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: heightController,
                            maxLines: 1,
                            maxLength: 5,
                            buildCounter: (
                              BuildContext context, {
                              required int currentLength,
                              required bool isFocused,
                              required int? maxLength,
                            }) {
                              return null; // 隐藏文本计数
                            },
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF262626),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'height',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF999999),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Spacer(),
                        const Text(
                          'CM',
                          style: TextStyle(
                            fontFamily: 'plaster',
                            color: Color(0xFF262626),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Notes',
                        style: TextStyle(
                          fontFamily: 'plaster',
                          color: Color(0xFF262626),
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, right: 20, left: 20),
                  child: Stack(alignment: Alignment.topRight, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/bg_bmi_item.webp'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: SizedBox(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: notesController,
                          maxLength: 500,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            hintText: 'Add notes……',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF262626),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 50),
                    //   child: Image.asset(
                    //       width: 80, height: 80, 'assets/image/ic_pa_paer.webp'),
                    // )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 67),
                  child: GestureDetector(
                    onTap: () {
                      saveBmiNum();
                    },
                    child: Container(
                      width: 145,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF262626),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text(
                          'Calculate',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
