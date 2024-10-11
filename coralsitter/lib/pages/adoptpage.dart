/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/draggablecards.dart';
import 'package:coralsitter/widgets/serverdialog.dart';

// 珊瑚信息组件
Widget infoBox(String title, String content, String unit, CustomAnimationControl control, Function render) {
  return Container(
    width: ScreenUtil().setWidth(18),
    height: ScreenUtil().setWidth(18),
    decoration: BoxDecoration(
      color: Colors.blue[300],
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(height: ScreenUtil().setWidth(2),),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.black,),),
        const SizedBox(),
        SizedBox(
          height: ScreenUtil().setWidth(5),
          child: CustomAnimation(
            control: control,
            duration: Duration(milliseconds: (500).round()),
            tween: ColorTween(begin: Color(CommonData.themeColor), end: const Color(0xFF64B5F6)),
            builder: (context, child, Color? value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: ScreenUtil().setWidth(3),),
                  Text(content, style: TextStyle(fontSize: double.tryParse(content) == null ? 14 : 16, color: value, fontWeight: FontWeight.bold),),
                ] + (unit == '' ? [SizedBox(width: ScreenUtil().setWidth(3),),] : [
                  Text(unit, style: TextStyle(fontSize: 10, color: value, fontWeight: FontWeight.bold),),
                  SizedBox(width: ScreenUtil().setWidth(3),),
                ]),
              );
            },
            onComplete: () => render(),
          )
        ),
        SizedBox(height: ScreenUtil().setWidth(2),),
      ],
    ),
  );
}

// 领养珊瑚页面
class AdoptPage extends StatefulWidget {
  const AdoptPage({ Key? key }) : super(key: key);

  @override
  _AdoptPageState createState() => _AdoptPageState();
}

class _AdoptPageState extends State<AdoptPage> {
  final GlobalKey<ServerDialogState> childkey = GlobalKey<ServerDialogState>();

  CustomAnimationControl control = CustomAnimationControl.stop;
  List corals = [];
  int pos = 0; // 当前查看珊瑚位置

  void next() async {
    control = CustomAnimationControl.playFromStart;
    setState(() {});
  }

  // 文字透明后更新到下一个
  void render() async {
    if (control == CustomAnimationControl.playFromStart) {
      control = CustomAnimationControl.playReverseFromEnd;
      pos = (pos + 1) % corals.length;
      setState(() {});
    }
  }

  void adopt() async {
    Map requestData = {
      'coralID': corals[pos].coralID.toString(),
      'masterID': CommonData.me!.userID.toString(),
      'coralName': "未命名",
      'position': corals[pos].position,
    };
    Map<dynamic, dynamic> responseData = await childkey.currentState!.post('/adopt', requestData);

    if (!responseData['success']) return;

    if (responseData['success']) {
      List positions = responseData['pos'];
      corals[pos].name = "未命名";
      corals[pos].position = positions[0];
      corals[pos].adopttime = responseData['adopt_date'].split(' ')[0];
      CommonData.mycorals.add(corals[pos]);
      Navigator.of(context).pop();
      Navigator.of(context).pop({'coral': corals[pos], 'pos': positions});
    }
    else {
      Fluttertoast.showToast(msg: '领养失败');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    corals = ModalRoute.of(context)?.settings.arguments as List;
    
    // 珊瑚信息
    Widget infoArea = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        infoBox('年龄', (DateTime.now().difference(DateTime.parse(corals[pos].birthtime)).inDays / 365).toStringAsFixed(1), '年', control, render),
        infoBox('培育点', corals[pos].position.substring(0, corals[pos].position.length - 4), '', control, render),
        infoBox('大小', corals[pos].size.toString(), '厘米', control, render),
        infoBox('得分', corals[pos].score.toString(), '', control, render),
      ],
    );

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
              // 顶部栏
              Positioned(
                top: ScreenUtil().setHeight(4.8),
                child: Text('领养珊瑚', style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              // 珊瑚卡片
              Positioned(
                top: ScreenUtil().setHeight(10),
                child: DraggableCards(
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(56),
                  urls: corals.map((coral) => coral.avatar as String).toList(),
                  texts: corals.map((coral) => coral.birthtime as String).toList(),
                  getPos: () => (pos+3) % corals.length,
                  next: next,
                ),
              ),
              // 珊瑚信息和领养按钮
              Positioned(
                bottom: 0,
                left: ScreenUtil().setWidth(7.5),
                width: ScreenUtil().setWidth(85),
                child: Column(
                  children: [
                    infoArea,
                    SizedBox(height: ScreenUtil().setHeight(3),),
                    const Divider(thickness: 1, color: Colors.white,),
                    SizedBox(height: ScreenUtil().setHeight(4),),
                    SizedBox(
                      width: ScreenUtil().setWidth(85),
                      height: ScreenUtil().setHeight(5),
                      child: TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white),),
                        onPressed: () => adopt(),
                        child: Text("领养这只珊瑚", style: TextStyle(fontSize: 14, color: Color(CommonData.themeColor)),)
                      ),
                    ),
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