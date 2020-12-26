

import 'package:flutter/material.dart';
import 'package:youwallet/db/sql_util.dart';
import 'package:youwallet/model/book.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';

import 'add_address.dart';

///
/// 去中心化钱包地址本
///
class UnCenterAddressPage extends StatefulWidget {

  //标记当前是否选择，还是编辑
  bool isEdit = false;

  @override
  _UnCenterAddressPageState createState() => _UnCenterAddressPageState();
}

class _UnCenterAddressPageState extends State<UnCenterAddressPage> {

  List<Map> listBook = new List();

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
      body: Container(
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
                      builder: (context) => AddAddressPage()
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
                    children: listBook.length == 0
                        ? BaseWidget.getEmptyWidget()
                        : _buildItem(),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItem(){
    return List.generate(listBook.length, (index){
      return InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: (){
          if(widget.isEdit){

//            Navigator.push(context, MaterialPageRoute(
//              builder: (context){
//                return EditAddressPage(coin: listBook[index],);
//              }
//            )).then((value){
//              _initData();
//            });
          }else {
            Navigator.pop(context,listBook[index]["address"]);
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
              Image.asset("images/icon_eth.png",width: 34,height:34,),
              SizedBox(width: 16,),
              Container(
                width:152,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("ETH",style: TextStyle(fontSize: 14,color:MyColors.BLACK_TEXT_22,fontWeight:FontWeight.w600),),
                    Text("${listBook[index]["address"]}",maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 12,color:MyColors.GRAY_TEXT_99,),),
                  ],
                ),
              ),
              Expanded(child: Container(height: 0,),),
              Text("${listBook[index]["remark"] ?? ""}",style: TextStyle(fontSize: 12,color:MyColors.GRAY_TEXT_99,)),
              Icon(Icons.keyboard_arrow_right,size: 20,color: MyColors.GRAY_TEXT_99,),
            ],
          ),
        ),
      );
    });
  }

  _initData()async{
    Book book = new Book();
    await book.getBookList();
    listBook = book.items;
    setState(() {

    });
  }

}
