/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:sprintf/sprintf.dart';

import 'package:coralsitter/common.dart';

// 珊瑚身份证页面
class CoralIdentityPage extends StatefulWidget {
  const CoralIdentityPage({ Key? key }) : super(key: key);

  @override
  _CoralIdentityPageState createState() => _CoralIdentityPageState();
}

class _CoralIdentityPageState extends State<CoralIdentityPage> {
  late CoralInfo coral;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    coral = ModalRoute.of(context)?.settings.arguments as CoralInfo;

    // 头像和名字区域
    Widget titleArea = Padding(
      padding: EdgeInsets.all(ScreenUtil().setHeight(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setHeight(7))),
            child: ClipOval(
              child: Image.network(coral.avatar, width: ScreenUtil().setHeight(14), height: ScreenUtil().setHeight(14), fit: BoxFit.cover,),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(coral.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              const SizedBox(height: 5.0,),
              SizedBox(
                width: ScreenUtil().setWidth(40),
                child: Text(
                  coral.species.tags.join(' / '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12,),
                ),
              ),
            ],
          ),
        ]
      ),
    );

    // 珊瑚信息
    Widget infoArea = Expanded(
      child: Container(
        height: ScreenUtil().setHeight(20),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5)),
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('科属', style: TextStyle(fontSize: 12, color: Colors.black54),),
                SizedBox(width: ScreenUtil().setWidth(7.5),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coral.species.classification + ' ' + coral.species.classificationen, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                    Text(coral.species.species + ' ' + coral.species.speciesen, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                  ],
                ),
              ],
            ),
            Divider(thickness: 1, color: Colors.grey[300],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('出生时间', style: TextStyle(fontSize: 12, color: Colors.black54),),
                    const SizedBox(height: 10.0,),
                    Text(coral.birthtime, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('领养时间', style: TextStyle(fontSize: 12, color: Colors.black54),),
                    const SizedBox(height: 10.0,),
                    Text(coral.adopttime, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(),
              ],
            ),
            Divider(thickness: 1, color: Colors.grey[300],),
            Row(
              children: [
                const Text('居住点', style: TextStyle(fontSize: 12, color: Colors.black54),),
                SizedBox(width: ScreenUtil().setWidth(7.5),),
                Icon(Icons.room, size: 15, color: Color(CommonData.themeColor),),
                Text(coral.position, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Color(CommonData.themeColor),
        body: Stack(
          alignment: Alignment.center,
          children: [
            // 背景
            Positioned(
              top: 0,
              child: Image.asset('assets/images/coralbackground.png', width: ScreenUtil().setWidth(100),),
            ),
            // 标题栏
            Positioned(
              top: ScreenUtil().setHeight(4.8),
              child: Text('珊瑚身份证', style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            Positioned(
                top: ScreenUtil().setHeight(3.5),
                left: ScreenUtil().setWidth(3),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: ScreenUtil().setHeight(4),),
                ),
              ),
            Positioned(
              bottom: 0,
              left: ScreenUtil().setWidth(7.5),
              width: ScreenUtil().setWidth(85),
              child: Column(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(85),
                    height: ScreenUtil().setHeight(76),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white
                    ),
                    child: Column(
                      children: [
                        titleArea,
                        Divider(height: 0, thickness: 1.5, color: Colors.grey[400],),
                        infoArea,
                        Divider(height: 0, thickness: 1.5, color: Colors.grey[400],),
                        BarcodeWidget(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(12), right: ScreenUtil().setWidth(12), top: ScreenUtil().setHeight(4), bottom: ScreenUtil().setHeight(2)),
                          height: ScreenUtil().setHeight(16),
                          barcode: Barcode.code128(),
                          data: sprintf("%015d", [coral.coralID]),
                          drawText: true,
                          color: const Color(0xFF1A237E),
                          textPadding: ScreenUtil().setHeight(1.5),
                          style: TextStyle(letterSpacing: ScreenUtil().setWidth(1.5)),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: ScreenUtil().setHeight(4),),
                  // SizedBox(
                  //   width: ScreenUtil().setWidth(85),
                  //   height: ScreenUtil().setHeight(5),
                  //   child: TextButton(
                  //     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white),),
                  //     onPressed: () {Navigator.of(context).pop();},
                  //     child: Text("返回", style: TextStyle(fontSize: 14, color: Color(CommonData.themeColor)),)
                  //   ),
                  // ),
                  SizedBox(height: ScreenUtil().setHeight(8),),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}