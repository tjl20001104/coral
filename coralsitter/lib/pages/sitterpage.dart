/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reorderables/reorderables.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/coralbox.dart';
import 'package:coralsitter/widgets/serverdialog.dart';
import 'package:coralsitter/widgets/coralstory.dart';
import 'package:coralsitter/widgets/tagsbox.dart';

// 珊护页面
class SitterPage extends StatefulWidget {
  const SitterPage({ Key? key }) : super(key: key);

  @override
  _SitterPageState createState() => _SitterPageState();
}

class _SitterPageState extends State<SitterPage> {
  final GlobalKey<ServerDialogState> childkey = GlobalKey<ServerDialogState>();

  List storys = [];

  void getStory() async {
    Map<dynamic, dynamic> responseData = await childkey.currentState!.post('/getStory', {
      'coralIDs': CommonData.mycorals.map((coral) => coral.coralID).toList().join('-')
    }, waitTime: 0);

    if (responseData['story'] == null) return;

    storys = responseData['story'];

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getStory()); 
  }

  List<Widget> buildMyCorals(BuildContext context) {
    List<Widget> widgets = [const SizedBox(height: 10, key: ValueKey(0),)];
    for (int i = 0; i < CommonData.mycorals.length; i ++) {
      widgets.add(coralBox(CommonData.mycorals[i], context, key: 2*i+1,),);
      // 增加间隔
      widgets.add(SizedBox(height: 20, key: ValueKey(2*i)));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    // 顶部区域
    Widget topArea = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: ScreenUtil().setWidth(100),
          height: ScreenUtil().setWidth(80),
        ),
        // 背景图片
        Positioned(
          top: 0,
          child: Image.network(
            'http://' + CommonData.server + '/static/storys/' + (storys.isEmpty||storys[0]['image']=='' ? 'default.jpg':storys[0]['coralID'].toString() + '/' + storys[0]['image']),
            width: ScreenUtil().setWidth(100),
            height: ScreenUtil().setWidth(50),
            fit: BoxFit.cover,
          ),
        ),
        // 用户名和标签
        Positioned(
          top: ScreenUtil().setWidth(40),
          child: Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15), top: ScreenUtil().setWidth(13)),
            width: ScreenUtil().setWidth(85),
            height: ScreenUtil().setWidth(33),
            decoration: BoxDecoration(
              boxShadow: const [BoxShadow(color: Color(0xFFEEEEEE), offset: Offset(0.0, 10.0), blurRadius: 5.0)],
              color: Colors.white,
              borderRadius: BorderRadius.circular((5.0)),
            ),
            child: CommonData.me == null ? const SizedBox() : Column(
              children: [
                Text(CommonData.me!.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                const SizedBox(height: 10),
                tagsBox(ScreenUtil().setWidth(50), ScreenUtil().setWidth(50), CommonData.me!.tags),
              ],
            ),
          ),
        ),
        // 头像
        CommonData.me == null ? const SizedBox() : Positioned(
          top: ScreenUtil().setWidth(30),
          child: Container(
            width: ScreenUtil().setWidth(20),
            height: ScreenUtil().setWidth(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(ScreenUtil().setWidth(2)),
              image: DecorationImage(
                image: NetworkImage(CommonData.me!.avatar + '?' + DateTime.now().millisecondsSinceEpoch.toString(),),
                fit: BoxFit.cover
              ),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => ServerDialog(
        key: childkey,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: ListView(
            padding: const EdgeInsets.all(0.0),
            children: [
              topArea,
              // 我的珊瑚
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5)),
                child: const Text("我的珊瑚", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5)),
                child: ReorderableColumn(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  onReorder: (oldIndex, newIndex) {
                    oldIndex = (oldIndex-1) ~/ 2;
                    newIndex = (newIndex-1) ~/ 2;
                    CoralInfo tmp = CommonData.mycorals.removeAt(oldIndex);
                    CommonData.mycorals.insert(newIndex, tmp);
                    setState(() {
                    });
                  },
                  children: buildMyCorals(context),
                ),
              ),
              const SizedBox(height: 15,),
              // 珊瑚故事
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5)),
                child: const Text("故事精选", style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
              ),
              const SizedBox(height: 10,),
              Column(
                children: storys.map((story) => coralStory(
                    ScreenUtil().setWidth(85),
                    story['updateTime'].substring(0, story['updateTime'].length-4),
                    story['story'],
                    story['image']!=''?'http://' + CommonData.server + '/static/storys/' + story['coralID'].toString() + '/' + story['image']:''
                  )
                ).toList(),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}