/*
Written by 游克垚
*/

import 'package:flutter/material.dart';

import 'package:coralsitter/pages/adoptpage.dart';
import 'package:coralsitter/pages/boxresultpage.dart';
import 'package:coralsitter/pages/changeuserinfopage.dart';
import 'package:coralsitter/pages/chooseboxpage.dart';
import 'package:coralsitter/pages/coralcardspage.dart';
import 'package:coralsitter/pages/coralcompletepage.dart';
import 'package:coralsitter/pages/coralidentitypage.dart';
import 'package:coralsitter/pages/coralpage.dart';
import 'package:coralsitter/pages/coralresultpage.dart';
import 'package:coralsitter/pages/logintextpage.dart';
import 'package:coralsitter/pages/matchpage.dart';
import 'package:coralsitter/pages/openboxpage.dart';
import 'package:coralsitter/pages/settingpage.dart';
import 'package:coralsitter/pages/speciespage.dart';

// 页面路由
class MyRouter {
  static const adopt = 'adopt';
  static const boxresult = 'boxresult';
  static const changeuserinfo = 'changeuserinfo';
  static const choosebox = 'choosebox';
  static const coralcards = 'coralcards';
  static const coralcomplete = 'coralcomplete';
  static const coralidentity = 'coralidentity';
  static const coral = 'coral';
  static const coralresult = 'coralresult';
  static const logintext = 'logintext';
  static const match = 'match';
  static const openbox = 'openbox';
  static const setting = 'setting';
  static const species = 'species';

  static final Map<String, WidgetBuilder> routes = {
    adopt: (context) => const AdoptPage(),
    boxresult: (context) => const BoxResultPage(),
    changeuserinfo: (context) => const ChangeUserInfoPage(),
    choosebox: (context) => const ChooseBoxPage(),
    coralcards: (context) => const CoralCardsPage(),
    coralcomplete: (context) => const CoralCompletePage(),
    coralidentity: (context) => const CoralIdentityPage(),
    coral: (context) => const CoralPage(),
    coralresult: (context) => const CoralResultPage(),
    logintext: (context) => const LoginTextPage(),
    match: (context) => const MatchPage(),
    openbox: (context) => const OpenBoxPage(),
    setting: (context) => const SettingPage(),
    species: (contet) => const SpeciesPage(),
  };
}

// 用户信息
class UserInfo {
  int userID; // 用户ID
  String name; // 用户名称
  String avatar; // 用户头像
  String sign; // 用户签名
  List<String> tags; // 用户标签
  UserInfo({required this.userID, required this.name, required this.avatar, required this.sign, required this.tags});
}

// 珊瑚种类信息
class CoralSpecies {
  int specieID;
  String species; // 珊瑚种类名
  String speciesen; // 珊瑚种类英文
  List<String> tags; // 珊瑚标签
  String classification; // 珊瑚大类
  String classificationen; // 珊瑚大类英文
  int difficulty; // 种植难度
  String growspeed; // 生长速度
  String current; // 水流
  String light; // 光照
  String feed; // 喂养要求
  String color; // 色卡
  List<String> attention; // 注意事项
  CoralSpecies({required this.specieID, required this.species, required this.speciesen, required this.tags, required this.classification, required this.classificationen, required this.difficulty, required this.growspeed, required this.current, required this.light, required this.feed, required this.color, required this.attention});
}

// 珊瑚信息
class CoralInfo {
  int coralID; // 珊瑚ID
  String name; // 珊瑚名称
  String avatar; // 珊瑚头像
  String position; // 珊瑚地址
  String updateTime; // 珊瑚状态更新时间
  String light; // 光照强度
  String temp; // 海水气温
  String microelement; // 微量元素
  int size; //大小
  double lastmeasure; //距离上次测量
  double growth; // 平均每月增长
  int score; // 珊瑚得分
  String birthtime; // 出生日期
  String adopttime; // 领养日期
  CoralSpecies species; // 种类
  CoralInfo({required this.coralID, required this.name, required this.avatar, required this.position, required this.updateTime, required this.light, required this.temp, required this.microelement, required this.size, required this.lastmeasure, required this.growth, required this.score, required this.birthtime, required this.adopttime, required this.species});
}

class CommonData {
  static UserInfo? me; // 当前登陆用户
  static List<CoralInfo> mycorals = []; // 当前登陆用户拥有珊瑚
  static String server = "192.168.10.7:3000"; // 后端地址
  static int themeColor = 0xFF0058ea; // 主题颜色
}