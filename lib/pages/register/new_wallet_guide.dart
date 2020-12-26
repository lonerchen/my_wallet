
import 'package:flutter/material.dart';
import 'package:youwallet/pages/tabs/tab_defi.dart';
import 'package:youwallet/util/face.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/customButton.dart';

import 'package:provider/provider.dart';
import 'package:youwallet/model/wallet.dart';

class WalletGuide extends StatefulWidget {
  WalletGuide() : super();
  @override
  _WalletGuideState createState()  => _WalletGuideState();
}

class _WalletGuideState extends State<WalletGuide> {

  final globalKey = GlobalKey<ScaffoldState>();
  void showSnackbar(String text) {
    final snackBar = SnackBar(content: Text(text));
    globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          elevation: Provider.of<Wallet>(context).items.length > 0 ? 3:0,
          title: Text(""),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              //icon
              Expanded(
                child: Image.asset("images/icon_login_or_register.png",width: 246,height: 249,),
              ),
              //创建钱包
              BaseButton().getBaseButton(
                text:"创建钱包",
                onPressed: () {
//                  Web3ViewChannel().faceStart(chainId:"3",rpcServerUrl:"https://ropsten.infura.io/v3/9ff09f1a3c284d28830665290dab81c5",walletAddress: "0xb44b516931375c9f7bfce23e339b70a811da9885",url: "https://pandora.vpntube.app/build/index.html#/swap");
//                  Navigator.push(context, MaterialPageRoute(builder: (context){
//                    return TabDefiPage();
//                  }));
                  Navigator.pushNamed(context, "set_wallet_name");
                },
              ),
              SizedBox(height: 20,),
              //已有钱包
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "load_wallet");
                },
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("已有钱包",style: TextStyle(fontSize: 14,color:MyColors.BLACK_TEXT_22),),
                      Icon(Icons.keyboard_arrow_right,size: 16,color: MyColors.BLACK_TEXT_22,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 88,),
            ],
          ),
        ),
    );
  }
}
