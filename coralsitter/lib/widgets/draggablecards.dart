/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// 卡片内容
Widget cardContent(String url, String text) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      const SizedBox(),
      Card(
        margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Image.network(
          url,
        ),
      ),
      Padding(padding: const EdgeInsets.only(right: 15.0), child: Text(text, style: const TextStyle(fontSize: 16, fontFamily: 'Times New Roman'),),),
    ],
  );
}

// 无限拖动卡片
class DraggableCards extends StatefulWidget {
  const DraggableCards({ Key? key, required this.width, required this.height, required this.urls, required this.texts, required this.getPos, required this.next }) : super(key: key);
  final double width;
  final double height;
  final List<String> urls;
  final List<String> texts;
  final Function getPos;
  final Function next;

  @override
  _DraggableCardsState createState() => _DraggableCardsState();
}

class _DraggableCardsState extends State<DraggableCards> with SingleTickerProviderStateMixin {
  CustomAnimationControl removeControl = CustomAnimationControl.stop;
  CustomAnimationControl insertControl = CustomAnimationControl.stop;
  List<Size> sizes = [];
  List<double> lefts = [];
  List<String> images = [];
  List<String> texts = [];
  double x = 0;
  double toMove = 0;

  void changeCardsOrder() {
    widget.next();
    images.removeAt(2);
    images.insert(0, widget.urls[widget.getPos()]);
    texts.removeAt(2);
    texts.insert(0, widget.texts[widget.getPos()]);
  }

  @override
  void initState() {
    super.initState();
    x = widget.width * 0.075;
    sizes = [Size(widget.width * 0.65, widget.height * 0.75), Size(widget.width * 0.7, widget.height * 0.8), Size(widget.width * 0.75, widget.height * 0.85)];
    lefts = [widget.width * 0.285, widget.width * 0.18, widget.width * 0.075];
    if (widget.urls.length > 2) {
      images = [widget.urls[2], widget.urls[1], widget.urls[0]];
      texts = [widget.texts[2], widget.texts[1], widget.texts[0]];
    }
    else if (widget.urls.length == 2) {
      images = [widget.urls[0], widget.urls[1], widget.urls[0]];
      texts = [widget.texts[0], widget.texts[1], widget.texts[0]];
    }
    else {
      images = [widget.urls[0], widget.urls[0], widget.urls[0]];
      texts = [widget.texts[0], widget.texts[0], widget.texts[0]];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        if (insertControl == CustomAnimationControl.stop && removeControl == CustomAnimationControl.stop) {
          setState(() {
            x += details.delta.dx;
          });
        }
      },
      onPanEnd: (DragEndDetails details) {
        if (insertControl == CustomAnimationControl.stop && removeControl == CustomAnimationControl.stop) {
          if (x < - widget.width * 0.1) {
            toMove = -widget.width;
          }
          else if (x > widget.width * 0.4) {
            toMove = widget.width;
          }
          else {
            toMove = lefts[2] - x;
          }
          removeControl = CustomAnimationControl.playFromStart;
          setState(() {});
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: widget.width, height: widget.height,),
          // 第三张
          Positioned(
            left: lefts[0],
            child: Transform.rotate(
              angle: (lefts[0] - lefts[2]) * 0.0005,
              child: SizedBox(
                width: sizes[0].width,
                height: sizes[0].height,
                child: Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.all(0.0),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: cardContent(images[0], texts[0]),
                ),
              ),
            ),
          ),
          // 第二张
          CustomAnimation(
            control: insertControl,
            duration: Duration(milliseconds: (500).round()),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, child, double value) {
              return Positioned(
                left: insertControl == CustomAnimationControl.playFromStart ? value * (lefts[1] - lefts[0]) + lefts[0] : lefts[1],
                child: Transform.rotate(
                  angle: insertControl == CustomAnimationControl.playFromStart ? (value * (lefts[1] - lefts[0]) + lefts[0] - lefts[2]) * 0.0005 : (lefts[1] - lefts[2]) * 0.0005,
                  child: SizedBox(
                    width: insertControl == CustomAnimationControl.playFromStart ? value * (sizes[1].width - sizes[0].width) + sizes[0].width : sizes[1].width,
                    height: insertControl == CustomAnimationControl.playFromStart ? value * (sizes[1].height - sizes[0].height) + sizes[0].height : sizes[1].height,
                    child: Card(
                      elevation: 5.0,
                      margin: const EdgeInsets.all(0.0),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: cardContent(images[1], texts[1],),
                    ),
                  ),
                ),
              );
            },
            onComplete: () {
              insertControl = CustomAnimationControl.stop;
            },
          ),
          // 第一张
          CustomAnimation(
            control: removeControl,
            duration: Duration(milliseconds: (450).round()),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, child, double value) {
              return Positioned(
                left: insertControl != CustomAnimationControl.playFromStart ? (removeControl == CustomAnimationControl.playFromStart ? (x + value * toMove) : x) : lefts[1] + value * (lefts[2] - lefts[1]),
                child: Transform.rotate(
                  angle: insertControl != CustomAnimationControl.playFromStart ? (removeControl == CustomAnimationControl.playFromStart ? (x + value * toMove - lefts[2]) * 0.0005 : (x - lefts[2]) * 0.0005) : (lefts[1] + value * (lefts[2] - lefts[1]) - lefts[2]) * 0.0005,
                  child: Card(
                    elevation: 5.0,
                    margin: const EdgeInsets.all(0.0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: SizedBox(
                      width: insertControl == CustomAnimationControl.playFromStart ? value * (sizes[2].width - sizes[1].width) + sizes[1].width : sizes[2].width,
                      height: insertControl == CustomAnimationControl.playFromStart ? value * (sizes[2].height - sizes[1].height) + sizes[1].height : sizes[2].height,
                      child: cardContent(images[2], texts[2]),
                    ),
                  ),
                ),
              );
            },
            onComplete: () {
              if (insertControl == CustomAnimationControl.playFromStart || (toMove != -widget.width && toMove != widget.width)) {
                removeControl = CustomAnimationControl.stop;
                x = lefts[2];
              }
              else {
                changeCardsOrder();
                removeControl = CustomAnimationControl.playFromStart;
                insertControl = CustomAnimationControl.playFromStart;
              }
            },
          ),
        ],
      ),
    );
  }
}