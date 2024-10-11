/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/pages/homepage.dart';
import 'package:coralsitter/pages/sitterpage.dart';
import 'package:coralsitter/pages/loginpage.dart';
import 'package:coralsitter/pages/mepage.dart';

void main() {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coral',
      home: const BottomBar(),
      routes: MyRouter.routes,
    );
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({ Key? key }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    return CommonData.me == null ? LoginPage(callback: () => onChanged()) : Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_mall,
            ),
            label: '领养',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.child_friendly,
            ),
            label: '珊护',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: '我的',
          ),
        ],

        currentIndex: _currentIndex,
        onTap: (int i) => {
          setState(() {
            _currentIndex = i;
          })
        },
      ),
      body: pages[_currentIndex],
    );
  }

  @override
  void initState() {
    super.initState();
    pages = [const HomePage(), const SitterPage(), MePage(callback: () => onChanged(),),];
  }

  void onChanged(){
    setState(() {
      _currentIndex = 0;
    });
  }
}