/*
Written by 游克垚
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:coralsitter/common.dart';
import 'package:coralsitter/widgets/serverdialog.dart';

// 登陆详情页面
class LoginTextPage extends StatefulWidget {
  const LoginTextPage({ Key? key }) : super(key: key);

  @override
  _LoginTextPageState createState() => _LoginTextPageState();
}

class _LoginTextPageState extends State<LoginTextPage> {
  late Function callback;
  Color? background = Color(CommonData.themeColor);
  final GlobalKey<ServerDialogState> childkey = GlobalKey<ServerDialogState>();
  // 焦点
  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodePassWord = FocusNode();
  final FocusNode _focusNodeConfirmPassWord = FocusNode();

  final TextEditingController _userNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';
  String _confirmPwd = '';
  bool _isShowPwd = false;
  bool _isShowConfirmPwd = false;
  bool _isShowClear = false;
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    _focusNodeConfirmPassWord.addListener(_focusNodeListener);
    _userNameController.addListener((){
      if (_userNameController.text.isNotEmpty) {
        _isShowClear = true;
      }
      else {
        _isShowClear = false;
      }
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _focusNodeConfirmPassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }

  // 焦点监听
  Future<void> _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      _focusNodePassWord.unfocus();
      _focusNodeConfirmPassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      _focusNodeUserName.unfocus();
      _focusNodeConfirmPassWord.unfocus();
    }
    if (_focusNodeConfirmPassWord.hasFocus) {
      _focusNodeUserName.unfocus();
      _focusNodePassWord.unfocus();
    }
  }

  void login() async {
    _focusNodePassWord.unfocus();
    _focusNodeUserName.unfocus();
    _focusNodeConfirmPassWord.unfocus();

    _formKey.currentState!.save();
    if (_username == '' || _password == '') {
      Fluttertoast.showToast(msg: '输入不能为空');
    }
    else {
      Map<dynamic, dynamic> responseData = await childkey.currentState!.post('/login', {
        'username': _username,
        'password': _password
      });

      if (responseData['success'] == null) return;

      if (responseData['success']) {
        CommonData.me = UserInfo(
          userID: responseData['userID'],
          name: responseData['userName'],
          avatar: 'http://' + CommonData.server + '/static/user_avatar/' + responseData['userID'].toString() + '.jpg',
          sign: responseData['sign'],
          tags: responseData['tags']=='' ? []:responseData['tags'].split('-'),
        );
        responseData['mycorals'].forEach((coral) => {
          CommonData.mycorals.add(
            CoralInfo(
              coralID: coral['coralID'],
              name: coral['coralName'],
              avatar: 'http://' + CommonData.server + '/static/coral_avatar/' + coral['coralID'].toString() + '.jpg',
              position: coral['coralPosition'],
              updateTime: coral['updateTime'].split(' ')[0],
              light: coral['light'],
              temp: coral['temp'],
              microelement: coral['microelement'],
              size: coral['size'],
              lastmeasure: coral['lastmeasure'],
              growth: coral['growth'],
              score: coral['score'],
              birthtime: coral['born_date'].split(' ')[0],
              adopttime: coral['adopt_date'].split(' ')[0],
              species: CoralSpecies(
                specieID: coral['species']['specieID'],
                species: coral['species']['species'],
                speciesen: coral['species']['species_EN'],
                tags: coral['species']['tags'].split('-'),
                classification: coral['species']['classification'],
                classificationen: coral['species']['classification_EN'],
                difficulty: coral['species']['difficulty'],
                growspeed: coral['species']['growspeed'],
                current: coral['species']['current'],
                light: coral['species']['light'],
                feed: coral['species']['feed'],
                color: coral['species']['color'],
                attention: coral['species']['attention'].split('-'),
              )
            )
          )
        });
        Navigator.of(context).pop();
        callback();
      }
      else{
        Fluttertoast.showToast(msg: '用户名或密码错误');
      }
    }
  }

  void signUp() async {
    _focusNodePassWord.unfocus();
    _focusNodeUserName.unfocus();
    _focusNodeConfirmPassWord.unfocus();

    _formKey.currentState!.save();
    if (_username == '' || _password == '' || _confirmPwd == '') {
      Fluttertoast.showToast(msg: '输入不能为空');
    }
    else if (_password != _confirmPwd) {
      Fluttertoast.showToast(msg: '输入密码不一致');
    }
    else {
      Map<dynamic, dynamic> responseData = await childkey.currentState!.post('/signup', {
        'username': _username,
        'password': _password
      });

      if (responseData['success'] == null) return;

      if (responseData['success']) {
        CommonData.me = UserInfo(
          userID: responseData['userID'],
          name: responseData['username'],
          avatar: 'http://' + CommonData.server + '/static/user_avatar/' + responseData['userID'].toString() + '.jpg',
          sign: responseData['sign'],
          tags: responseData['tags']=='' ? []:responseData['tags'].split('-'),
        );
        Navigator.of(context).pop();
        callback();
        Navigator.of(context).pushNamed(MyRouter.changeuserinfo);
      }
      else {
        Fluttertoast.showToast(msg: '注册失败');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    callback = ModalRoute.of(context)?.settings.arguments as Function;

    // 用户名输入
    Widget userInput = TextFormField(
      controller: _userNameController,
      focusNode: _focusNodeUserName,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "username",
        labelStyle: const TextStyle(color: Colors.white),
        hintText: "",
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.person, color: Colors.white,),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        // 清除按钮
        suffixIcon: (_isShowClear) ? IconButton(
          icon: const Icon(Icons.clear, color: Colors.white,),
          onPressed: (){
            _userNameController.clear();
          },
        ) : null,
      ),
      onSaved: (String? value){
        _username = value!;
      },
    );

    // 米码输入
    Widget pswInput = TextFormField(
      focusNode: _focusNodePassWord,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "password",
        labelStyle: const TextStyle(color: Colors.white),
        hintText: "",
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.lock, color: Colors.white,),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        // 显示隐藏密码按钮
        suffixIcon: IconButton(
          icon: Icon((_isShowPwd) ? Icons.visibility : Icons.visibility_off, color: Colors.white,),
          onPressed: (){
            setState(() {
              _isShowPwd = !_isShowPwd;
            });
          },
        )
      ),
      obscureText: !_isShowPwd,
      onSaved: (String? value){
        _password = value!;
      },
    );

    // 确认密码输入
    Widget confirmPswInput = TextFormField(
      focusNode: _focusNodeConfirmPassWord,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "confirm password",
        labelStyle: const TextStyle(color: Colors.white),
        hintText: "",
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.lock, color: Colors.white,),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        // show password
        suffixIcon: IconButton(
          icon: Icon((_isShowConfirmPwd) ? Icons.visibility : Icons.visibility_off, color: Colors.white,),
          onPressed: (){
            setState(() {
              _isShowConfirmPwd = !_isShowConfirmPwd;
            });
          },
        )
      ),
      obscureText: !_isShowConfirmPwd,
      onSaved: (String? value){
        _confirmPwd = value!;
      },
    );

    return ScreenUtilInit(
      designSize: const Size(100, 100),
      // 取消键盘
      builder: () => GestureDetector(
        onTap: () {
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
          _focusNodeConfirmPassWord.unfocus();
        },
        child: ServerDialog(
          key: childkey,
          child: Scaffold(
            backgroundColor: background,
            body: ListView(
              children: [
                SizedBox(height: ScreenUtil().setHeight(8),),
                Image(image: const AssetImage('assets/icons/icon.png'), height: ScreenUtil().setHeight(20),),
                SizedBox(height: ScreenUtil().setHeight(8),),
                // 输入区域
                Container(
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: background
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        userInput,
                        pswInput,
                        _isLogin ? const SizedBox() : confirmPswInput,
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(5),),
                // 登陆或注册按钮
                Container(
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                  child: TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white),),
                    onPressed: _isLogin ? login : signUp,
                    child: Text(_isLogin ? "Log in" : "Sign up", style: TextStyle(fontSize: 15, color: background),)
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(4),
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin ? "have no account?" : "already have an account?", style: const TextStyle(fontSize: 12, color: Colors.white30),)
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}