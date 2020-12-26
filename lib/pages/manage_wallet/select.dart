

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/base.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {

  //币种列表
  List<Map> coinList = [{"name":"ETH","image":"images/icon_eth.png"}];

  //币种下标
  int coinIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(22),topRight: Radius.circular(22),),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              _buildTitle(),
              SizedBox(height: 20,),
              _buildSelect(),
            ],
          ),
        )
    );
  }

  ///
  ///弹窗标题
  ///
  Widget _buildTitle(){
    return Center(
      child: Text("选择钱包",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 16,fontWeight: FontWeight.w600),),
    );
  }

  ///
  /// 选择的布局
  ///
  Widget _buildSelect(){
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 352,
            color: Color.fromARGB(0xff, 0xec, 0xef, 0xf1),
            child: ListView(
               children: _buildCoinItem(),
            ),
          ),
          Expanded(
            child: Container(
              child: Consumer<Wallet>(
                builder: (context,wallet,child){
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(width: 30,),
                          Text("${coinList[coinIndex]["name"]}",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 16,),),
                          Expanded(child: Container(height: 0,)),
                          InkWell(
                            onTap:(){
                              Navigator.pop(context,"add");
                            },
                            child: Image.asset("images/icon_add.png",width: 24,height: 24,),
                          ),
                          SizedBox(width: 20,),
                        ],
                      ),
//                  Expanded(
                      Container(
                        height: 300,
                        child: ListView(
                          children: wallet.items.length == 0 ? BaseWidget.getEmptyWidget() : _buildAssetsItem(wallet),
                        ),
                      ),
//                  ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  ///
  /// 左边的ListView
  ///
  List<Widget> _buildCoinItem(){
    List<Widget> coinWidgetList = new List();
    for(int i = 0;i < coinList.length;i++){
      coinWidgetList.add(
          InkWell(
            onTap: (){
              setState(() {
                coinIndex = i;
              });
            },
            child: Container(
              width: 64,
              height: 64,
              color: coinIndex == i ? Colors.white : Colors.transparent,
              child: Center(child: Image.asset("${coinList[i]["image"]}",width: 34,height: 34,)),
            ),
          ),
      );
    }
    return coinWidgetList;
  }

  //右边的ListItem
  List<Widget> _buildAssetsItem(Wallet wallet){

    List<Widget> assetsWidgetList = new List();
    for(int i = 0;i<wallet.items.length;i++){
      bool isSel = wallet.currentWalletObject["address"] == wallet.items[i]["address"];
      assetsWidgetList.add(
        InkWell(
          onTap: (){
            wallet.changeWallet(wallet.items[i]["address"]);
          },
          child: Container(
            height: 57,
            width: 281,
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSel ? MyColors.THEME_COLORS : Colors.transparent
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("${wallet.items[i]["name"]}",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14),),
                    Container(
                      width: 152,
                        child: Text(
                          "${wallet.items[i]["address"]}",
                          softWrap:true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
                        ),
                    ),
                  ],
                ),
                Expanded(child: Container(height: 0,)),
                Visibility(
                    visible: isSel,
                    child: Image.asset("images/icon_wallet_sel.png",height: 15,width: 15,)
                ),
              ],
            ),
          ),
        )
      );
    }
    return assetsWidgetList;
  }

}
