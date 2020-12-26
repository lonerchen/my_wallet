import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/model/wallet_center.dart';
import 'package:youwallet/pages/mine/address.dart';
import 'package:youwallet/pages/mine/center_address.dart';
import 'package:youwallet/pages/token/token_select.dart';
import 'package:youwallet/service/token_service.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/bottomSheetDialog.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/customStepper.dart';
import 'package:youwallet/widgets/modalDialog.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:youwallet/model/token.dart';
import 'package:youwallet/model/book.dart';
import 'package:youwallet/service/trade.dart';
import 'package:youwallet/bus.dart';
import 'package:youwallet/db/sql_util.dart';
import 'package:youwallet/widgets/customButton.dart';
import 'package:youwallet/widgets/tokenSelectSheet.dart';
import 'package:youwallet/widgets/loadingDialog.dart';
import 'package:youwallet/global.dart';
import 'package:decimal/decimal.dart';
import 'package:youwallet/widgets/inputDialog.dart';

class CenterTransfer extends StatefulWidget {

  String inputAddress = "";

  CenterTransfer({this.inputAddress});

  @override
  State<StatefulWidget> createState() {
    return new Page();
  }
}

class Page extends State<CenterTransfer> {

  final globalKey = GlobalKey<ScaffoldState>();
  var value;
  static String defaultToAddress = '';

  // 定义TextEditingController()接收收款地址的输入值
  TextEditingController _addressController = new TextEditingController();
  // 定义TextEditingController()余额的输入值
  TextEditingController _numController = new TextEditingController();


  // 定义TextEditingController()，接收联系人备注
  TextEditingController _addressRemarkInput;

  //数据初始化
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text:widget.inputAddress);
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  double slider = 1.0;
  Widget layout(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      appBar: BaseAppBar().getBaseAppBar(""),
      body: SingleChildScrollView(
        child: Consumer<WalletCenter>(
          builder: (context,walletCenter,child) => Container(
            child: Column(
              children: <Widget>[
                _buildTitle(),
                _buildSelCoin(walletCenter),
                SizedBox(height: 23,),
                _buildAddressInput(),
                SizedBox(height: 23,),
                _buildNum(walletCenter),
                SizedBox(height: 130,),
                _buildNextButton(),
                SizedBox(height: 49,),
              ],
            ),
          ),
        ),
      )
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
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return CenterAddressPage(false);
                  }
              )).then((value){
                if(value != null){
                  _addressController.text = value;
                  setState(() {

                  });
                }
              });
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  Text("地址本",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                  SizedBox(width: 5,),
                  Image.asset("images/icon_address_book.png",width: 24,height: 23,),
                ],
              ),
            ),
          ),
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
            child: TextField(
              maxLines: 1,
              style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "输入或粘贴钱包地址",
                hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
              ),
              controller: _addressController,
            ),
          ),
        ],
      ),
    );
  }


  ///
  /// 选择币种
  ///
  Widget _buildSelCoin(WalletCenter walletCenter ){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("选择币种",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
              showModalBottomSheet(context: context, builder: (context){
                return TokenSelectDialog();
              });
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
                  walletCenter.currentWalletCenter.name,
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

  Widget _buildNum(WalletCenter walletCenter){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("数量",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99,),),
              Expanded(child: Container(height: 0,)),
              Text("余额：${walletCenter.currentWalletCenter.balance ?? "--"} ${walletCenter.currentWalletCenter.name??"--"}",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99,),),
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
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "输入数量",
                      hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
                    ),
//                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                    ],
                    controller: _numController,
                  ),
                ),
                GestureDetector(
                    onTap: (){
                      _numController.text = "${walletCenter.currentWalletCenter.balance ?? "0"}";
                    },
                    child: Text("全部 ",style: TextStyle(color: MyColors.THEME_COLORS,fontSize: 12),)
                ),
                Text("| ${walletCenter.currentWalletCenter.name ?? "--"}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildNextButton(){
    return BaseButton().getBaseButton(text: "下一步", onPressed: (){
//      Navigator.push(context, MaterialPageRoute(builder: (context){
//        return TransferCheckPage(Ethereum());
//      }));
      checkInput();
    });
  }

  void checkInput() {

    // 对转账金额做数字校验
    try {
      if (Decimal.parse(this._numController.text) <= Decimal.parse('0')) {
        this.showSnackbar('金额必须大于0');
        return;
      }
      List strs = this._numController.text.split('.');
      if (strs.length == 2) {
        if (strs[1].length > Global.priceDecimal) {
          this.showSnackbar(
              '价格小数最多${Global.priceDecimal}位，你输入了${strs[1].length}位');
          return;
        }
      }
    } catch (e) {
      print(e);
      this.showSnackbar('你输入的金额无法识别');
      return;
    }

    if (this._addressController.text == '') {
      this.showSnackbar('请输入收款地址');
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GenderChooseDialog(
              title: '确认付款?',
              content: '',
              onCancelChooseEvent: () {
                Navigator.of(context).pop();
                // 关闭键盘
                FocusScope.of(context).requestFocus(FocusNode());
                this.showSnackbar('取消转账');
              },
              onSuccessChooseEvent: () {
                Navigator.of(context).pop('confirm');
                // 关闭键盘
                FocusScope.of(context).requestFocus(FocusNode());
              });
        }).then((val) async{
      print(val);
      if (val == 'confirm') {
        WalletCenter walletCenter = Provider.of<WalletCenter>(context);
        await walletCenter.transfer(walletCenter.currentWalletCenter.address,_addressController.text,double.parse(_numController.text),walletCenter.currentWalletCenter.coinId);
      }
    });
  }


  // 显示提示
  void showSnackbar(String text) {
    final snackBar = SnackBar(content: Text(text));
    globalKey.currentState.showSnackBar(snackBar);
  }


}