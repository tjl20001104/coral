/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';

// 抽取盲盒页面
class ChooseBoxPage extends StatefulWidget {
  const ChooseBoxPage({ Key? key }) : super(key: key);

  @override
  _ChooseBoxPageState createState() => _ChooseBoxPageState();
}

class _ChooseBoxPageState extends State<ChooseBoxPage> {
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Colors.white,
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
          title: Text("选择盲盒", style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), fontWeight: FontWeight.bold,),),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5), vertical: 10),
          children: [
            SizedBox(height: ScreenUtil().setHeight(2),),
            Text("稀有珊瑚", style: TextStyle(fontSize: ScreenUtil().setHeight(2), color: Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(height: ScreenUtil().setHeight(1),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [1, 2, 3, 4, 5].map((i) => ClipOval(
                child: Image.asset('assets/images/unknown' + i.toString() + '.png', width: ScreenUtil().setWidth(12), height: ScreenUtil().setWidth(12),),
              )).toList(),
            ),
            SizedBox(height: ScreenUtil().setHeight(5),),
            // const Text("热带圣诞系列", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
            GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  childAspectRatio: ScreenUtil().setWidth(85) / ScreenUtil().setHeight(60),
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(MyRouter.openbox);
                    },
                    child: Image.asset('assets/images/box_close.png',),
                  );
                },
              ),
            // ),
            SizedBox(height: ScreenUtil().setHeight(2),),
            const Text("请选择你想打开的珊瑚盲盒", style: TextStyle(fontSize: 15, color: Colors.grey,), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}