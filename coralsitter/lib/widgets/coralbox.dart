/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';

// 珊瑚详情按钮
Widget coralBox(CoralInfo coral, BuildContext context, {int key=0}) {
  return Card(
    key: ValueKey(key),
    margin: const EdgeInsets.all(0.0),
    elevation: 10.0,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
    shadowColor: Colors.black45,
    child: TextButton(
      onPressed: () => Navigator.of(context).pushNamed(MyRouter.coral, arguments: coral),
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
  );
}