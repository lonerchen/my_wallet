

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/db/sql_util.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/model/address_book.dart';
import 'package:youwallet/model/book.dart';
import 'package:youwallet/model/wallet_center.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';

import 'add_address.dart';
import 'center_add_address.dart';
import 'center_edit_address.dart';

///
/// 中心化钱包地址本
///
class CenterAddressPage extends StatefulWidget {

  //标记当前是否选择，还是编辑
  bool isEdit = false;

  CenterAddressPage(this.isEdit);

  @override
  _CenterAddressPageState createState() => _CenterAddressPageState();
}

class _CenterAddressPageState extends State<CenterAddressPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar(""),
      body: Consumer2<AddressBook,WalletCenter>(
        builder: (context,addressBook,walletCenter,child) => Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 19,),
              Row(
                children: <Widget>[
                  Text("地址本",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
                  Expanded(child: Container(height: 0,)),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AddCenterAddressPage()
                      )).then((value) {
                        if(value != null && value){
                          _initData();
                        }
                      });
                    },
                      child: Image.asset("images/icon_add.png",width: 24,height: 24,),
                  ),
                ],
              ),
              SizedBox(height: 22,),
              Expanded(
                  child: Container(
                    child: ListView(
                      children: addressBook.addressList.length == 0
                          ? BaseWidget.getEmptyWidget()
                          : _buildItem(addressBook,walletCenter),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItem(AddressBook addressBook,WalletCenter walletCenter){
    return List.generate(addressBook.addressList.length, (index){
      return InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: (){
          if(widget.isEdit){

            Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return EditAddressPage(addressBook.addressList[index]);
              }
            )).then((value){
              _initData();
            });
          }else {
            Navigator.pop(context,addressBook.addressList[index].address);
          }
        },
        child: Container(
          height:56,
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              walletCenter.getCoin(addressBook.addressList[index].bridge_id) == null ? Image.asset("images/icon_eth.png",width: 34,height:34,) : Image.network(walletCenter.getCoin(addressBook.addressList[index].bridge_id).icon,width: 34,height:34,),
              SizedBox(width: 16,),
              Container(
                width:152,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(walletCenter.getCoin(addressBook.addressList[index].bridge_id) == null ? "ETH" :walletCenter.getCoin(addressBook.addressList[index].bridge_id).name,style: TextStyle(fontSize: 14,color:MyColors.BLACK_TEXT_22,fontWeight:FontWeight.w600),),
                    Text("${addressBook.addressList[index].address}",maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 12,color:MyColors.GRAY_TEXT_99,),),
                  ],
                ),
              ),
              Expanded(child: Container(height: 0,),),
              Text("${addressBook.addressList[index].description ?? ""}",style: TextStyle(fontSize: 12,color:MyColors.GRAY_TEXT_99,)),
              Icon(Icons.keyboard_arrow_right,size: 20,color: MyColors.GRAY_TEXT_99,),
            ],
          ),
        ),
      );
    });
  }

  _initData()async{
    await Provider.of<AddressBook>(Global.context).getAddressList();
  }

}
