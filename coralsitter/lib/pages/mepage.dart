/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/tagsbox.dart';

// 功能按钮
Widget meItem(IconData icon, String str, Function() func) {
  return TextButton(
    onPressed: func,
    child: ListTile(
      leading: Icon(icon, color: Colors.black,),
      title: Text(str, style: const TextStyle(color: Colors.black, fontSize: 12),),
      trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.black,),
      contentPadding: const EdgeInsets.all(0.0),
      dense: true,
    ),
  );
}

// 个人信息页面
class MePage extends StatefulWidget {
  const MePage({ Key? key, required this.callback }) : super(key: key);
  final Function callback;

  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {

  @override
  Widget build(BuildContext context) {
    // 个人信息
    Widget meBox = CommonData.me == null ? const SizedBox() : Container(
      margin: const EdgeInsets.all(0.0),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5), vertical: ScreenUtil().setHeight(1)),
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20.0)],
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular((10.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 头像
              Card(
                elevation: 10.0,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Image.network(
                  CommonData.me!.avatar + '?' + DateTime.now().millisecondsSinceEpoch.toString(),
                  width: ScreenUtil().setWidth(20),
                  height: ScreenUtil().setWidth(20),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(8),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户名
                  Text(CommonData.me!.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 15),
                  // 标签
                  tagsBox(ScreenUtil().setWidth(54), 0.0, CommonData.me!.tags),
                ],
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(2),),
          Text(CommonData.me!.sign, style: TextStyle(fontSize: 12, color: Colors.grey[700]),),
          SizedBox(height: ScreenUtil().setHeight(2),),
        ],
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          titleSpacing: ScreenUtil().setWidth(7.5),
          elevation: 0.0,
          toolbarHeight: ScreenUtil().setHeight(7),
          title: Text('个人主页', style: TextStyle(fontSize: ScreenUtil().setHeight(2.5), color: Colors.black, fontWeight: FontWeight.bold),),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed(MyRouter.changeuserinfo).then((value) => setState((){})),
              child: Text("编辑资料", style: TextStyle(fontSize: 15, color: Colors.grey[700]),),
            ),
            SizedBox(width: ScreenUtil().setWidth(5),)
          ],
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black54,
        ),
        body: ListView(
          children: [
            meBox,
            // 功能卡片
            Container(
              margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5), vertical: ScreenUtil().setHeight(5)),
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(1)),
              decoration: BoxDecoration(
                boxShadow: const [BoxShadow(color: Color(0xFFEEEEEE), offset: Offset(0.0, 10.0), blurRadius: 5.0)],
                color: Colors.white,
                borderRadius: BorderRadius.circular((10.0)),
              ),
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    meItem(Icons.payment, "珊瑚卡包", () => Navigator.of(context).pushNamed(MyRouter.coralcards)),
                    meItem(Icons.settings, "设置", () => Navigator.of(context).pushNamed(MyRouter.setting, arguments: widget.callback),),
                  ],
                ).toList(),
              ),
            ),
          ]
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}