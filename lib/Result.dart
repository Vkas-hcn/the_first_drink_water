import 'package:flutter/material.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';
import 'package:the_first_drink_water/utils/LocalStorage.dart';

import 'bean/WaterIntake.dart';

import 'package:flutter/material.dart';
class Result extends StatefulWidget {
  final String nums;

  const Result({super.key, required this.nums});

  @override
  State<Result> createState() => _ResultState();
}
class _ResultState extends State<Result> {
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 62, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Spacer(),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/image/ic_back.webp'),
                  ),
                  Spacer(),
                  const Text(
                    'Result',
                    style: TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 16,
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
            Image.asset(
              'assets/image/ic_reult_logo.webp',
              width: 196,
              height: 196,
            ),
            Center(
              child: Text(widget.nums),
            ),
          ],
        ),
      ),
    );
  }
}

