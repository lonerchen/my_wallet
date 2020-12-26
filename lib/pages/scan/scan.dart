
import 'package:flutter/material.dart';
import 'package:youwallet/util/toast.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/customButton.dart';
import 'package:flutter/services.dart';

class Scan extends StatefulWidget {

  final arguments;
  Scan({Key key,this.arguments}) : super(key: key);

  @override
  Page createState()  => Page();
}

class Page extends State<Scan> {

  final globalKey = GlobalKey<ScaffoldState>();
  void showSnackbar(String text) {
    final snackBar = SnackBar(content: Text(text));
    globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: BaseAppBar().getBaseAppBar(""),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.only(left:15.0),
                child: Text("导出",style: TextStyle(fontSize: 20,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 26,),
              Padding(
                padding: const EdgeInsets.only(left:15.0),
                child: Text("ETH",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
              ),
              SizedBox(height: 15,),
              new Container(
                padding: const EdgeInsets.symmetric(horizontal:21.0),
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white
                ),
                child: Center(
                  child: new Text(
                      widget.arguments['res']??'',
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: MyColors.BLACK_TEXT_22,
                      )
                  ),
                ),
              ),
              SizedBox(height: 50,),
              showButton()
//              new CustomButton(
//                content: '添加token',
//                onSuccessChooseEvent:(res){
//                  Navigator.pushNamed(context, "set_wallet_name");
//                }
//              ),
//              new CustomButton(
//                  content: '转账',
//                  onSuccessChooseEvent:(res){
//                    Navigator.pushNamed(context, "load_wallet");
//                  }
//              )
            ],
          ),
        )
    );
  }

  // 通过arguments中的参数来判是否显示复制按钮
  Widget showButton() {
      return Center(
        child: BaseButton().getBaseButton(text: "复制", onPressed: (){
          ClipboardData data = new ClipboardData(
              text: widget.arguments['res'] ?? '');
          Clipboard.setData(data);
          ToastUtils.showCopyOk();
        }),
      );
  }
}
