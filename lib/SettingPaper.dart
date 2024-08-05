import 'dart:async';

import 'package:flutter/material.dart';

class SettingPaper extends StatelessWidget {
  const SettingPaper({super.key});

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
  final netController = TextEditingController();
  final TextEditingController _unameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    netController.addListener(showCreteBut);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    startProgress();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    netController.removeListener(showCreteBut);
  }

  void showCreteBut() async {
    netController.text.trim();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          children: [
            Stack(alignment: Alignment.topCenter, children: [
              Image.asset('assets/image/bg_setting_top.webp'),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset(width: 31, height: 24, 'assets/image/ic_me.webp'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 110.0,left: 20,right: 20),
                child: Image.asset( 'assets/image/bg_setting_mid_2.png'),
              ),
            ]),


        Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 12, bottom: 6),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFF47B96D),
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Text(
                        'Share',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                          width: 20, height: 20, 'assets/image/ic_be.webp')
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFF47B96D),
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Text(
                        'Comment',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                          width: 20, height: 20, 'assets/image/ic_be.webp')
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFF47B96D),
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Text(
                        'User agreement',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                          width: 20, height: 20, 'assets/image/ic_be.webp')
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFF47B96D),
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                          width: 20, height: 20, 'assets/image/ic_be.webp')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void restartApp(BuildContext context) {
    Navigator.of(context).removeRoute(ModalRoute.of(context) as Route);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SettingPaper()),
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
