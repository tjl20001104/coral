/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/speciescard.dart';

// 珊瑚类型页面
class SpeciesPage extends StatefulWidget {
  const SpeciesPage({ Key? key }) : super(key: key);

  @override
  _SpeciesPageState createState() => _SpeciesPageState();
}

class _SpeciesPageState extends State<SpeciesPage> {
  late CoralSpecies species;

  @override
  Widget build(BuildContext context) {
    species = ModalRoute.of(context)?.settings.arguments as CoralSpecies;

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
              child: Text('珊瑚类型', style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            Positioned(
              top: ScreenUtil().setHeight(3.5),
              left: ScreenUtil().setWidth(4.5),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white,),
              ),
            ),
            Positioned(
              left: ScreenUtil().setWidth(7.5),
              bottom: 0,
              width: ScreenUtil().setWidth(85),
              child: Column(
                children: [
                  speciesCard(species),
                  SizedBox(height: ScreenUtil().setHeight(4),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}