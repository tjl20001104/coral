/*
Written by 游克垚
*/

import 'package:flutter/material.dart';

import 'package:coralsitter/common.dart';

// 进度条
Widget progressBar(value, width, height, {flag = true}) {
  Color outColor = flag ? Color(CommonData.themeColor) : Colors.white;
  Color inColor = flag ? Colors.white : Color(CommonData.themeColor);
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      border: Border.all(width: 1, color: inColor),
      borderRadius: BorderRadius.all(Radius.circular(height/2)),
    ),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: outColor),
        borderRadius: BorderRadius.all(Radius.circular(height/2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(height/2)),
        child: LinearProgressIndicator(
          backgroundColor: outColor,
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(inColor),
        ),
      ),
    ),
  );
}