import 'package:flutter/material.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';
import 'package:the_first_drink_water/utils/LocalStorage.dart';
import 'DetailHistory.dart';
import 'bean/WaterIntake.dart';

class AllHistory extends StatelessWidget {
  const AllHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AllHistoryScreen(),
    );
  }
}

class AllHistoryScreen extends StatefulWidget {
  const AllHistoryScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<AllHistoryScreen> {
  Map<String, List<WaterIntake>> waterIntakeByDate = {};
  int daysAll = 0;
  int avgIntakeAll = 0;
  int completionRateAll = 0;

  int completionRateDay = 0;
  int waterMlDay = 0;
  int waterCupDay = 0;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      setUIData();
    });
  }

  void setUIData() {
    waterIntakeByDate = AppUtils.getWaterIntakeByDate();
    print("setUIData===${waterIntakeByDate.isNotEmpty}");
    if (waterIntakeByDate.isNotEmpty) {

      daysAll = AppUtils.getAllWaterDays();
      avgIntakeAll =
          AppUtils.getAllTotalWaterIntake() ~/ AppUtils.getAllWaterDays();
      completionRateAll = AppUtils.getAllCompletionRate();
    } else {
      completionRateAll = 0;
      avgIntakeAll = 0;
      daysAll = 0;
    }
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
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 62, left: 20, right: 20),
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
                    const Spacer(),
                    const Text("History",
                        style: TextStyle(
                          fontFamily: 'plaster',
                          color: Color(0xFF262626),
                          fontSize: 16,
                        )),
                    const Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
                child: Container(
                  width: 320,
                  height: 90,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/bg_toady_info.webp'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: Row(
                      children: [
                        Text("${daysAll} Days",
                            style: const TextStyle(
                              color: Color(0xFF00BA34),
                              fontSize: 16,
                            )),
                        Spacer(),
                        Text("$avgIntakeAll ml",
                            style: const TextStyle(
                              color: Color(0xFF00BA34),
                              fontSize: 16,
                            )),
                        Spacer(),
                        Text("$completionRateAll%",
                            style: const TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 200, right: 20, left: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (waterIntakeByDate.isNotEmpty)
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 6.0,
                              crossAxisSpacing: 6.0,
                              childAspectRatio: 1,
                            ),
                            itemCount: waterIntakeByDate.length,
                            itemBuilder: (context, index) {
                              var dailyIntake =
                                  waterIntakeByDate.values.elementAt(index);
                              var date = waterIntakeByDate.values
                                  .elementAt(index)[index]
                                  .date;

                              completionRateDay =
                                  AppUtils.completionRateOnACertainDay(
                                      dailyIntake.first.date);
                              waterMlDay = AppUtils.getWaterConsumption(
                                  dailyIntake.first.date);
                              waterCupDay = AppUtils.getWaterListDay(
                                      dailyIntake.first.date)
                                  .length;
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    jumToTodayPaper(context, date);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/image/bg_history.webp'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${waterIntakeByDate.isNotEmpty?completionRateDay:0}%",
                                                style: TextStyle(
                                                  color: (completionRateDay >=
                                                          100)
                                                      ? const Color(0xFF00BA34)
                                                      : const Color(0xFFFFA401),
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const Spacer(),
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: (completionRateDay >=
                                                        100)
                                                    ? Image.asset(
                                                        'assets/image/ic_finish.webp')
                                                    : Image.asset(
                                                        'assets/image/ic_dis_finish.webp'),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 9),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "${waterIntakeByDate.isNotEmpty?waterMlDay:0}ml",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 9),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "${waterIntakeByDate.isNotEmpty?waterCupDay:0}Cups",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Spacer(),
                                              Text(
                                                dailyIntake[index].date,
                                                style: const TextStyle(
                                                  color: Color(0xFFBABABA),
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 122.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    width: 134,
                                    height: 114,
                                    child:
                                        Image.asset('assets/image/ic_em.webp'),
                                  ),
                                  const Text(
                                    "No records yet.",
                                    style: TextStyle(
                                      color: Color(0xFFBBC8C2),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

  void jumToTodayPaper(BuildContext context, String date) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailHistory(
                dateToday: date,
              )),
    ).then((value) {
      setState(() {
        setUIData();
      });
    });
  }
}
