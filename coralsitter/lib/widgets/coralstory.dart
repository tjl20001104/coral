/*
Written by 游克垚
*/

import 'package:flutter/material.dart';

// 珊瑚故事
Widget coralStory(double width, String time, String text, String image) {
  return Container(
    width: width,
    margin: const EdgeInsets.only(bottom: 20.0),
    child: Card(
      margin: const EdgeInsets.all(0.0),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      shadowColor: Colors.black45,
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(0.05 * width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
            const SizedBox(height: 8.0),
            Text(text, style: const TextStyle(fontSize: 14, color: Colors.black54,),),
            const SizedBox(height: 5.0),
            image == '' ? const SizedBox() : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(image, width: 0.9 * width, fit: BoxFit.cover,),
            ),
          ],
        ),
      ),
    ),
  );
}