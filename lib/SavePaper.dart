import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_first_drink_water/MainApp.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';
import 'package:the_first_drink_water/utils/LocalStorage.dart';

import 'gg/GgUtils.dart';
import 'gg/LoadingOverlay.dart';

class SavePaper extends StatelessWidget {
  const SavePaper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SavePaperScreen(),
    );
  }
}

class SavePaperScreen extends StatefulWidget {
  const SavePaperScreen({super.key});

  @override
  _SavePaperScreenState createState() => _SavePaperScreenState();
}

class _SavePaperScreenState extends State<SavePaperScreen>
    with SingleTickerProviderStateMixin {
  final netController = TextEditingController();
  final LoadingOverlay _loadingOverlay = LoadingOverlay();
  late GgUtils adManager;

  @override
  void initState() {
    super.initState();
    netController.addListener(showCreteBut);
    netController.text =
        LocalStorage().getValue(LocalStorage.drinkingWaterGoal) as String;
    adManager = AppUtils.getMobUtils(context);
    AppUtils.loadingAd(adManager);
  }

  @override
  void dispose() {
    super.dispose();
    netController.removeListener(showCreteBut);
  }

  void showCreteBut() async {
    netController.text.trim();
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
      jumpToHome();
    });
  }

  void saveWaterGoalNum() {
    FocusScope.of(context).unfocus();
    var goalNum = netController.text.trim();
    if (goalNum.isNotEmpty && AppUtils.isNumeric(goalNum)) {
      if (num.tryParse(goalNum)! > 6000 || num.tryParse(goalNum)! <= 0) {
        AppUtils.showToast("The upper limit is 6000ml, the lower limit is 1ml");
        return;
      }
      LocalStorage()
          .setValue(LocalStorage.drinkingWaterGoal, netController.text.trim());
      saveToNextPaper();
    } else {
      AppUtils.showToast("Please enter the amount of water you drink");
    }
  }

  void jumpToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainApp()),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: () async {
          backToNextPaper();
          return false;
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/bg_setting.webp'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 66),
                        const Text(
                          'Stay healthy by starting with water.',
                          style: TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            'To help you stay at your best, please set your daily water intake goal',
                            style: TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 112),
                        const Text(
                          'Today\'s goal',
                          style: TextStyle(
                            color: Color(0xFF47B96D),
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 7),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    // 仅允许输入数字
                                  ],
                                  controller: netController,
                                  decoration: const InputDecoration(
                                    hintText: 'num',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF666666),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 1,
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    saveWaterGoalNum();
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
                        'Save',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void restartApp(BuildContext context) {
    Navigator.of(context).removeRoute(ModalRoute.of(context) as Route);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SavePaper()),
        (route) => route == null);
  }
}

class CustomProgressIndicator extends StatelessWidget {
  final AnimationController controller;

  CustomProgressIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: 300,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0x33000000), // Background color #33000000
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 300 * controller.value,
              height: 12,
              decoration: BoxDecoration(
                color: Color(0xFF262626), // Progress color #262626
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              left: 300 * controller.value - 10,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Color(0xFF47B96D),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF24753F), // Circle border color #262626
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
