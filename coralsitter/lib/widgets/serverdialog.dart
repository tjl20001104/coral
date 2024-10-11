/*
Written by 游克垚
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:coralsitter/common.dart';

// 后端交互
class ServerDialog extends StatefulWidget {
  const ServerDialog({
    Key? key,
    this.progress = const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white70)),
    this.alpha = 0.6,
    this.textColor = Colors.black,
    required this.child
  }) : super(key: key);
  final Widget child;
  final Widget progress;
  final double alpha;
  final Color textColor;

  @override
  ServerDialogState createState() => ServerDialogState();
}

class ServerDialogState extends State<ServerDialog> {
  bool loading = false;

  Future<Map> post(String route, Map data, {int waitTime=500}) async {
    Map<dynamic, dynamic> responseData = {};
    loading = true;
    setState(() {});
    await Future.delayed(Duration(milliseconds: waitTime));
    try {
      Uri uri = Uri.parse('http://' + CommonData.server + route);
      http.Response response = await http.post(
        uri,
        body: data,
      );
      responseData = json.decode(response.body);
      loading = false;
    }
    catch(e) {
      print(e);
      Fluttertoast.showToast(msg: '服务器连接失败');
    }
    loading = false;
    setState(() {});
    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(widget.child);
    if (loading) {
      Widget layoutProgress;
      layoutProgress = Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Container(
            alignment: Alignment.center,
            width: 50.0,
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.progress,
              ],
            ),
          ),
        ),
      );
      widgetList.add(Opacity(
        opacity: widget.alpha,
        child: const ModalBarrier(color: Colors.black87, dismissible: false,),
      ));
      widgetList.add(layoutProgress);
    }
    return Stack(
      children: widgetList,
    );
  }
}