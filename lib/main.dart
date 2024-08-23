import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:the_first_drink_water/Guide.dart';
import 'package:the_first_drink_water/StartPaper.dart';
import 'package:the_first_drink_water/gg/Get2Data.dart';
import 'package:the_first_drink_water/gg/GgUtils.dart';
import 'package:the_first_drink_water/utils/AppUtils.dart';
import 'package:the_first_drink_water/utils/LocalStorage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
   LocalStorage().init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(providers: [
      Provider<GgUtils>(
        create: (_) => GgUtils(),
      ),
      ChangeNotifierProvider(create: (_) => Get2Data()),
    ], child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      navigatorKey: AppUtils.navigatorKey, // 设置全局 navigatorKey
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print("object=================main");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adUtils = Provider.of<Get2Data>(context, listen: false);
      Get2Data.initializeFqaId();
      adUtils.getBlackList(context);
      pageToHome();
    });
  }

  void pageToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
           const Guide()),
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
              image: AssetImage('assets/image/bg_start.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
