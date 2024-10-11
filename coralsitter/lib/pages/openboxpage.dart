/*
Written by 游克垚
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:http/http.dart' as http;

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/progressbar.dart';

// 正在打开盲盒页面
class OpenBoxPage extends StatefulWidget {
  const OpenBoxPage({ Key? key }) : super(key: key);

  @override
  _OpenBoxPageState createState() => _OpenBoxPageState();
}

class _OpenBoxPageState extends State<OpenBoxPage> {
  String status = "正在打开...";
  CoralSpecies? species;

  void box() async {
    Uri uri = Uri.parse('http://' + CommonData.server + '/box');
    http.Response response = await http.post(
      uri,
      body: {},
    );

    if (response.statusCode == 404) return;

    Map<dynamic, dynamic> responseData = json.decode(response.body);
    species = CoralSpecies(
      specieID: responseData['specieID'],
      species: responseData['species'],
      speciesen: responseData['species_EN'],
      tags: responseData['tags'].split('-'),
      classification: responseData['classification'],
      classificationen: responseData['classification_EN'],
      difficulty: responseData['difficulty'],
      growspeed: responseData['growspeed'],
      current: responseData['current'],
      light: responseData['light'],
      feed: responseData['feed'],
      color: responseData['color'],
      attention: responseData['attention'].split('-'),
    );
  }

  @override
  void initState() {
    super.initState();
    box();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: ScreenUtil().setHeight(7),
          title: Text(status, style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), color: Colors.black, fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: const SizedBox(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: ScreenUtil().setWidth(100), height: ScreenUtil().setHeight(8),),
            PlayAnimation(
              duration: Duration(milliseconds: (10000).round()),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, child, double value) {
                return progressBar(value, ScreenUtil().setWidth(70), ScreenUtil().setHeight(2), flag: false);
              },
              onComplete: () {
                if (species != null) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(MyRouter.boxresult, arguments: species);
                }
                else {
                  status = "抽取失败";
                  setState(() {});
                }
              },
            ),
            SizedBox(height: ScreenUtil().setHeight(10),),
            Image.asset('assets/images/box_opening.png', height: ScreenUtil().setHeight(50),),
            SizedBox(height: ScreenUtil().setHeight(5),),
            const Text("根据时节会掉落隐藏限定款哦～", style: TextStyle(fontSize: 15, color: Colors.grey,), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}