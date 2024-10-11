/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/speciescard.dart';
import 'package:coralsitter/widgets/serverdialog.dart';

// 抽取结果页面
class CoralResultPage extends StatefulWidget {
  const CoralResultPage({ Key? key }) : super(key: key);

  @override
  _CoralResultPageState createState() => _CoralResultPageState();
}

class _CoralResultPageState extends State<CoralResultPage> {
  final GlobalKey<ServerDialogState> childkey = GlobalKey<ServerDialogState>();
  late CoralSpecies species;

  void adopt(BuildContext context, int id) async {
    Map<dynamic, dynamic> responseData = await childkey.currentState!.post('/listCorals', {
      'specieID': id.toString(),
    });

    if (responseData['result'] == null) return;

    if (responseData['result'].isEmpty) {
      Fluttertoast.showToast(msg: '获取珊瑚失败');
    }
    else {
      List<CoralInfo> corals = [];
      responseData['result'].forEach((coral) => {
        corals.add(
          CoralInfo(
            coralID: coral['coralID'],
            name: coral['coralName'],
            avatar: 'http://' + CommonData.server + '/static/coral_avatar/' + coral['coralID'].toString() + '.jpg',
            position: coral['coralPosition'],
            updateTime: coral['updateTime'].split(' ')[0],
            light: coral['light'],
            temp: coral['temp'],
            microelement: coral['microelement'],
            size: coral['size'],
            lastmeasure: coral['lastmeasure'],
            growth: coral['growth'],
            score: coral['score'],
            birthtime: coral['born_date'].split(' ')[0],
            adopttime: coral['adopt_date'].split(' ')[0],
            species: species,
          )
        )
      });
      Navigator.of(context).pushNamed(MyRouter.adopt, arguments: corals);
    }
  }
  @override
  Widget build(BuildContext context) {
    species = ModalRoute.of(context)?.settings.arguments as CoralSpecies;

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Color(CommonData.themeColor),
        body: ServerDialog(
          key: childkey,
          child: Stack(
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
                child: Text('珊瑚特征', style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), color: Colors.white, fontWeight: FontWeight.bold),),
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
                left: ScreenUtil().setWidth(7.5),
                bottom: 0,
                width: ScreenUtil().setWidth(85),
                child: Column(
                  children: [
                    speciesCard(species),
                    SizedBox(height: ScreenUtil().setHeight(4),),
                    SizedBox(
                      width: ScreenUtil().setWidth(85),
                      height: ScreenUtil().setHeight(5),
                      child: TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white),),
                        onPressed: () => adopt(context, species.specieID),
                        child: Text("领养这种珊瑚", style: TextStyle(fontSize: 14, color: Color(CommonData.themeColor)),)
                      ),
                    ),
                    // Container(
                    //   height: ScreenUtil().setHeight(5),
                    //   margin: const EdgeInsets.all(0.0),
                    //   child: TextButton(
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //       Navigator.of(context).pushNamed(MyRouter.match);
                    //     },
                    //     child: const Text("换一种珊瑚", style: TextStyle(fontSize: 12, color: Colors.white),)
                    //   )
                    // ),
                    SizedBox(height: ScreenUtil().setHeight(8),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}