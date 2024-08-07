import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final String nums;
  final int result;
  const Result({super.key, required this.nums, required this.result});

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
  void backToNextPaper() {
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: ()  async {
      backToNextPaper();
      return false;
      },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 62, left: 16, right: 16),
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
                  const Text(
                    'Result',
                    style: TextStyle(
                      fontFamily: 'plaster',
                      color: Color(0xFF262626),
                      fontSize: 16,
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
            const SizedBox(
              height: 46,
            ),
            Image.asset(
              'assets/image/ic_reult_logo.webp',
              width: 196,
              height: 196,
            ),
            Center(
              child: Text(
                "+${widget.nums}ml",
                style: const TextStyle(
                  color: Color(0xFF262626),
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                  "You’ve achieved ${widget.result}% of your goal,keep it up!",
              style: const TextStyle(
                  color: Color(0xFFBABABA),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
