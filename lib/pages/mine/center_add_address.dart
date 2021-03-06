
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/model/address_book.dart';
import 'package:youwallet/model/book.dart';
import 'package:youwallet/model/wallet_center.dart';
import 'package:youwallet/pages/register/scan.dart';
import 'package:youwallet/pages/token/token_select.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/button.dart';

///
/// 添加/新建地址
///
class AddCenterAddressPage extends StatefulWidget {

  String address;
  AddressInfo addressInfo;

  @override
  _AddCenterAddressPageState createState() => _AddCenterAddressPageState();

  AddCenterAddressPage({this.address = "",this.addressInfo});

}

class _AddCenterAddressPageState extends State<AddCenterAddressPage>{


  //输入控制器
  TextEditingController _addressController;
  TextEditingController _nameController;
  TextEditingController _remarkController;

  //币种类型列表
//  List<Coin> listCoin = [Ethereum(),BitCoin()];

  int coinIndex = 0;

  @override
  void initState() {
    super.initState();
    _addressController = new TextEditingController(text:widget.address);
    if(widget.addressInfo != null){
      _nameController = new TextEditingController(text:widget.addressInfo.address);
      _remarkController = new TextEditingController(text:widget.addressInfo.description);
    }else{
      _nameController = new TextEditingController();
      _remarkController = new TextEditingController();
    }

  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
    _nameController.dispose();
    _remarkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar(""),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 19,),
              _buildTitle(),
              SizedBox(height: 26,),
              _buildAddressInput(),
              SizedBox(height: 23,),
//              _buildName(),
//              SizedBox(height: 23,),
              _buildRemark(),
              SizedBox(height: 235,),
              _buildSaveButton(),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// 标题栏
  ///
  Widget _buildTitle(){
    return Consumer<WalletCenter>(
      builder: (context,walletCenter,child) =>Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 15,),
            Text("选择币种",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
            Expanded(child: Container(height: 0,),),
            InkWell(
              onTap: (){
                showModalBottomSheet(context: context, builder: (context){
                  return TokenSelectDialog();
                });
              },
              child: Container(
                height: 39,
                width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(19.5)),
                    color: Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 39,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 13,),
                            Image.network(walletCenter.currentWalletCenter.icon,width: 24,height: 24,),
                            SizedBox(width: 10,),
                            Text(walletCenter.currentWalletCenter.name,style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                            SizedBox(width: 24,),
                            Image.asset("images/icon_coin_sel.png",width: 22,height: 22,),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 15,),
          ],
        ),
      ),
    );
  }

  ///
  /// 添加地址输入栏
  ///
  Widget _buildAddressInput(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("添加地址",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
              Expanded(child: Container(height: 0,)),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanPage())
                  ).then((value){
                    if(value != null){
                      setState(() {
                        _addressController.text = value;
                      });
                    }
                  });
                },
                child: Image.asset("images/icon_scan_theme.png",width: 18,height: 18,)
              ),
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
            child: TextField(
              maxLines: 1,
              onChanged: onChange,
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
  /// 输入钱包名称
  ///
//  Widget _buildName(){
//    return Container(
//      margin: EdgeInsets.symmetric(horizontal: 15),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Text("名称",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
//          SizedBox(height: 15,),
//          Container(
//            padding: EdgeInsets.all(15),
//            height: 56,
//            decoration: BoxDecoration(
//                color: Colors.white,
//                borderRadius: BorderRadius.circular(6)
//            ),
//            child: Expanded(
//              child: TextField(
//                maxLines: 1,
//                onChanged: onChange,
//                style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
//                decoration: InputDecoration(
//                  border: InputBorder.none,
//                  hintText: "请输入名称",
//                  hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
//                ),
//                controller: _nameController,
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  ///
  /// 输入钱包备注
  ///
  Widget _buildRemark(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("输入地址备注",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
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
              onChanged: onChange,
              style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "必填",
                hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
              ),
              controller: _remarkController,
            ),
          ),
        ],
      ),
    );
  }

  //监听输入的变化
  onChange(value){
    setState(() {

    });
  }

  ///
  /// 保存按钮
  ///
  Widget _buildSaveButton(){
    //判断是否可以点击按钮
    bool isPass = _addressController.text.isNotEmpty && _remarkController.text.isNotEmpty;

    return BaseButton().getBaseButton(text: isPass ? "保存" : "请填写信息", onPressed: isPass ? ()async{
      AddressBook addressBook = Provider.of<AddressBook>(context);
      WalletCenter walletCenter = Provider.of<WalletCenter>(context);
      await addressBook.addAddressBook(
          address:_addressController.text,
          bridge_id:walletCenter.currentWalletCenter.coinId,
          description :_remarkController.text
      );
//      Coin coin = listCoin[coinIndex];
//      coin.address = _addressController.text;
//      coin.alias = _nameController.text;
//      coin.remark = _remarkController.text;
//      await SQLiteManager.getInstance().insertCoinList(MyApp.mnemonic, [coin],tabName: SQLiteManager.WALLET_ADDRESS_TABLE);
      showToast("添加地址成功");
      Navigator.pop(context,true);
    } : null);
  }

}
