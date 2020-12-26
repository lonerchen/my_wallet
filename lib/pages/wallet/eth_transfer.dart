

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:youwallet/model/dapp_transaction.dart';
import 'package:youwallet/model/network.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:youwallet/pages/form/getPassword.dart';
import 'package:youwallet/util/http_server.dart';
import 'package:youwallet/util/wallet_crypt.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:http/http.dart' as httpLib;
import 'package:youwallet/model/wallet.dart' as myWallet;
import 'package:hex/hex.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart';

import '../../global.dart';

///
/// 专门用来转账以太坊的页面
///

class EthTransferPage extends StatefulWidget {

  final DappTransaction dappTransaction;

  EthTransferPage(this.dappTransaction);

  @override
  _EthTransferPageState createState() => _EthTransferPageState();
}

class _EthTransferPageState extends State<EthTransferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar(
          ""
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _buildTitle(),
              _buildSelCoin(),
              SizedBox(height: 23,),
              _buildAddressInput(),
              SizedBox(height: 23,),
              _buildNum(),
              SizedBox(height: 130,),
              _buildNextButton(),
              SizedBox(height: 49,),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// 标题
  ///
  Widget _buildTitle(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 19),
      child: Row(
        children: <Widget>[
          Text("转账",style: TextStyle(fontSize: 20,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
          Expanded(child: Container(height: 0,)),
        ],
      ),
    );
  }

  ///
  /// 接收地址输入栏
  ///
  Widget _buildAddressInput(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("接收地址",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.all(15),
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Text(
              widget.dappTransaction.to,
              maxLines: 1,
              style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
//              decoration: InputDecoration(
//                border: InputBorder.none,
//                hintText: "输入或粘贴钱包地址",
//                hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
//              ),
//              controller: ,
            ),
          ),
        ],
      ),
    );
  }


  ///
  /// 选择币种
  ///
  Widget _buildSelCoin(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("选择币种",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
//              if (Provider.of<Token>(context).items.toList().length == 0) {
//                print('当前选项数量为0，不弹出');
//                Global.showSnackBar(context, '请先前往首页添加token');
//              } else {
//              this.selectToken(context);
//              }
            },
            child: Container(
              padding: EdgeInsets.all(15),
              height: 56,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6)
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ETH",
                  maxLines: 1,
                  style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNum(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("数量(wei)",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99,),),
              Expanded(child: Container(height: 0,)),
//              Text("余额：${this.balance ?? "--"} ${name??="--"}",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99,),),
            ],
          ),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.all(15),
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Row(
              children: <Widget>[
                Text(BigInt.parse(widget.dappTransaction.value.split("x")[1],radix: 16).toString(),style: TextStyle(color: MyColors.GRAY_TEXT_99),),

//                GestureDetector(
//                    onTap: (){
//                      _numController.text = "${this.balance ?? "0"}";
//                    },
//                    child: Text("全部 ",style: TextStyle(color: MyColors.THEME_COLORS,fontSize: 12),)
//                ),
//                Text("| ${name ?? "--"}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildNextButton(){
    return BaseButton().getBaseButton(text: "交易", onPressed: ()async{
      Navigator.pushNamed(context, "getPassword",arguments: {"type":"pwd"}).then((pwdObj)async{
        if(pwdObj != null){
          String privateKey = (pwdObj as Map )["privateKey"];
          Network network = Provider.of<Network>(context);

          var httpClient = new Client();
          var ethClient = new Web3Client(network.rpcUrl, httpClient);

          var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
          String gasValue =  widget.dappTransaction.gas.split("x")[1];
          BigInt gas = BigInt.parse(gasValue,radix:16);
          String amountValue =  widget.dappTransaction.value.split("x")[1];
          BigInt amount = BigInt.parse(amountValue,radix:16);
          String hash = await ethClient.sendTransaction(
            credentials,
            Transaction(
              from: EthereumAddress.fromHex(widget.dappTransaction.from),
              to: EthereumAddress.fromHex(widget.dappTransaction.to),
              gasPrice: EtherAmount.inWei(gas),
              maxGas: 1000000,
              value: EtherAmount.fromUnitAndValue(EtherUnit.wei, widget.dappTransaction.value),
            ),
            chainId: network.chainId,
          );
          Navigator.pop(context,hash);
        }
      });

    });
  }

}
