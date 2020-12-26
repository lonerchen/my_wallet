import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/model/token.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:youwallet/pages/register/new_wallet_load.dart';
import 'package:youwallet/pages/register/scan.dart';
import 'package:youwallet/pages/token/token_add.dart';
import 'package:youwallet/pages/token/token_details.dart';
import 'package:youwallet/pages/wallet/un_center_receive.dart';
import 'package:youwallet/pages/wallet/un_center_transfer.dart';
import 'package:youwallet/util/format.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/base.dart';

///
/// 去中心化钱包
/// 

class DecentralizationPage extends StatefulWidget {

  Map coin;

  DecentralizationPage(Key key,this.coin):super(key: key);

  @override
  DecentralizationPageState createState() => DecentralizationPageState();
}

class DecentralizationPageState extends State<DecentralizationPage> {

  List<Map> assetsList = List();

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            _buildBalance(),
            _buildTools(),
            SizedBox(height: 23,),
            _buildAssetsList(),
          ],
        ),
      );
  }

  //余额
  Widget _buildBalance(){
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          var wallet = Provider.of<Wallet>(context).currentWalletObject;
          return TokenDetailsPage(
              wallet
          );
        }));
      },
      child: Container(
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
          child: Consumer<Wallet>(
            builder: (context,wallet,child){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("我的资产（ETH）",style: TextStyle(fontSize:19,color: Colors.white),),
                  Text("${wallet.currentWalletObject["balance"]}",style: TextStyle(fontSize:30,color: Colors.white),)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  //工具块
  Widget _buildTools(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context){
                        return TabTransfer();
                      }
                  )
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
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context){
                    return TabReceive();
                  }
                )
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
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context){
                      return ScanPage();
                    }
                ),
              ).then((value) {
                if(value != null) {
                  _checkQrcode(value);
                }
              });
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Image.asset("images/icon_uncenter_scan.png",width: 79,height: 79,),
                  Text("扫一扫",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_1F),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )
      ),
      child: Consumer<Token>(
        builder: (context,token,child){
          return Column(
            children: <Widget>[
              SizedBox(height: 18,),
              Row(
                children: <Widget>[
                  SizedBox(width: 15,),
                  Text("资产列表",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
                  Expanded(child: Container(height: 0,)),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, "add_token", arguments: {});
                    },
                    child: Image.asset("images/icon_add.png",width: 32,height: 32,),
                  ),
                  SizedBox(width: 15,),
                ],
              ),
              SizedBox(height: 18,),
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: token.items.length == 0
                    ? BaseWidget.getEmptyWidget()
                    : _buildItem(token.items.length),
              ),
              SizedBox(height: 50,),
            ],
          );
        },
      ),
    );
  }

  //资产列表
  _buildItem(int length){
    return List.generate(length, (index){
      return Consumer<Token>(
        builder: (context,token,child){
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TokenDetailsPage(token.items[index])));
            },
            child: Container(
              width: 345,
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color.fromARGB(0xff, 0xf2, 0xf2, 0xf2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset("images/icon_eth.png",width: 28,height: 28,),
                  SizedBox(width: 7,),
                  Text(token.items[index]["name"],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,),),
                  Expanded(child: Container(height: 0,),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(token.items[index]["balance"],style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14),),
                      Text("≈ ¥" + token.items[index]["rmb"],style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }

  showWalletManageDialog(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Container(
                    height: 30,
                    color: Colors.white,
                    child: Center(
                      child: Text("创建钱包",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 16),),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  //添加钱包的操作
  _checkQrcode(String value){
    if(value ==null){
      return;
    }
    //扫码助记词
    List<String> mnemonicList = value.split(" ");
    //以空格间隔，取出12个单词或者24个单词，才让他执行导入的方法
    if(mnemonicList.length == 12 || mnemonicList.length == 24){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context){
              return LoadWallet(value: value,);
            }
        ),
      );
    }else if(value.startsWith("0x") && value.length == 42){
      Global.setToAddress(value);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context){
              return TabTransfer(inputAddress: value,);
            }
        ),
      );
    }else{
      showToast("请扫描助记词或转账二维码！");
    }
  }

  //数据库中读取钱包
  initData()async{
//    assetsList = await SQLiteManager.getInstance().queryCoinList(MyApp.mnemonic);
    setState(() {

    });
  }


}
