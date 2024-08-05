import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_first_drink_water/Home.dart';
import 'package:the_first_drink_water/StartPaper.dart';

import 'MainApp.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    startProgress();
    _controller.addListener(() {
      if (_controller.isCompleted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>  MainApp()),
        );
      }
    });
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
