/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

// 轮播图
Widget swiperCards(List<String> urls, BuildContext context) {
  return Swiper(
    itemBuilder: (context, index) => Image.network(
      urls[index],
      fit: BoxFit.cover,
    ),
    itemCount: urls.length,
    pagination: const SwiperPagination(
      builder: DotSwiperPaginationBuilder(
      color: Colors.black54,
      activeColor: Colors.white,
    )),
    scrollDirection: Axis.horizontal,
    autoplay: true,
    onTap: (index) => print('点击了第$index个'),
  );
}