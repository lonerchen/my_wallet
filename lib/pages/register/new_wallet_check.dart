
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youwallet/service/token_service.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/model/wallet.dart' as myWallet;
import 'package:youwallet/util/toast.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/loadingDialog.dart';
import 'package:youwallet/widgets/customButton.dart';

class WalletCheck extends StatefulWidget {
  TokenService _tokenService;
  @override
  Page createState()  => Page(this._tokenService);
}

class Page extends State<WalletCheck> {

  Page(this._tokenService);

  //乱序的助记词
  List<String> mnemonicShuffleList;
  //传进来的助记词
  List<String> mnemonicList;
  //助记词字符串
  String mnemonic;

  setRandomMnemonic()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mnemonic = prefs.getString("randomMnemonic");
    mnemonicList = mnemonic.split(" ");
    mnemonicShuffleList = new List();
    mnemonicShuffleList.addAll(mnemonicList);
    mnemonicShuffleList.shuffle();
    setState(() {

    });
  }


  TokenService _tokenService;

  final globalKey = GlobalKey<ScaffoldState>();

  void showSnackbar(String text) {
    final snackBar = SnackBar(content: Text(text));
    globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    setRandomMnemonic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //重新组成正确顺序的列表
  List<String> mnemonicVerifyList = new List();

  //错误提示
  int _isPass = 0;//错误类型 0 = 默认状态 ，1 = 正确 ，2 = 错误

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar().getBaseAppBar("助记词"),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("images/icon_register_bg.png")
              )
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 28,),
                        Text("验证助记词",style: TextStyle(fontSize: 18,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
                        SizedBox(height: 20,),
                        Text("点击单词，把它们按正确地顺序放在一起。",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                        SizedBox(height: 15,),
                        _buildVerifyFrame(),
                        SizedBox(height: 10,),
                        _buildMnemonicList(),
                        _buildErrorHint(),
                        _buildCompleteButton(),
                        SizedBox(height: 16,),
                        _buildWarn(),
                        SizedBox(height: 16,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }

  ///
  /// 验证助记词 框框 上面的部分
  ///
  Widget _buildVerifyFrame(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(15),
      height: 170,
      decoration: BoxDecoration(
          color: Color.fromARGB(0xff, 0xff, 0xf1, 0xd4),
          border: Border.all(
              color: _isPass == 1 ? Color.fromARGB(0xff, 0x1e, 0xd6, 0x9c) : _isPass == 2 ? Color.fromARGB(0xff, 0xff, 0x68, 0x68) : Colors.transparent
          )
      ),
      child: SingleChildScrollView(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Wrap(
            alignment: WrapAlignment.start,
            children: List.generate(mnemonicVerifyList.length, (index){
              return _buildMnemonicVerify(mnemonicVerifyList[index],index);
            }),
          ),
        ),
      ),
    );
  }


  ///
  /// 单个助记词的布局
  ///
  Widget _buildMnemonicVerify(String text,int position) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      onTap: (){
        setState(() {
          mnemonicShuffleList.add(mnemonicVerifyList[position]);
          mnemonicVerifyList.removeAt(position);
          //检查助记词
          _checkMnemonic();
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 4),
        decoration: BoxDecoration(
          color: MyColors.THEME_COLORS,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Text("${position+1}.$text",style: TextStyle(color: Colors.white,fontSize: 14),),
      ),
    );
  }

  ///
  /// 助记词流式布局
  ///
  Widget _buildMnemonicList(){
    return Container(
      height: 170,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(mnemonicShuffleList.length, (index) {
              return _buildMnemonic(mnemonicShuffleList[index],index);
            }),
          ),
        ),
      ),
    );
  }

  ///
  /// 错误文字提示
  ///
  Widget _buildErrorHint(){
    return SizedBox(
      height: 20,
      child: Text(
        _isPass == 1 ? "恭喜您，排放正确，干得漂亮！" : _isPass == 2 ? "*顺序不准确，请重试！" : "",
        style: TextStyle(
            color: _isPass == 1 ? Color.fromARGB(0xff, 0x1e, 0xd6, 0x9c) : _isPass == 2 ? Color.fromARGB(0xff, 0xff, 0x68, 0x68) : Colors.transparent,
            fontSize: 12),
      ),
    );
  }

  ///
  /// 单个助记词的布局
  ///
  Widget _buildMnemonic(String text,int position) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      onTap: (){
        setState(() {
          mnemonicVerifyList.add(mnemonicShuffleList[position]);
          mnemonicShuffleList.removeAt(position);
          //填完判断 成功
          _checkMnemonic();
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 4),
        decoration: BoxDecoration(
          color: MyColors.THEME_COLORS,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Text("$text",style: TextStyle(color: Colors.white,fontSize: 14),),
      ),
    );
  }

  ///
  /// 完成按钮
  ///
  Widget _buildCompleteButton(){
    return BaseButton().getBaseButton(
      text: "完成",
      width: 300,
      onPressed: (){
        if(_isPass == 0){
          showToast("请将助记词按照顺序排列");
        }else if(_isPass == 1){// 助记词和私钥在这里加密
          Navigator.of(context).pushNamed('password').then((data){
            if(data != null) {
              this.saveWallet(data);
            }
          });
        }else if(_isPass == 2){
          showToast("助记词顺序错误");
        }
      },
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

  ///
  /// 判断是否正确
  ///
  _checkMnemonic(){
    //判断添加的有没有错误
    for(int i = 0;i < mnemonicVerifyList.length ;i++){
      if(mnemonicVerifyList[i] != mnemonicList[i]){
        setState(() {
          _isPass = 2;
        });
        return;
      }
    }
    //全部验证完，长度一致，数据一致
    if(mnemonicVerifyList.length == mnemonicList.length) {
      setState(() {
        _isPass = 1;
      });
    }else{//长度不一致恢复默认状态
      setState(() {
        _isPass = 0;
      });
    }
  }





  void saveWallet(String passWord) async {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog( //调用对话框
            text: '保存钱包...',
          );
        });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String randomMnemonic = prefs.getString("randomMnemonic");

    Map obj = {
      'privateKey':  TokenService.getPrivateKey(randomMnemonic),
      'mnemonic': randomMnemonic
    };

    int id = await Provider.of<myWallet.Wallet>(context).add(obj,passWord);
    if(id>0) {
      Navigator.of(context).pushReplacementNamed("wallet_success");
    } else {
      this.showSnackbar('钱包保存失败，请反馈给社区');
    }
  }


}
