import 'package:flutter/material.dart';
import 'package:the_first_drink_water/Result.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';
import 'package:the_first_drink_water/utils/LocalStorage.dart';
import 'bean/WaterIntake.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<HomeScreen> {
  final heNumController = TextEditingController();
  List<String> drinkNums = [""];
  List<WaterIntake> waterIntakeList = List.empty();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    heNumController.text =
        (LocalStorage().getValue(LocalStorage.drinkingWaterGoal) as String?)!;
    heNumController.addListener(showCreteBut);
  }

  @override
  void dispose() {
    super.dispose();
    heNumController.removeListener(showCreteBut);
  }

  void showCreteBut() async {
    heNumController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    drinkNums = AppUtils.getDrinkNum();
    waterIntakeList = AppUtils.getWaterIntakeData();
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/bg_setting.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 62, left: 24, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 123,
                      height: 24,
                      child: Image.asset('assets/image/ic_panda_drink.webp'),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: Image.asset('assets/image/ic_clock.webp'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 40, left: 40),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        padding: EdgeInsets.only(top: 7),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: heNumController,
                                  decoration: const InputDecoration(
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
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Image.asset(
                                    width: 12,
                                    height: 12,
                                    'assets/image/ic_edit.webp'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                              width: 244,
                              height: 156,
                              'assets/image/ic_home_logo.webp'),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 5),
                            child: CustomCircularRing(percentage: 40),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 36,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showCustomDialog(context);
                              },
                              child: Image.asset('assets/image/ic_add.webp',
                                  width: 36, height: 36),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: drinkNums.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        print("点击item-${drinkNums[index]}");
                                        saveWaterData(drinkNums[index]);
                                        ResultApp(context, drinkNums[index]);
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/image/bg_but.webp',
                                            width: 90,
                                            height: 36,
                                          ),
                                          Text(
                                            '+${drinkNums[index]}ml',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          const Text(
                            "Today’s hydration records",
                            style: TextStyle(
                              color: Color(0xFF1C5A43),
                              fontSize: 12,
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            'assets/image/ic_arw_2.webp',
                            width: 16,
                            height: 16,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          height: 1,
                          color: Color(0xFFE7E7E7),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: waterIntakeList.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/image/ic_water_droplet.webp',
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${waterIntakeList[index].ml}ml',
                                          style: const TextStyle(
                                            color: Color(0xFF5CE69C),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          waterIntakeList[index].time,
                                          style: const TextStyle(
                                            color: Color(0xFFFFB763),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          'assets/image/ic_delete.webp',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
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

  void saveWaterData(String waterNum) {
    DateTime now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');
    String formattedDate = '$year-$month-$day';
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    String formattedTime = '$hour:$minute';
    String? targetValue =
        LocalStorage().getValue(LocalStorage.drinkingWaterGoal) as String?;
    WaterIntake bean = WaterIntake(
        date: formattedDate,
        target: targetValue!,
        time: formattedTime,
        ml: waterNum);
    AppUtils.setWaterIntakeData(bean);
    setState(() {
      waterIntakeList = AppUtils.getWaterIntakeData();
    });
  }

  void ResultApp(BuildContext context, String num) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Result(nums: num),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialog(
          controller: _controller,
          onConfirm: () {
            String inputValue = _controller.text;
            Navigator.of(context).pop();
            print("User input: $inputValue ml");
            if (!AppUtils.isNumeric(inputValue)) {
              AppUtils.showToast("Please enter legal numbers");
              return;
            }
            AppUtils.addDrinkNum(inputValue);
            setState(() {
              drinkNums = AppUtils.getDrinkNum();
            });
          },
          onCancel: () {
            Navigator.of(context).pop();
            // Handle cancel action
          },
        );
      },
    );
  }
}

class CustomCircularRing extends StatelessWidget {
  final double percentage;

  CustomCircularRing({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 77,
      height: 77,
      child: CustomPaint(
        painter: CircularRingPainter(percentage: percentage),
      ),
    );
  }
}

class CircularRingPainter extends CustomPainter {
  final double percentage;

  CircularRingPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerRingPaint = Paint()
      ..color = Color(0xFF24753F)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Paint innerCirclePaint = Paint()..color = Color(0xFF47B96D);
    Paint bgCirclePaint = Paint()..color = Colors.grey;

    double radius = (size.width / 2) - 1.5; // Adjust for stroke width
    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw outer ring
    canvas.drawCircle(center, radius, outerRingPaint);
    canvas.drawCircle(center, radius - 1, bgCirclePaint);

    // Draw inner circle
    double innerRadius = radius - 1;
    Rect innerCircleRect = Rect.fromCircle(center: center, radius: innerRadius);
    double filledHeight = innerCircleRect.height * (percentage / 100);

    // Save the current canvas state
    canvas.save();

    // Clip and draw the filled part of the inner circle
    canvas.clipRect(Rect.fromLTWH(
        innerCircleRect.left,
        innerCircleRect.bottom - filledHeight,
        innerCircleRect.width,
        filledHeight));
    canvas.drawCircle(center, innerRadius, innerCirclePaint);

    // Restore the canvas state to remove the clip
    canvas.restore();

    // Draw text
    drawCenteredText(
        canvas, size, "${percentage.toInt()}/100", Colors.white, -8);
    drawCenteredText(canvas, size, "${percentage.toInt()}%", Colors.white, 6);
  }

  void drawCenteredText(
      Canvas canvas, Size size, String text, Color color, double dy) {
    TextSpan span = new TextSpan(
        style: new TextStyle(color: color, fontSize: 12.0), text: text);
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2 + dy);
    tp.paint(canvas, textCenter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CustomDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  CustomDialog({
    required this.controller,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xA6000000),
      insetPadding: EdgeInsets.symmetric(horizontal: 32),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer()
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 46,
                      height: 36,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('ml'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: onCancel,
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: onConfirm,
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
