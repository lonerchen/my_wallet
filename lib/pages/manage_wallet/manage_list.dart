import 'package:flutter/material.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';

class ManageWallet extends StatefulWidget {
  final arguments;

  ManageWallet({Key key ,this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return new Page();
  }
}

class Page extends State<ManageWallet> {

  List wallets = [];
  String currentAddress = "";

  @override // override是重写父类中的函数
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar:BaseAppBar().getBaseAppBar("钱包管理"),
      body: new Container(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<Wallet>(
          builder: (context, Wallet, child) {
            return new ListView(
              children: Wallet.items.length > 0 ? Wallet.items.map((item) => walletCard(item)).toList() : BaseWidget.getEmptyWidget()
            );
          },
        ),
//        child: new ListView(
//          children: this.wallets.map((item) => walletCard(item)).toList()
//        ),
      ),
    );
  }


  // 定义bar右侧的icon按钮
  appBarActions() {
    return <Widget>[
      new Container(
        width: 50.0,
        child: new IconButton(
          icon: new Icon(Icons.add_circle_outline ),
          onPressed: () {
            Navigator.pushNamed(context, "wallet_guide");
          },
        ),
      )
    ];
  }


  Widget walletCard(item) {
    print(item);
    String name = item['name'].length > 0 ? item['name']:'Wallet${item['id']}';
    return new Card(
        color: Colors.white, //背景色
        child: new Container(
              padding: const EdgeInsets.all(18.0),
              child: new Row(
                children: <Widget>[
                  Image.asset("images/icon_eth.png",width: 30,height: 30,),
                  SizedBox(width: 8,),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          name,
                          style: new TextStyle(fontSize: 15.0, color: MyColors.BLACK_TEXT_22),
                        ),

                        new Text(
                          Global.maskAddress(item['address']),
                          style:TextStyle(fontSize: 12.0, color: MyColors.GRAY_TEXT_99)
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    child: new IconButton(
                      icon: new Icon(Icons.settings,color: MyColors.THEME_COLORS,),
                      onPressed: () {
                        print(item);
                        Navigator.pushNamed(context, "wallet_export",arguments:{
                          'address': item['address'],
                        });
                      },
                    ),

                )
                ],
              )
        )
    );


  }
}
