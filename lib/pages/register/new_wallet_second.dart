import 'package:flutter/material.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/customButton.dart';

class BackupWallet extends StatefulWidget {
  final arguments;

  // 构造函数
  BackupWallet({Key key, this.arguments}) : super(key: key);

  @override
  BackupWalletState createState() => BackupWalletState();
}

class BackupWalletState extends State<BackupWallet> {

  bool _isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar().getBaseAppBar(""),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30,),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: Text("创建钱包",style: TextStyle(fontSize: 20,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),)
              ),
              SizedBox(height: 72,),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 34),
                  child: Text("请马上备份您的钱包！",style: TextStyle(fontSize: 18,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),)
              ),
              SizedBox(height: 10,),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text("在下一步中，您将看到12个允许您恢复钱包的单词",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),)
              ),
              Expanded(
                child: Container(width: 0,),
              ),
              InkWell(
                splashColor: Colors.transparent,
                hoverColor:  Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (){
                  setState(() {
                    _isCheck = !_isCheck;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Image.asset(_isCheck ? "images/icon_check_box_sel.png" : "images/icon_check_box.png",width: 16,height: 16,),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Text("我明白，如果我丢失了恢复单词，我将无法访问我的钱包。",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 73,),
              Center(
                child: BaseButton().getBaseButton(text: "继续", onPressed: !_isCheck ? null : (){
                  print(widget.arguments);
                  if (widget.arguments == null) {
                    Navigator.of(context)
                        .pushReplacementNamed("wallet_mnemonic");
                  } else {
                    // Navigator.of(context).pushReplacementNamed(widget.arguments.to);
                    Navigator.pushNamed(context, widget.arguments['to'],
                        arguments: {
                          'res': widget.arguments['res'],
                          'allowCopy': false
                        });
                  }
                }),
              ),
              SizedBox(height: 128,),
            ],
          ),
        ));
  }
}
