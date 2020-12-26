

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/model/token.dart';
import 'package:youwallet/model/wallet_center.dart';
import 'package:youwallet/util/number_format.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/tokenList.dart';

import '../../global.dart';

class TokenSelectDialog extends StatefulWidget {
  @override
  _TokenSelectDialogState createState() => _TokenSelectDialogState();
}

class _TokenSelectDialogState extends State<TokenSelectDialog> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WalletCenter>(
        builder: (context,walletCenter,child) => Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("选择币种",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),)
              ),
              SizedBox(height: 15,),
              Expanded(
                child: Container(
                  child: ListView(
                    children: _buildItem(walletCenter),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItem(WalletCenter walletCenter){
    return List.generate(walletCenter.walletCenterTokenList.length, (index){
      return InkWell(
        onTap: ()async{
          await walletCenter.changeWalletCenter(walletCenter.walletCenterTokenList[index].id);
          Navigator.of(context).pop(true);
        },
        child: Container(

          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Image.network(walletCenter.walletCenterTokenList[index].icon,width: 30,),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(walletCenter.walletCenterTokenList[index].name,style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14),),
                  Text(NumberFormat.addressFormat(walletCenter.walletCenterTokenList[index].balance),style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }



}
