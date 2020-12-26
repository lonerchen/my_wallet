import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';

class MnemonicQrCodePage extends StatefulWidget {

  final String mnemonic;

  MnemonicQrCodePage(this.mnemonic);

  @override
  _MnemonicQrCodePageState createState() => _MnemonicQrCodePageState();

}

class _MnemonicQrCodePageState extends State<MnemonicQrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar("二维码"),
      body: Container(
        child: Stack(
          children: <Widget>[
            //背景
            Image.asset("images/icon_register_bg.png",fit: BoxFit.fill,),

            //中间的卡片
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 42),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        QrImage(data: widget.mnemonic,size: 154,),
                        SizedBox(height: 15,),
                        Text("这个二维码包含你的助记词",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
                        SizedBox(height: 128,),
                        _buildWarn(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// 提示警告
  ///
  Widget _buildWarn(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(0xff, 0xf5, 0xf5, 0xf5),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("images/icon_mnemonic_warning.png",width: 18,height: 18,),
          SizedBox(width: 4,),
          Text("切勿向任何人分享助记词，安全地存储它！",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
        ],
      ),
    );
  }

}
