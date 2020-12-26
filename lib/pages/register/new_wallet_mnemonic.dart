
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youwallet/service/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youwallet/util/toast.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/customButton.dart';

import 'new_wallet_code.dart';

class WalletMnemonic extends StatefulWidget {
  final arguments;

  WalletMnemonic({Key key ,this.arguments}) : super(key: key);

  @override
  Page createState()  => Page();
}

class Page extends State<WalletMnemonic> {

  TextEditingController _name = TextEditingController();
  //助记词字符串
  String mnemonic = "";

  //助记词
  List<String> mnemonicList = ["used","any","brief","address","much","flee","slush","destory","maple","evolve","journey","truly"];

  //是否显示警告
  bool _isWarn = false;

  @override
  void initState() {
    super.initState();
    if (widget.arguments == null) {
      mnemonic = TokenService.generateMnemonic();
    } else {
      mnemonic = widget.arguments['mnemonic'];
    }
    setState(() {
      this._name.text = mnemonic;
      this.mnemonicList = mnemonic.split(" ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar("助记词"),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/icon_register_bg.png",),fit: BoxFit.fill)
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 42),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 28,),
                      Center(
                        child: Text("您的助记词",style: TextStyle(fontSize: 18,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
                      ),
                      SizedBox(height: 20,),
                      Center(
                        child: Text(
                          "按正确地顺序记下或复制这些单词，\n并将它们保存在安全的地方。",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),
                        ),
                      ),
                      SizedBox(height: 45,),
                      _buildMnemonicList(),
                      SizedBox(height: 55,),
                      _buildCopyAndQrCode(),
                      SizedBox(height: 117,),
                      _buildNextButton(),
                      SizedBox(height: 20,),
                      _buildWarn(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// 助记词流式布局
  ///
  Widget _buildMnemonicList(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(mnemonicList.length, (index) {
          return _buildMnemonic(mnemonicList[index],index);
        }),
      ),
    );
  }

  ///
  /// 单个助记词的布局
  ///
  Widget _buildMnemonic(String text,int position) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 4),
      decoration: BoxDecoration(
        color: Color.fromARGB(0xff, 0xf5, 0xf5, 0xf5),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Text("${position+1}.$text",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14),),
    );
  }

  ///
  /// 复制跟显示二维码
  ///
  Widget _buildCopyAndQrCode(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Clipboard.setData(ClipboardData(text: mnemonic));
            //显示拷贝成功toast
            ToastUtils.showCopyOk();
            //显示风险警告
            setState(() {
              _isWarn = true;
            });
          },
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset("images/icon_mnemonic_copy.png",width: 20,height: 20,),
                SizedBox(width: 4,),
                Text("复制",style: TextStyle(fontSize:14,color: Color.fromARGB(0xff, 0x1e, 0xd6, 0x9c)),),
              ],
            ),
          ),
        ),
        SizedBox(width: 64,),
        GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context){
                      return MnemonicQrCodePage(mnemonic);
                    }
                )
            );
          },
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset("images/icon_mnemonic_qrcode.png",width: 20,height: 20,),
                SizedBox(width: 4,),
                Text("显示二维码",style: TextStyle(fontSize:14,color: Color.fromARGB(0xff, 0x1e, 0xd6, 0x9c)),),
              ],
            ),
          ),
        ),

      ],
    );
  }

  ///
  /// 继续按钮
  ///
  Widget _buildNextButton(){
    return BaseButton().getBaseButton(
        text: "继续",
        width: 300,
        onPressed: ()async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("randomMnemonic", this.mnemonic );
          Navigator.of(context).pushReplacementNamed("wallet_check");
        });
  }

  ///
  /// 提示警告
  ///
  Widget _buildWarn(){
    return Visibility(
      visible: _isWarn,
      child: Container(
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
      ),
    );
  }


}
