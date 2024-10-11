/*
Written by 游克垚
*/

import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:http/http.dart' as http;

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/progressbar.dart';

// 背景动画
class AnimatedWave extends StatelessWidget {
  const AnimatedWave({Key? key, required this.height, required this.speed, this.offset = 0.0}) : super(key: key);
  final double height;
  final double speed;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: height,
        width: constraints.biggest.width,
        child: LoopAnimation(
          duration: Duration(milliseconds: (5000 / speed).round()),
          tween: Tween(begin: 0.0, end: 2 * pi),
          builder: (context, child, double value) {
            return CustomPaint(
              foregroundPainter: CurvePainter(value: value + offset),
            );
          }
        ),
      );
    });
  }
}

// 画背景
class CurvePainter extends CustomPainter {
  const CurvePainter({ Key? key, required this.value});
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// 匹配页面
class MatchPage extends StatefulWidget {
  const MatchPage({ Key? key }) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  String status = "正在匹配...";
  CoralSpecies? species;

  onBottom(Widget child) => Positioned.fill(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );

  void matchSpecies() async {
    Uri uri = Uri.parse('http://' + CommonData.server + '/match');
    http.Response response = await http.post(
      uri,
      body: {
        'tags': CommonData.me?.tags.join('-')
      },
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
    matchSpecies();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Color(CommonData.themeColor),
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: ScreenUtil().setHeight(7),
          title: Text('匹配珊瑚', style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), color: Colors.white, fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Color(CommonData.themeColor),
          foregroundColor: Colors.black,
          leading: const SizedBox(),
        ),
        body: Stack(
          children: [
            // wave animation
            onBottom(AnimatedWave(
              height: ScreenUtil().setHeight(20),
              speed: 1.0,
            )),
            onBottom(AnimatedWave(
              height: ScreenUtil().setHeight(15),
              speed: 0.9,
              offset: pi,
            )),
            onBottom(AnimatedWave(
              height: ScreenUtil().setHeight(10),
              speed: 1.2,
              offset: pi / 2,
            )),
            Positioned.fill(
              child: Column(
                children: [
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Image(image: const AssetImage('assets/icons/matchicon.png'), height: ScreenUtil().setHeight(40),),
                  SizedBox(height: ScreenUtil().setHeight(3)),
                  Text(status, style: const TextStyle(fontSize: 20, color: Colors.white,),),
                  SizedBox(height: ScreenUtil().setHeight(4)),
                  const Text('按照标签为您匹配一只独一无二的珊瑚', style: TextStyle(fontSize: 12, color: Colors.white,),),
                  SizedBox(height: ScreenUtil().setHeight(4)),
                  // 进度条
                  PlayAnimation(
                    duration: Duration(milliseconds: (10000).round()),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, child, double value) {
                      return progressBar(value, ScreenUtil().setWidth(70), ScreenUtil().setHeight(2));
                    },
                    onComplete: () {
                      if (species != null) {
                        Navigator.of(context).pop({'coralresult': species});
                      }
                      else {
                        status = "匹配失败";
                        setState(() {
                        });
                      }
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(6)),
                  // 取消按钮
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.blue[300]),
                      backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                      shape: MaterialStateProperty.all(
                        const CircleBorder(
                            side: BorderSide(
                              style: BorderStyle.none,
                            )
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Padding(padding: EdgeInsets.all(ScreenUtil().setHeight(1)), child: Icon(Icons.clear, size: ScreenUtil().setHeight(4),),),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}