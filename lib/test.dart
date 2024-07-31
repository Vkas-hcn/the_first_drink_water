import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Progress Indicator'),
        ),
        body: Center(
          child: ProgressControl(),
        ),
      ),
    );
  }
}

class ProgressControl extends StatefulWidget {
  @override
  _ProgressControlState createState() => _ProgressControlState();
}

class _ProgressControlState extends State<ProgressControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomProgressIndicator(controller: _controller),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: startProgress,
              child: Text('Start'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: stopProgress,
              child: Text('Stop'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: resetProgress,
              child: Text('Reset'),
            ),
          ],
        ),
      ],
    );
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
              height: 20,
              decoration: BoxDecoration(
                color: Color(0x33000000), // Background color #33000000
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 300 * controller.value,
              height: 20,
              decoration: BoxDecoration(
                color: Color(0xFF262626), // Progress color #262626
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              left: 300 * controller.value - 10,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF262626), // Circle border color #262626
                    width: 3,
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
