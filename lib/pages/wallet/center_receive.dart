import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:provider/provider.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:youwallet/model/wallet_center.dart';
import 'package:youwallet/service/token_service.dart';
import 'package:youwallet/util/toast.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';

class CenterReceive extends StatefulWidget {

  CenterReceive();

  @override
  State<StatefulWidget> createState() {

    return new Page();
  }
}

// 收款tab页
class Page extends State<CenterReceive> {
  @override // override是重写父类中的函数
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }


  Widget _buildContent(){
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar(""),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 19,),
              Padding(
                padding: const EdgeInsets.only(left:15.0),
                child: Text("收款",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 19,),
              Container(
                height: 397,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/icon_receive_bg.png"),
                        fit: BoxFit.fill
                    )
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("扫二维码,转入(${Provider.of<WalletCenter>(context).currentWalletCenter.name})"),
                      SizedBox(height: 15,),
                      QrImage(data: Provider.of<WalletCenter>(context).currentWalletCenter.address,size: 230,padding: EdgeInsets.all(0),),
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("钱包地址:",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
                          Text(TokenService.maskAddress(
                              Provider.of<WalletCenter>(context).currentWalletCenter.address),style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 81,),
              Center(
                child: BaseButton().getBaseButton(text: "复制",img:"images/icon_btn_copy.png" ,width:315,onPressed: (){
                  Clipboard.setData(ClipboardData(text: Provider.of<WalletCenter>(context).currentWalletCenter.address));
                  ToastUtils.showCopyOk();
                }),
              ),
              SizedBox(height: 60,),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      title: const Text('收款'),
      automaticallyImplyLeading: false, //设置没有返回按
      elevation: 0.0,
//      actions: this.appBarActions(),
    );
  }

  // 定义bar右侧的icon按钮
  appBarActions() {
    return <Widget>[
      new Container(
        width: 50.0,
        child: new IconButton(
          icon: new Icon(Icons.share),
          onPressed: () {
            Share.share('');
          },
        ),
      )
    ];
  }

  void _copyAddress() {
    ClipboardData data =
        new ClipboardData(text: Provider.of<WalletCenter>(context).currentWalletCenter.address);
    Clipboard.setData(data);
    final snackBar = new SnackBar(content: new Text('复制成功'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

//  Widget header(BuildContext context) {
//    return new Image.network(
//      'http://i2.yeyou.itc.cn/2014/huoying/hd_20140925/hyimage06.jpg',
//
//    );
//  }
}
