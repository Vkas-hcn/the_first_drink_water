import 'package:flutter/material.dart';

import 'BMIPage.dart';
import 'Home.dart';
import 'SettingPaper.dart';
import 'StartPaper.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),
    BMIPage(),
    SettingPaper(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF47B96D),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              width: 32,
              height: 32,
              _selectedIndex == 0
                  ? 'assets/image/ic_home_1.webp'
                  : 'assets/image/ic_home_2.webp',
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              width: 32,
              height: 32,
              _selectedIndex == 1
                  ? 'assets/image/ic_bmi_1.webp'
                  : 'assets/image/ic_bmi_2.webp',
            ),
            label: 'BMI',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              width: 32,
              height: 32,
              _selectedIndex == 2
                  ? 'assets/image/ic_setting_1.webp'
                  : 'assets/image/ic_setting_2.webp',
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0x80FFFFFF),
        onTap: _onItemTapped,
      ),
    );
  }
}
