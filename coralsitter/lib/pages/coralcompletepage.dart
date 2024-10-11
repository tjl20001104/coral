/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/serverdialog.dart';

// 完善珊瑚信息页面
class CoralCompletePage extends StatefulWidget {
  const CoralCompletePage({ Key? key }) : super(key: key);

  @override
  _CoralCompletePageState createState() => _CoralCompletePageState();
}

class _CoralCompletePageState extends State<CoralCompletePage> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ServerDialogState> childkey = GlobalKey<ServerDialogState>();
  late CoralInfo coral;
  String pos = '';
  List positions = [];

  void complete() async {
    if (_controller.text == '' || pos == '') {
      Fluttertoast.showToast(msg: '输入不能为空');
      return;
    }

    Map requestData = {
      'coralID': coral.coralID.toString(),
      'masterID': CommonData.me!.userID.toString(),
      'coralName': _controller.text,
      'position': pos,
    };
    Map<dynamic, dynamic> responseData = await childkey.currentState!.post('/adopt', requestData);

    if (responseData['success'] == null) return;

    if (responseData['success']) {
      coral.name = _controller.text;
      coral.position = pos;
      coral.adopttime = responseData['adopt_date'].split(' ')[0];
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(MyRouter.coralidentity, arguments: coral);
    }
    else {
      Fluttertoast.showToast(msg: '登记失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    coral = (ModalRoute.of(context)?.settings.arguments as Map)['coral'];
    positions = (ModalRoute.of(context)?.settings.arguments as Map)['pos'];

    // 选择种植地区
    Widget choosePos = SizedBox(
      width: ScreenUtil().setWidth(85),
      height: ScreenUtil().setHeight(45.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("帮它选择自己未来的居住位置", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),),
          const SizedBox(height: 5,),
          ExpansionTile(
            title: Text(pos),
            onExpansionChanged: (isChanged) {
              _focus.unfocus();
            },
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(30),
                child: ListView(
                  padding: const EdgeInsets.all(0.0),
                  children: positions.map((value) => ListTile(
                    title: Text(value),
                    onTap: () {
                      pos = value;
                      setState(() {});
                    },
                  )).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Colors.grey[100],
        body: GestureDetector(
          onTap: (){
            _focus.unfocus();
          },
          child: ServerDialog(
            key: childkey,
            child: ListView(
              padding: EdgeInsets.all(ScreenUtil().setWidth(7.5)),
              children: [
                SizedBox(height: ScreenUtil().setHeight(5),),
                SizedBox(
                  width: ScreenUtil().setWidth(85),
                  height: ScreenUtil().setHeight(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("恭喜你拥有了一棵属于自己的珊瑚！", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("你需要完成以下步骤来生成珊瑚身份证：", style: TextStyle(fontSize: 16, color: Colors.grey),),
                    ],
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(85),
                  height: ScreenUtil().setHeight(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("为它取个独一无二的名字", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),),
                      SizedBox(
                        height: ScreenUtil().setHeight(8),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focus,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                choosePos,
                SizedBox(
                  width: ScreenUtil().setWidth(85),
                  height: ScreenUtil().setHeight(5),
                  child: TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(CommonData.themeColor)),),
                    onPressed: complete,
                    child: const Text("就种在这里！", style: TextStyle(fontSize: 14, color: Colors.white),)
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(0.5),),
              ],
            ), 
          ),
        ),
      ),
    );
  }
}