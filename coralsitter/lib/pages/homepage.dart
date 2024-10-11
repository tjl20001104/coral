/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/coralbox.dart';
import 'package:coralsitter/widgets/swipercards.dart';

// 主页
class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void homeRoute(Map? value) {
    if (value != null) {
      if (value['coralresult'] != null) {
        Navigator.of(context).pushNamed(MyRouter.coralresult, arguments: value['coralresult']).then((value) => setState(() {homeRoute(value as Map);}));
      }
      else if (value['coral'] != null) {
        Navigator.of(context).pushNamed(MyRouter.coralcomplete, arguments: {'coral': value['coral'], 'pos': value['pos']}).then((value) => setState(() {}));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 领养珊瑚区域
    Widget adoptCoralCard = Card(
      margin: const EdgeInsets.all(0.0),
      elevation: 10.0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      shadowColor: Colors.black45,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed(MyRouter.match).then((value) => homeRoute(value as Map)),
              child: Column(
                children: [
                  const Text("智能匹配", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
                  const Text("领养有缘分的珊瑚", style: TextStyle(fontSize: 10, color: Colors.blue),),
                  const SizedBox(height: 20),
                  Image(image: const AssetImage('assets/images/match.png'), width: ScreenUtil().setWidth(20), height: ScreenUtil().setWidth(20),),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            const SizedBox(height: 120, child: VerticalDivider(color: Colors.grey, width: 1,)),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed(MyRouter.choosebox).then((value) => homeRoute(value as Map)),
              child: Column(
                children: [
                  const Text("抽选盲盒", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
                  const Text("隐藏限定珊瑚形象", style: TextStyle(fontSize: 10, color: Colors.blue),),
                  const SizedBox(height: 20),
                  Image(image: const AssetImage('assets/images/box.png'), width: ScreenUtil().setWidth(20), height: ScreenUtil().setWidth(20),),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 1,
          backgroundColor: Colors.grey[100],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5), vertical: 10),
          children: [
            const Text("每日精选", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
            // 每日精选轮播
            Container(
              margin: const EdgeInsets.only(top: 15),
              height: ScreenUtil().setWidth(45),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: swiperCards([
                  'http://' + CommonData.server + '/static/daily/1.jpg?' + DateTime.now().millisecondsSinceEpoch.toString(),
                  'http://' + CommonData.server + '/static/daily/2.jpg?' + DateTime.now().millisecondsSinceEpoch.toString(),
                  'http://' + CommonData.server + '/static/daily/3.jpg?' + DateTime.now().millisecondsSinceEpoch.toString(),
                ], context),
              ),
            ),
            const SizedBox(height: 20),
            // 我的珊瑚
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("我的珊瑚", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(MyRouter.coralcards),
                  child: const Text("查看更多", style: TextStyle(fontSize: 12, color: Colors.grey),)
                ),
              ],
            ),
            CommonData.mycorals.isEmpty ? const SizedBox() : coralBox(CommonData.mycorals[0], context),
            const SizedBox(height: 30),
            // 领养珊瑚
            const Text("领养珊瑚", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
            const SizedBox(height: 15),
            adoptCoralCard,
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}