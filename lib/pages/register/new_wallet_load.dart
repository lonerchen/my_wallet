import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:youwallet/pages/register/scan.dart';

//import 'package:stellar_hd_wallet/stellar_hd_wallet.dart';

import 'package:youwallet/service/local_authentication_service.dart';
import 'package:youwallet/service/service_locator.dart';
import 'package:youwallet/service/token_service.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/loadingDialog.dart';
import 'package:youwallet/widgets/customButton.dart';

import 'package:provider/provider.dart';
import 'package:youwallet/model/wallet.dart' as myWallet;

class LoadWallet extends StatefulWidget {
  final arguments;
  String value = "";
  LoadWallet({Key key, this.arguments,this.value}) : super();

  @override
  State<StatefulWidget> createState() => new Page(arguments: this.arguments);
}

class Page extends State<LoadWallet> {
  Page({this.arguments});

  final globalKey = GlobalKey<ScaffoldState>();
  Map arguments;

  @override
  // override是重写父类中的函数 每次初始化的时候执行一次，类似于小程序中的onLoad
  void initState() {
    _mnemonicController.text = widget.value;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    if (this.arguments == null) {
//      print("没有参数");
//    } else {
//      String key = Provider.of<myWallet.Wallet>(context)
//          .exportPrivateKey(this.arguments['address']);
//      print('查询到的key=》${key}');
//      setState(() {
//        this._key.text = key;
//      });
//    }
  }

  //输入控制器
  TextEditingController _mnemonicController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar().getBaseAppBar(
            "导入多币种钱包",
            actions: [
              InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanPage())).then((value){
                      if(value != null){
                        setState(() {
                          _mnemonicController.text = value;
                        });
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: Image.asset("images/icon_scan_action.png",width: 22,height: 22,),
                  )
              ),
            ]
        ),
        body: Container(
          decoration: BoxDecoration(

            image: DecorationImage(
                image:AssetImage("images/icon_register_bg.png",),
                fit: BoxFit.fill
            ),
          ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 28,),
                      Text("助记词",style: TextStyle(fontSize: 18,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
                      SizedBox(height: 20,),
                      Text("请输入助记词或粘贴",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                      SizedBox(height: 15,),
                      _buildInputFrame(),
                      SizedBox(height: 70,),
                      _buildPaste(),
                      SizedBox(height: 80,),
                      _buildInputButton(),
                      SizedBox(height: 24,),
                      _buildWarn(),
                      SizedBox(height: 24,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }

  ///
  /// 输入文本框
  ///
  Widget _buildInputFrame(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(15),
      height: 170,
      decoration: BoxDecoration(
          color: Color.fromARGB(0xff, 0xf5, 0xf5, 0xf5)
      ),
//      child: Expanded(
        child: TextField(
          keyboardType: TextInputType.text,
          maxLines: 6,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          controller: _mnemonicController,
          onEditingComplete: (){
            String mnemonic = _mnemonicController.text ?? "";
            List<String> mnemonicList = mnemonic.split(" ");
            //以空格间隔，取出12个单词或者24个单词，才让他执行导入的方法
            if(mnemonicList.length == 12 || mnemonicList.length == 24){
              loadWalletByMnemonic();
            }else {
              showToast("助记词必须是12或者24个单词，并以空格间隔的字符！");
            }
          },
        ),
//      ),
    );
  }

  ///
  /// 粘贴
  ///
  Widget _buildPaste(){
    return GestureDetector(
      onTap: ()async{
        ClipboardData clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
        setState(() {
          _mnemonicController.text = clipboardData.text;
        });
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/icon_mnemonic_paste.png",width: 20,height: 20,),
            SizedBox(width: 4,),
            Text("粘贴",style: TextStyle(fontSize: 14,color: Color.fromARGB(0xff, 0x1e, 0xd6, 0x9c)),)
          ],
        ),
      ),
    );
  }

  ///
  /// 导入按钮
  ///
  Widget _buildInputButton(){
    return BaseButton().getBaseButton(
        text: "导入",
        width: 300,
        onPressed: (){
          String mnemonic = _mnemonicController.text ?? "";
          List<String> mnemonicList = mnemonic.split(" ");
          //以空格间隔，取出12个单词或者24个单词，才让他执行导入的方法
          if(mnemonicList.length == 12 || mnemonicList.length == 24){
            loadWalletByMnemonic();
          }else {
            showToast("助记词必须是12或者24个单词，并以空格间隔的字符！");
          }
        }
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 5,),
          Image.asset("images/icon_mnemonic_warning.png",width: 18,height: 18,),
          SizedBox(width: 4,),
          Expanded(child: Text("通常时12个（有时是24个）用单个空格分隔的单词",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),)),
        ],
      ),
    );
  }

  // 通过助记词导入
  void loadWalletByMnemonic() async {

    String privateKey = TokenService.getPrivateKey(this._mnemonicController.text);

    Map item = {
      'privateKey': privateKey,
      'mnemonic': this._mnemonicController.text,
    };

    this.doSave(item);
  }


  // 跳转密码设置页面
  void doSave(Map item) {
    Navigator.of(context).pushNamed('password').then((data) {
      print(data);
      if (data == null) {
        print('input nothing');
      } else {
        this.saveDone(item, data);
      }
    });
  }

  /// 保存用户的钱包到本地数据库
  void saveDone(Map item, String pwd) async {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            //调用对话框
            text: '保存钱包...',
          );
        });

    int id;
    try {
      id = await Provider.of<myWallet.Wallet>(context).add(item, pwd);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }

    if (id > 0) {
      Navigator.pushNamedAndRemoveUntil(
          context, "wallet_success", (route) => route == null);
      // 删除路由栈中除了顶级理由之外的路由
      // 然后添加目标页面进入路由，并且跳转

    } else {
      this.showSnackbar('钱包保存失败');
    }
  }

  void showSnackbar(String text) {
    final snackBar = SnackBar(content: Text(text));
    globalKey.currentState.showSnackBar(snackBar);
  }
}
