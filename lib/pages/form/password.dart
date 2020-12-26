import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/customButton.dart';

class PasswordPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar().getBaseAppBar("设置密码"),
        body: new Builder(builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                buildTitleLine(),
                SizedBox(height: 70.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildTips('密码长度为8-20位的字母或者数字'),
                SizedBox(height: 60.0),
//                      buildLoginButton(context),
                buildButton(context)
              ],
            ));
        }),
    );
  }

  // 获取用户两次输入的密码，两次密码必须相同
  Align buildLoginButton(BuildContext context) {

    return BaseButton().getBaseButton(text: "确定", onPressed: (){
      _formKey.currentState.save();
      if (_email == _password && !_email.isEmpty) {
        Navigator.of(context).pop(_email);
      } else {
        if (_email.isEmpty || _password.isEmpty) {
          showToast('不能为空');
        } else {
          showToast('两次输入密码不同');
        }
      }
    });

  }

  Widget buildButton(BuildContext context) {
    return BaseButton().getBaseButton(text: "确定", onPressed: (){
      _formKey.currentState.save();
      if (_email == _password &&
          !_email.isEmpty &&
          _email.length >= 8 &&
          _email.length <= 20) {
        Navigator.of(context).pop(_email);
      } else {
        if (_email.isEmpty || _password.isEmpty) {
          final snackBar = new SnackBar(content: new Text('不能为空'));
          Scaffold.of(context).showSnackBar(snackBar);
        } else {
          String val = '';
          if (_email.length < 8) {
            val = '长度必须大于等于8位';
          } else if (_email.length > 20) {
            val = '长度必须小于等于20位';
          } else {
            val = '两次输入密码不同';
          }
          final snackBar = new SnackBar(content: new Text(val));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      }
    });
  }

  Widget buildPasswordTextField(BuildContext context) {
    return Container(
      height: 56,
      child: TextFormField(
        onSaved: (String value) => _password = value,
        style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),
        decoration: InputDecoration(
          hintText: '请再次输入密码',
          filled: true,
          hintStyle: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return Container(
      height: 56,
      child: TextFormField(
        style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),
        decoration: InputDecoration(
          hintText: '请输入密码',
          filled: true,
          hintStyle: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide.none),
        ),
        onSaved: (String value) => _email = value,
      ),
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.white,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Widget buildTips(String val) {
    return Container(
        padding: EdgeInsets.only(top: 16.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.help, size: 16.0, color: Colors.black26),
            Text(
              val,
              style: TextStyle(fontSize: 12.0,color: MyColors.GRAY_TEXT_99),
            ),
          ],
        ));
  }
}
