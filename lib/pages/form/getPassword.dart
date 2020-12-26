
import 'package:flutter/material.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/customButton.dart';

import 'package:youwallet/global.dart';
import 'package:youwallet/db/sql_util.dart';
import 'package:youwallet/util/wallet_crypt.dart';
import 'package:web3dart/web3dart.dart';

//在该页面让用户输入密码
//通过密码解密出私钥
class GetPasswordPage extends StatefulWidget {

  final arguments;
  GetPasswordPage({Key key ,this.arguments}) : super();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<GetPasswordPage> {

  final _formKey = GlobalKey<FormState>();

  bool showExtraSet = false;
  Map data = {
    'gasPrice': '10', // 这个字段放到全局变量中去
    'gasLimit': Global.gasLimit.toString(),
    'pwd': ''
  };

  String type = "";

  @override
  void initState() {
    super.initState();
    if(widget.arguments != null) {
      type = widget.arguments["from"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.arguments);
    return Scaffold(

        appBar: BaseAppBar().getBaseAppBar(""),
        body: new Builder(builder: (BuildContext context) {
          return Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  buildTitle(),
                  SizedBox(height: 23.0),
                  _buildPassword(),
                  buildExtraTip(),
                  buildExtraSet(this.showExtraSet),
                  SizedBox(height: 60.0),
                  buildLoginButton(context),
                ],
              )
          );
        })
    );
  }

  //标题栏
  Widget buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 19),
      child: Row(
        children: <Widget>[
          Text(type == "export" ? "导出":"转账",style: TextStyle(fontSize: 20,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }



  // 获取用户密码
  Widget buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: BaseButton().getBaseButton(text: "确认", onPressed: ()async {
            _formKey.currentState.save();

             if (this.data['pwd'].isEmpty) {
               final snackBar = new SnackBar(content: new Text('密码不能为空'));
               Scaffold.of(context).showSnackBar(snackBar);
               return;
             }
            if (this.data['gasLimit'].isEmpty) {
              final snackBar = new SnackBar(content: new Text('gasLimit不能为空'));
              Scaffold.of(context).showSnackBar(snackBar);
              return;
            }

            if (this.data['gasPrice'].isEmpty) {
              final snackBar = new SnackBar(content: new Text('gasPrice不能为空'));
              Scaffold.of(context).showSnackBar(snackBar);
              return;
            }

            try {
              print('try');
              this.data['privateKey'] = await this.getPrivateKey(this.data['pwd']);
              print(this.data['gasPrice'] + '000000000');
              this.data['gasPrice'] = EtherAmount.inWei(BigInt.parse(this.data['gasPrice'] + '000000000'));
              this.data['gasLimit'] = int.parse(this.data['gasLimit']);
              Navigator.of(context).pop(this.data);
            } catch (e) {
              // 真机上测试，发现密码输入错误，页面也会返回，真机和IDE的编译模式不一样，错误的判断不一致
              // 预期情况下，这里不应该返回
              final snackBar = new SnackBar(content: new Text('解密失败，请确认密码是否正确'));
              Scaffold.of(context).showSnackBar(snackBar);
            }

            FocusScope.of(context).requestFocus(FocusNode());
          }
      ),
    );
  }

  Widget _buildPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("输入密码",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.all(15),
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6)
            ),
            child: TextField(
              maxLines: 1,
              style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入密码",
                hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
              ),
              onChanged: (String value) => this.data['pwd'] = value,
            ),
          ),
        ],
      ),
    );
  }

  // 高级设置
  // 如果用户是在导出私钥或者助记忆词，则不=显示高级设置
  Widget buildExtraTip() {
    if (widget.arguments == null) {
      return GestureDetector(
          onTap: () {
            setState(() {
              this.showExtraSet = !this.showExtraSet;
            });
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15.0, top: 23.0),
            child: Text(
                '高级设置',
                style: TextStyle(color: Colors.lightBlue)
            ),
          )
      );
    } else {
      return Text('');
    }
  }

  Widget buildExtraSet(bool showSet) {
    if(this.showExtraSet) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: new Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 4.0),
                child: TextFormField(
                    controller: TextEditingController(text: "${this.data['gasLimit']}"),
                    style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),
                    decoration: InputDecoration(
                      hintText: '请输入gasLimit',
                      hintStyle: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),
                      helperText: "自定义gasLimit", //输入框底部辅助性说明文字
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide.none
                      ),
                    ),
                    onSaved: (String value) => this.data['gasLimit'] = value)
            ),
            TextFormField(
              controller: TextEditingController(text: "${this.data['gasPrice']}"),
              style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),
              decoration: InputDecoration(
                hintText: '请输入gasPrice',
                helperText: "自定义gasPrice",
                suffixText: 'Gwei',
                hintStyle: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide.none
                ),
              ),
              onSaved: (String value) => this.data['gasPrice'] = value,
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }
  // static 方法获取用户私钥
  // 这里的操作优化到model中去
  Future<String> getPrivateKey(String pwd) async{
    String address =  Global.getPrefs("currentWallet");

    var sql = SqlUtil.setTable("wallet");
    var map = {'address': address};
    List json = await sql.query(conditions: map);
    var res = await WalletCrypt(pwd, json[0]['privateKey']).decrypt();
    print('================');
    print('WalletCrypt done => ${res}');
    print('================');
    if (res == null || res == "Failed to get string encoded: 'Decrypt failure.'.") {
      throw FormatException('钱包密码错误');
    } else {
      return res;
    }
  }
}
