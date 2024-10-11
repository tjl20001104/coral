/*
Written by 游克垚
*/

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/serverdialog.dart';

// 标签控件
Widget tagItem(String tag, Function tap, bool isChoosen) {
  return GestureDetector(
    onTap: () => tap(),
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isChoosen ? Colors.blue[100] : Colors.grey[100],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: isChoosen ? Colors.black : Colors.black54,
          fontSize: 14.0,
        ),
      ),
    ),
  );
}

// 编辑资料页面
class ChangeUserInfoPage extends StatefulWidget {
  const ChangeUserInfoPage({ Key? key }) : super(key: key);

  @override
  _ChangeUserInfoPageState createState() => _ChangeUserInfoPageState();
}

class _ChangeUserInfoPageState extends State<ChangeUserInfoPage> {
  final GlobalKey<ServerDialogState> childkey = GlobalKey<ServerDialogState>();

  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodeSign = FocusNode();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _signController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  List<String> choosenTags = List.from(CommonData.me!.tags);
  XFile? avatarImage;
  Map<String, Map<String, bool>> allTags = {
    '星座': {
      '白羊': CommonData.me!.tags.contains('白羊'),
      '金牛': CommonData.me!.tags.contains('金牛'),
      '双子': CommonData.me!.tags.contains('双子'),
      '巨蟹': CommonData.me!.tags.contains('巨蟹'),
      '狮子': CommonData.me!.tags.contains('狮子'),
      '处女': CommonData.me!.tags.contains('处女'),
      '天秤': CommonData.me!.tags.contains('天秤'),
      '天蝎': CommonData.me!.tags.contains('天蝎'),
      '射手': CommonData.me!.tags.contains('射手'),
      '摩羯': CommonData.me!.tags.contains('摩羯'),
      '水瓶': CommonData.me!.tags.contains('水瓶'),
      '双鱼': CommonData.me!.tags.contains('双鱼'),
    },
    '年龄': {
      '00后': CommonData.me!.tags.contains('00后'),
      '95后': CommonData.me!.tags.contains('95后'),
      '90后': CommonData.me!.tags.contains('90后'),
      '80后': CommonData.me!.tags.contains('80后'),
      '70后': CommonData.me!.tags.contains('70后'),
    },
    '穿搭': {
      '汉服': CommonData.me!.tags.contains('汉服'),
      '国潮': CommonData.me!.tags.contains('国潮'),
      '撞色': CommonData.me!.tags.contains('撞色'),
      '复古': CommonData.me!.tags.contains('复古'),
      '运动': CommonData.me!.tags.contains('运动'),
      '西装': CommonData.me!.tags.contains('西装'),
    },
    '性格': {
      '大大咧咧': CommonData.me!.tags.contains('大大咧咧'),
      '乐观': CommonData.me!.tags.contains('乐观'),
      '玻璃心': CommonData.me!.tags.contains('玻璃心'),
    },
    '待人': {
      '内向': CommonData.me!.tags.contains('内向'),
      '害羞': CommonData.me!.tags.contains('害羞'),
      '开朗': CommonData.me!.tags.contains('开朗'),
      '热情': CommonData.me!.tags.contains('热情'),
    },
    '处事': {
      '沉稳': CommonData.me!.tags.contains('沉稳'),
      '冷静': CommonData.me!.tags.contains('冷静'),
      '好奇': CommonData.me!.tags.contains('好奇'),
      '勇敢': CommonData.me!.tags.contains('勇敢'),
    },
    '角色': {
      '聆听者': CommonData.me!.tags.contains('聆听者'),
      '组织者': CommonData.me!.tags.contains('组织者'),
      '管理者': CommonData.me!.tags.contains('管理者'),
    },
  };

  // 焦点监听
  Future<void> _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      _focusNodeSign.unfocus();
    }
    if (_focusNodeSign.hasFocus) {
      _focusNodeUserName.unfocus();
    }
  }

  void saveChange() async {
    Map requestData = {
      'userID': CommonData.me!.userID.toString(),
      'userName': _userNameController.text,
      'sign': _signController.text,
      'tags': choosenTags.join('-'),
    };
    if (avatarImage != null) {
      requestData['avatar'] = base64Encode(await avatarImage!.readAsBytes());
    }
    else {
      requestData['avatar'] = '';
    }
    Map<dynamic, dynamic> responseData = await childkey.currentState!.post('/changeUserInfo', requestData);

    if (responseData['success'] == null) return;

    if (responseData['success']) {
      CommonData.me!.name = _userNameController.text;
      CommonData.me!.sign = _signController.text;
      CommonData.me!.tags = List.from(choosenTags);
      Navigator.of(context).pop();
    }
    else {
      Fluttertoast.showToast(msg: '保存失败');
    }
  }

  // 选择标签，大类只能选一个
  void chooseTag(String title, String tag) {
    allTags[title]!.forEach((key, value) {
      if (key != tag) {
        if (value) {
          allTags[title]![key] = false;
          choosenTags.remove(key);
        }
      }
      else {
        if (value) {
          allTags[title]![key] = false;
          choosenTags.remove(key);
        }
        else {
          allTags[title]![key] = true;
          choosenTags.add(key);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodeSign.addListener(_focusNodeListener);
    _userNameController.text = CommonData.me!.name;
    _signController.text = CommonData.me!.sign;
  }

  @override
  void dispose() {
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodeSign.removeListener(_focusNodeListener);
    _userNameController.dispose();
    _signController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // 用户名输入
    Widget userInput = SizedBox(
      height: 25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: ScreenUtil().setWidth(20),
            child: const Text('用户名：', style: TextStyle(color: Colors.black, fontSize: 16,),),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(65),
            child: TextField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              style: const TextStyle(color: Colors.black, fontSize: 16,),
              decoration: const InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                
              ),
            ),
          ),
        ],
      ),
    );

    // 签名输入
    Widget signInput = SizedBox(
      height: 25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: ScreenUtil().setWidth(20),
            child: const Text('签名：', style: TextStyle(color: Colors.black, fontSize: 16,),),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(65),
            child: TextField(
              controller: _signController,
              textAlignVertical: TextAlignVertical.center,
              focusNode: _focusNodeSign,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),               
              ),
            ),
          ),
        ],
      ),
    );

    // 用户头像，用户名，签名区域
    Widget topArea = Container(
      margin: const EdgeInsets.all(0.0),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5), vertical: 10.0),
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20.0)],
        color: Colors.grey[100],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _picker.pickImage(source: ImageSource.gallery).then((image) {
                avatarImage = image;
                setState(() {});
              });
            },
            child: avatarImage == null ? Image.network(
              CommonData.me!.avatar + '?' + DateTime.now().millisecondsSinceEpoch.toString(),
              width: ScreenUtil().setWidth(25),
              height: ScreenUtil().setWidth(25),
              fit: BoxFit.cover,
            ) : Image.file(
                File(avatarImage!.path),
                width: ScreenUtil().setWidth(25),
                height: ScreenUtil().setWidth(25),
                fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15.0,),
          userInput,
          const Divider(),
          const SizedBox(height: 10.0,),
          signInput,
          const Divider(),
        ],
      ),
    );

    // 选择标签区域
    Widget tagsArea = Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5)),
        children: allTags.keys.map((title) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Text(title, style: const TextStyle(fontSize: 18, color: Colors.black),),
            const SizedBox(height: 10,),
            GridView.count(
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              crossAxisCount: 3,
              childAspectRatio: 3.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: allTags[title]!.keys.map((k) => tagItem(
                k,
                () {
                  // allTags[title]![k] = !allTags[title]![k]!;
                  // if (choosenTags.contains(k)) {
                  //   choosenTags.remove(k);
                  // }
                  // else {
                  //   choosenTags.add(k);
                  // }
                  chooseTag(title, k);
                  setState(() {});
                },
                allTags[title]![k]!,
              )).toList(),
            ),
          ],
        )).toList(),
      )
    );

    // 保存按钮区域
    Widget buttonArea = Container(
      margin: const EdgeInsets.all(0.0),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5), vertical: ScreenUtil().setHeight(1)),
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20.0)],
        color: Colors.grey[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(CommonData.themeColor)),),
            onPressed: saveChange,
            child: const Text("保存", style: TextStyle(fontSize: 14, color: Colors.white),)
          ),
        ],
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      builder: () => GestureDetector(
        onTap: (){
          _focusNodeUserName.unfocus();
          _focusNodeSign.unfocus();
        },
        child: ServerDialog(
          key: childkey,
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: ScreenUtil().setHeight(7),
              leadingWidth: ScreenUtil().setWidth(15),
              leading: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(3)),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.keyboard_arrow_left, color: Colors.black, size: ScreenUtil().setHeight(4),),
                ),
              ),
              title: Text("编辑资料", style: TextStyle(fontSize: ScreenUtil().setHeight(2.6), fontWeight: FontWeight.bold,),),
              centerTitle: true,
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                topArea,
                tagsArea,
                buttonArea,
              ],
            ),
          ),
        ),
      ),
    );
  }
}