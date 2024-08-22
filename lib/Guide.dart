import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';
import 'package:the_first_drink_water/utils/LocalStorage.dart';

import 'MainApp.dart';
import 'StartPaper.dart';
import 'gg/GgUtils.dart';
import 'gg/LTFDW.dart';

class Guide extends StatelessWidget {
  const Guide({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool restartState = false;
  DateTime? _pausedTime;
  late LTFDW Ltfdw;
  late GgUtils adManager;

  @override
  void initState() {
    super.initState();
    print("object=================");
    startProgress();
    adManager = AppUtils.getMobUtils(context);
    Ltfdw = LTFDW(
      onAppResumed: _handleAppResumed,
      onAppPaused: _handleAppPaused,
    );
    WidgetsBinding.instance.addObserver(Ltfdw);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAdData();
    });
  }
  void initAdData() async {
    adManager.loadAd(AdWhere.OPEN);
    adManager.loadAd(AdWhere.SAVE);
    adManager.loadAd(AdWhere.BACK);
    Future.delayed(const Duration(seconds: 1), () {
      showOpenAd();
    });
  }
  void showOpenAd() {
    int elapsed = 0;
    const int timeout = 10000;
    const int interval = 500;
    print("准备展示open广告");
    Timer.periodic(const Duration(milliseconds: interval), (timer) {
      elapsed += interval;
      if (adManager.canShowAd(AdWhere.OPEN)) {
        adManager.showAd(context, AdWhere.OPEN, () {
          pageToHome();
        });
        timer.cancel();
      } else if (elapsed >= timeout) {
        print("超时，直接进入首页");
        pageToHome();
        timer.cancel();
      }
    });
  }
  void pageToHome() {
    String? stringValue =
        LocalStorage().getValue(LocalStorage.drinkingWaterGoal) as String?;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ((stringValue != null && stringValue.isNotEmpty)
                    ? MainApp()
                    : const StartPaper())),
        (route) => route == null);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startProgress() {
    _controller.forward();
  }

  void stopProgress() {
    _controller.stop();
  }

  void resetProgress() {
    _controller.reset();
  }

  void _restartApp() {
    restartApp(context);
  }

  void _handleAppResumed() {
    LocalStorage.isInBack = false;
    print("应用恢复前台");
    if (_pausedTime != null) {
      final timeInBackground =
          DateTime.now().difference(_pausedTime!).inSeconds;
      if (LocalStorage.clone_ad == true) {
        return;
      }

      print("应用恢复前台---${timeInBackground}===${LocalStorage.int_ad_show}");
      if (timeInBackground > 3 && LocalStorage.int_ad_show == false) {
        print("热启动");
        restartState = true;
        _restartApp();
      }
    }
  }

  void _handleAppPaused() {
    LocalStorage.isInBack = true;
    print("应用进入后台");
    LocalStorage.clone_ad = false;
    _pausedTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/bg_start.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 161, left: 39),
                child: SizedBox(
                  width: 78,
                  height: 78,
                  child: Image.asset('assets/image/ic_start_logo.webp'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 70, right: 40, left: 40),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomProgressIndicator(controller: _controller),
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

  void restartApp(BuildContext context) {
    Navigator.of(context).removeRoute(ModalRoute.of(context) as Route);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Guide()),
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
