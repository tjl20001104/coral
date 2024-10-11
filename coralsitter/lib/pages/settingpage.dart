/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';

// 设置页面
class SettingPage extends StatefulWidget {
  const SettingPage({ Key? key }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    Function callback = ModalRoute.of(context)?.settings.arguments as Function;

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: ScreenUtil().setHeight(7),
          leadingWidth: ScreenUtil().setWidth(15),
          leading: Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(3)),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.keyboard_arrow_left, color: Colors.black, size: ScreenUtil().setHeight(4),),
            ),
          ),
          title: Text("设置", style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), fontWeight: FontWeight.bold,),),
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black,
        ),
        body: ListView(
          children: [
            TextButton(
              onPressed: () {
                CommonData.me = null;
                CommonData.mycorals.clear();
                Navigator.of(context).pop();
                callback();
              },
              child: const Text("退出登陆", style: TextStyle(color: Colors.black, fontSize: 16),),
            ),
          ],
        ),
      ),
    );
  }
}