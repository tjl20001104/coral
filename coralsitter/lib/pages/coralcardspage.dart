/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';

// 珊瑚身份证
Widget coralCard(CoralInfo coral, BuildContext context, {int key=0}) {
  return Container(
    margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(4)),
    child: Card(
      key: ValueKey(key),
      margin: const EdgeInsets.all(0.0),
      elevation: 10.0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      shadowColor: Colors.black45,
      child: TextButton(
        onPressed: () => Navigator.of(context).pushNamed(MyRouter.coralidentity, arguments: coral),
        child: ListTile(
          leading: ClipOval(
            child: Image.network(coral.avatar, width: ScreenUtil().setWidth(10), height: ScreenUtil().setWidth(10), fit: BoxFit.cover,),
          ),
          title: Row(
            children: [
              Text(coral.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),),
              const SizedBox(width: 15.0,),
              Text(coral.score.toString(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange),),
            ],
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.room, color: Colors.grey, size: 10,),
              Text(coral.position, style: const TextStyle(fontSize: 10, color: Colors.grey),),
            ],
          ),
          trailing: Text("更新于"+coral.updateTime, style: const TextStyle(fontSize: 10, color: Colors.grey),),
          dense: true,
        ),
      ),
    ),
  );
}

// 珊瑚卡包页面
class CoralCardsPage extends StatefulWidget {
  const CoralCardsPage({ Key? key }) : super(key: key);

  @override
  _CoralCardsPageState createState() => _CoralCardsPageState();
}

class _CoralCardsPageState extends State<CoralCardsPage> {
  @override
  Widget build(BuildContext context) {
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
          title: Text("珊瑚卡包", style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), fontWeight: FontWeight.bold,),),
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black,
        ),
        body: ListView(
          padding: EdgeInsets.all(ScreenUtil().setWidth(7.5)),
          children: CommonData.mycorals.asMap().keys.map((k) => coralCard(CommonData.mycorals[k], context)).toList(),
        ),
      ),
    );
  }
}