import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_first_drink_water/MainApp.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';
import 'package:the_first_drink_water/utils/LocalStorage.dart';

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

  @override
  void initState() {
    super.initState();
    netController.addListener(showCreteBut);
    netController.text = LocalStorage().getValue(LocalStorage.drinkingWaterGoal) as String;
  }

  @override
  void dispose() {
    super.dispose();
    netController.removeListener(showCreteBut);
  }

  void showCreteBut() async {
    netController.text.trim();
  }

  void saveWaterGoalNum() {
    var goalNum = netController.text.trim();
    if (goalNum.isNotEmpty && AppUtils.isNumeric(goalNum)) {
      if (num.tryParse(goalNum)! > 6000 || num.tryParse(goalNum)! <=  0) {
        AppUtils.showToast("The upper limit is 6000ml, the lower limit is 0ml");
        return;
      }
      LocalStorage()
          .setValue(LocalStorage.drinkingWaterGoal, netController.text.trim());
      jumpToHome();
    } else {
      AppUtils.showToast("Please enter the amount of water you drink");
    }
  }

  void jumpToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainApp()),
            (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/bg_setting.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 66),
                  child: Text(
                    'Stay healthy by starting with water.',
                    style: TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 16,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 40, left: 32, right: 32),
                  child: Text(
                    'To help you stay at your best, please set your daily water intake goal',
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 14,
                    ),
                  ),
                ),
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
                  padding: const EdgeInsets.only(top: 7),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            keyboardType: TextInputType.number,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: GestureDetector(
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
                ),
                SizedBox(height: 50)
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
