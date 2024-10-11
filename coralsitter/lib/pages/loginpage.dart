/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:coralsitter/common.dart';

// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key, required this.callback }) : super(key: key);
  final Function callback;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color? background = Color(CommonData.themeColor);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => Scaffold(
        backgroundColor: background,
        body: ListView(
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(10),),
            const Text("Welcome to", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'Times New Roman'),),
            const Text("CoralSitter", textAlign: TextAlign.center, style: TextStyle(fontSize: 60, color: Colors.white, fontFamily: 'Times New Roman'),),
            SizedBox(height: ScreenUtil().setHeight(8),),
            Image(image: const AssetImage('assets/icons/icon.png'), height: ScreenUtil().setHeight(35),),
            SizedBox(height: ScreenUtil().setHeight(12),),
            // 登陆按钮
            Container(
              height: ScreenUtil().setHeight(5),
              margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white),),
                onPressed: () => Navigator.of(context).pushNamed(MyRouter.logintext, arguments: widget.callback),
                child: Text("Log in", style: TextStyle(fontSize: 15, color: background),)
              )
            ),
            // Container(
            //   height: ScreenUtil().setHeight(4),
            //   margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
            //   child: TextButton(
            //     onPressed: () {},
            //     child: const Text("have no account?", style: TextStyle(fontSize: 12, color: Colors.white30),)
            //   )
            // ),
          ],
        ),
      ),
    );
  }
}