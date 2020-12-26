import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/model/wallet_center.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';

///
/// 质押界面
///

class PledgeCoinPage extends StatefulWidget {
  @override
  _PledgeCoinPageState createState() => _PledgeCoinPageState();
}

class _PledgeCoinPageState extends State<PledgeCoinPage> {

  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    WalletCenter walletCenter = Provider.of<WalletCenter>(Global.context);
    walletCenter.getCoinList();
    _textEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar(""),
      body: Consumer<WalletCenter>(
        builder: (context,walletCenter,child) =>Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 24,),
              Text("质押币种",style: TextStyle(fontSize: 20,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
              SizedBox(height: 35),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("币种：",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12,),),
                  SizedBox(width: 5,),
                  Image.network("${walletCenter.currentWalletCenter.icon}",width: 18,height: 18,),
                  Text("${walletCenter.currentWalletCenter.name}",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12,),),
                  Expanded(child: Container(height: 0,)),
                  Text("可升级余额：${walletCenter.currentWalletCenter.balance}",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                ],
              ),
              SizedBox(height: 14,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入升级金额",
                            hintStyle: TextStyle(fontSize: 12)
                          ),
                        ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Text("全部",style: TextStyle(color: MyColors.THEME_COLORS,fontSize: 12),)
                    )


                  ],
                ),
              ),
              SizedBox(height: 50,),
              Center(
                child: BaseButton().getBaseButton(text: "确定", onPressed: (){

                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
