/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';

// 珊瑚种类卡片
Widget speciesCard(CoralSpecies species) {
  // 珊瑚种类信息
  Widget speciesInfoArea = Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: ScreenUtil().setWidth(26),
        height: ScreenUtil().setWidth(32),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setWidth(8),),
            Icon(Icons.grain, color: Colors.white, size: ScreenUtil().setWidth(10),),
            SizedBox(height: ScreenUtil().setWidth(4),),
            Text(species.classification, style: const TextStyle(fontSize: 11, color: Colors.white,),),
            const SizedBox(height: 2,),
            Text(species.classificationen, style: const TextStyle(fontSize: 11, color: Colors.white,),),
          ],
        ),
      ),
      Container(
        width: ScreenUtil().setWidth(26),
        height: ScreenUtil().setWidth(32),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setWidth(8),),
            SizedBox(
              width: ScreenUtil().setWidth(20),
              height: ScreenUtil().setWidth(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [species.difficulty < 1 ? Icon(Icons.star_outline, color: Colors.white, size: ScreenUtil().setWidth(4),) : Icon(Icons.star, color: Colors.white, size: ScreenUtil().setWidth(4),),]
                  + [species.difficulty < 2 ? Icon(Icons.star_outline, color: Colors.white, size: ScreenUtil().setWidth(4),) : Icon(Icons.star, color: Colors.white, size: ScreenUtil().setWidth(4),),]
                  + [species.difficulty < 3 ? Icon(Icons.star_outline, color: Colors.white, size: ScreenUtil().setWidth(4),) : Icon(Icons.star, color: Colors.white, size: ScreenUtil().setWidth(4),),]
                  + [species.difficulty < 4 ? Icon(Icons.star_outline, color: Colors.white, size: ScreenUtil().setWidth(4),) : Icon(Icons.star, color: Colors.white, size: ScreenUtil().setWidth(4),),]
                  + [species.difficulty < 5 ? Icon(Icons.star_outline, color: Colors.white, size: ScreenUtil().setWidth(4),) : Icon(Icons.star, color: Colors.white, size: ScreenUtil().setWidth(4),),],
              ),
            ),
            SizedBox(height: ScreenUtil().setWidth(4),),
            Text(
              '饲养难度' + (species.difficulty < 3 ? '低' : species.difficulty < 4 ? '中' : '高'),
              style: const TextStyle(fontSize: 11, color: Colors.white,),
            ),
          ],
        ),
      ),
      SizedBox(
        width: ScreenUtil().setWidth(26),
        height: ScreenUtil().setWidth(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(26),
              height: ScreenUtil().setWidth(9.5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                '生长速度' + species.growspeed,
                style: const TextStyle(fontSize: 12, color: Colors.white,),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ScreenUtil().setWidth(12),
                  height: ScreenUtil().setWidth(9.5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(0.2),),
                      Text(species.current, style: const TextStyle(fontSize: 12, color: Colors.white,),),
                      const Text('水流', style: TextStyle(fontSize: 12, color: Colors.white,),),
                      SizedBox(height: ScreenUtil().setHeight(0.2),),
                    ]
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(12),
                  height: ScreenUtil().setWidth(9.5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(0.2),),
                      Text(species.light, style: const TextStyle(fontSize: 12, color: Colors.white,),),
                      const Text('光强', style: TextStyle(fontSize: 12, color: Colors.white,),),
                      SizedBox(height: ScreenUtil().setHeight(0.2),),
                    ]
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(26),
              height: ScreenUtil().setWidth(9.5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                '喂养要求' + species.feed,
                style: const TextStyle(fontSize: 12, color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(species.species, style: const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),),
      Text(species.speciesen, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),),
      SizedBox(height: ScreenUtil().setHeight(6),),
      // 标签
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: species.tags.map((tag) => Row(
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
            ),
            const SizedBox(width: 8,),
            Text(
              tag,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        ).toList(),
      ),
      SizedBox(height: ScreenUtil().setHeight(2),),
      speciesInfoArea,
      SizedBox(height: ScreenUtil().setHeight(3),),
      // 色卡
      Container(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(3)),
        alignment: Alignment.centerRight,
        height: ScreenUtil().setHeight(7),
        decoration: BoxDecoration(
          gradient: LinearGradient(stops: const [0.2, 0.4, 0.7], colors: [Color(int.parse('0xFF'+species.color.split('-')[0])), Color(int.parse('0xFF'+species.color.split('-')[1])), const Color(0xFF64B5F6)]),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: ScreenUtil().setHeight(0.3)),
            Text(species.species + "色卡", style: const TextStyle(fontSize: 11, color: Colors.white,),),
            Text(species.color, style: const TextStyle(fontSize: 11, color: Colors.white,),),
            SizedBox(height: ScreenUtil().setHeight(0.3)),
          ],
        ),
      ),
      SizedBox(height: ScreenUtil().setHeight(3),),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[Text('注意事项', style: TextStyle(color: Colors.white, fontSize: 12),)] + 
          species.attention.map((a) => Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
              ),
              const SizedBox(width: 8,),
              Text(
                a,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ).toList(),
      ),
      SizedBox(height: ScreenUtil().setHeight(3),),
      const Divider(thickness: 1, color: Colors.white,)
    ],
  );
}