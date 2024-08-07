import 'package:flutter/material.dart';
import 'package:the_first_drink_water/AddBmi.dart';
import 'package:the_first_drink_water/bean/BmiBean.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';

class DetailBMI extends StatelessWidget {
  final BmiBean bean;

  const DetailBMI({super.key, required this.bean});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailBMIScreen(bean: bean),
    );
  }
}

class DetailBMIScreen extends StatefulWidget {
  final BmiBean bean;

  const DetailBMIScreen({super.key, required this.bean});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<DetailBMIScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      setUiData();
    });
  }

  void setUiData() {}

  @override
  void dispose() {
    super.dispose();
  }

  void backToNextPaper() {
    Navigator.pop(context);
  }

  void jumpToAddPaper() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBmi()),
    ).then((value) {
      setState(() {
        setUiData();
      });
    });
  }

  void deleteIntakeById(int timestamp) {
    AppUtils.deleteWaterIntakeData(timestamp);
    setState(() {
      setUiData();
    });
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 56, left: 20, right: 20),
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
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Container(
                  width: 320,
                  height: 220,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/bg_toady_info.webp'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          AppUtils.calculateBMIState(
                            widget.bean.height,
                            widget.bean.weight,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          AppUtils.getFormattedDate2(widget.bean.timestamp),
                          style: const TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 22),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDD9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  AppUtils.calculateBMINum(
                                    widget.bean.height,
                                    widget.bean.weight,
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFFFF801E),
                                    fontSize: 16,
                                  )),
                              SizedBox(height: 8),
                              const Text("Average",
                                  style: TextStyle(
                                    color: Color(0xFFFFB763),
                                    fontSize: 10,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Spacer(),
                            const Text(
                              'Weight:',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${widget.bean.weight}KG',
                              style: const TextStyle(
                                color: Color(0xFF22AB2E),
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                            const Text(
                              'Height:',
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${widget.bean.height}cm',
                              style: const TextStyle(
                                color: Color(0xFF22AB2E),
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              widget.bean.remark.isNotEmpty?
              const Padding(
                padding: EdgeInsets.only(left: 40.0, top: 16),
                child: Row(
                  children: [
                    Text(
                      'Notes',
                      style: TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ):SizedBox(),
              if (widget.bean.remark.isNotEmpty) Padding(
                padding: const EdgeInsets.only(top: 12, right: 20, left: 20),
                child: Stack(alignment: Alignment.topRight, children: [
                  Container(
                    width: 320,
                    height: 260,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/bg_toady_info.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.bean.remark,
                        style: const TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 50),
                  //   child: Image.asset(
                  //       width: 80, height: 80, 'assets/image/ic_pa_paer.webp'),
                  // )
                ]),
              ) else SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
