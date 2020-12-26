import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youwallet/model/wallet_center.dart';
import 'package:youwallet/pages/nuclear/pledge.dart';
import 'package:youwallet/util/format.dart';
import 'package:youwallet/value/colors.dart';

import 'center_receive.dart';
import 'center_transfer.dart';

///
/// 中心化钱包
///
class CentralizationPage extends StatefulWidget {
  @override
  _CentralizationPageState createState() => _CentralizationPageState();
}

class _CentralizationPageState extends State<CentralizationPage> {

  RefreshController refreshController = new RefreshController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletCenter>(
      builder: (context,walletCenter,child) => SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        header: ClassicHeader(),
        onRefresh: ()async{
          await walletCenter.getWalletCenter();
          refreshController.refreshCompleted();
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                _buildBalance(walletCenter.currentWalletCenter),
                _buildTools(walletCenter.currentWalletCenter),
                SizedBox(height: 23,),
                _buildAssetsList(walletCenter.walletCenterTokenList),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //余额
  Widget _buildBalance(WalletCenterDetails walletCenterDetails){
    return Container(
      height: 177,
      padding: EdgeInsets.symmetric(horizontal: 32),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/icon_wallet_balance_bg.png",),
            fit: BoxFit.fitWidth
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("我的资产（${walletCenterDetails?.name ?? ""}）",style: TextStyle(fontSize:19,color: Colors.white),),
            Text("${walletCenterDetails?.balance ?? ""}",style: TextStyle(fontSize:30,color: Colors.white),)
          ],
        ),
      ),
    );
  }

  //工具块
  Widget _buildTools(WalletCenterDetails walletCenterDetails){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context){
                  return  CenterTransfer();
                })
              );
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("images/icon_uncenter_transfer.png",width: 79,height: 79,),
                  Text("转账",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_1F),),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context){
                  return CenterReceive();
                })
              );
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("images/icon_uncenter_receive.png",width: 79,height: 79,),
                  Text("收款",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_1F),),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){
                    return PledgeCoinPage();
                  })
              );

            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("images/icon_center_pledge.png",width: 79,height: 79,),
                  Text("质押",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_1F),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList(List<WalletCenterToken> listToken){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 18,),
          Row(
            children: <Widget>[
              SizedBox(width: 15,),
              Text("资产列表",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
              Expanded(child: Container(height: 0,)),
              SizedBox(width: 15,),
            ],
          ),
          SizedBox(height: 18,),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(listToken.length, (index){
              return Container(
                width: 345,
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: Color.fromARGB(0xff, 0xf2, 0xf2, 0xf2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.network(listToken[index].icon,width: 28,height: 28,),
                    SizedBox(width: 7,),
                    Text(listToken[index].name,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,),),
                    Expanded(child: Container(height: 0,),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(listToken[index].balance,style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14),),
                        Text("≈ ¥ --",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
                      ],
                    )
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 50,),
        ],
      ),
    );
  }

}
class CoinAssets{

  Map coin;
  double num;
  double about;

  CoinAssets(this.coin, this.num, this.about);
}