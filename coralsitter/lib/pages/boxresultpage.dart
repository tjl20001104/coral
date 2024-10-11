/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';

// 盲盒结果页面
class BoxResultPage extends StatefulWidget {
  const BoxResultPage({ Key? key }) : super(key: key);

  @override
  _BoxResultPageState createState() => _BoxResultPageState();
}

class _BoxResultPageState extends State<BoxResultPage> {
  CoralSpecies? species;

  @override
  Widget build(BuildContext context) {
    species = ModalRoute.of(context)?.settings.arguments as CoralSpecies;

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: ScreenUtil().setHeight(7),
          title: Text('盲盒卡片', style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), color: Colors.black, fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: const SizedBox(),
        ),
        body: Column(
          children: [
            SizedBox(width: ScreenUtil().setWidth(100), height: ScreenUtil().setHeight(1),),
            Image.asset('assets/images/box_opened.png', height: ScreenUtil().setHeight(70),),
            SizedBox(
              width: ScreenUtil().setWidth(85),
              height: ScreenUtil().setHeight(5),
              child: TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(CommonData.themeColor)),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop({'coralresult': species});
                },
                child: const Text("查看珊瑚卡片", style: TextStyle(fontSize: 14, color: Colors.white),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}