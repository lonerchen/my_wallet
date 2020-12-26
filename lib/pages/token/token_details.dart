

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/db/sql_util.dart';
import 'package:youwallet/model/deal.dart';
import 'package:youwallet/pages/token/translate_details.dart';
import 'package:youwallet/pages/wallet/un_center_receive.dart';
import 'package:youwallet/pages/wallet/un_center_transfer.dart';
import 'package:youwallet/util/format.dart';
import 'package:youwallet/util/number_format.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';
import 'package:youwallet/widgets/button.dart';


class TokenDetailsPage extends StatefulWidget {

  final Map token;

  TokenDetailsPage(this.token);

  @override
  _TokenDetailsPageState createState() => _TokenDetailsPageState();
}

class _TokenDetailsPageState extends State<TokenDetailsPage> {

  List<Map> translateList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,(){
      _getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar(widget.token["name"]),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _buildInfo(),
              SizedBox(height: 20,),
              _buildHistory(),
              SizedBox(height: 30,),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(left: 15,right: 15,top: 15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Text("基本信息",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
              Expanded(child: Container(height: 0,)),
              Image.asset("images/icon_eth.png",height: 26,width: 26,),
              SizedBox(width: 9,),
              Text(widget.token["name"],style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize:16,fontWeight: FontWeight.w600),)
            ],
          ),
          SizedBox(height: 20,),

          Row(
            children: [
              Text("官网:",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
              Expanded(child: Container(height: 0,)),
              Text(widget.token["website"]??"--",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize:12,fontWeight: FontWeight.w600),)
            ],
          ),
          SizedBox(height: 20,),

          Row(
            children: [
              Text("合约地址:",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
              Expanded(child: Container(height: 0,)),
              InkWell(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: widget.token["address"]??""));
                  showToast("合约地址拷贝成功");
                },
                child: Text(NumberFormat.addressFormat(widget.token["address"])??"--",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize:12,fontWeight: FontWeight.w600),),
              )
            ],
          ),
          SizedBox(height: 20,),

          Row(
            children: [
              Text("社区:",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
              Expanded(child: Container(height: 0,)),
              Image.asset("images/icon_eth.png",height: 20,width: 20,),
            ],
          ),
          SizedBox(height: 20,),

          Row(
            children: [
              Text("发行状态:",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
              Expanded(child: Container(height: 0,)),
              Text("流通中",style: TextStyle(color: Color.fromARGB(0xff, 0xfe, 0xb6, 0x20),fontSize:12,fontWeight: FontWeight.w600),)
            ],
          ),
          SizedBox(height: 24,),
        ],
      ),
    );
  }

  Widget _buildHistory(){
    return
//      Consumer<Deal>(
//      builder: (context,deal,child) =>
          Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(left: 15,right: 15,top: 15),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 14,),
            Row(
              children: [
                Text("交易记录",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
                Expanded(child: Container(height: 0,)),
                Text("全部",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize:12,fontWeight: FontWeight.w600),),
                Icon(Icons.keyboard_arrow_down,size: 20,color: MyColors.GRAY_TEXT_99,),
              ],
            ),
            SizedBox(height: 20,),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: translateList.length > 0 ? buildItem() : BaseWidget.getEmptyWidget(),
            ),
            SizedBox(height: 25,),
          ]
        )
      );
//    );
  }

  List<Widget> buildItem(){
    return List.generate(translateList.length, (index){
      return InkWell(
        onTap: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context){
              return TranslateDetailsPage(translateList[index]);
            })
          );
        },
        child: Container(
          child: Row(
            children: [
              SizedBox(height: 25,),
              Image.asset(translateList[index]["hash"] == null ? "images/icon_deal_failure.png" : 'images/icon_deal_out.png',width: 40,height: 40,),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(translateList[index]["hash"] == null ? "失败":"转出",style: TextStyle(color:MyColors.BLACK_TEXT_22,fontSize: 12),),
                  Text(NumberFormat.addressFormat(translateList[index]["hash"],start: 5,end: 7),style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                ],
              ),
              Expanded(child: Container(height: 0,)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(" - ${translateList[index]["num"]}",style: TextStyle(fontSize: 12,color: Colors.redAccent),),
                  SizedBox(height: 4,),
                  Text(DateUtil.formatDateMs(int.parse(translateList[index]["createTime"]),format: DateFormats.y_mo_d_h_m),style:TextStyle(color:MyColors.GRAY_TEXT_99,fontSize: 12)),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildButton(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BaseButton().getBaseButton(
            text: "收款",
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return TabReceive();
              }));
            },
            color: Color.fromARGB(0xff, 0x1e, 0xd6, 0x9c),
            width: 160,
            height: 56
          ),
          BaseButton().getBaseButton(
            text: "转账",
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return TabTransfer(token: widget.token,);
              }));
            },
            width: 160,
            height: 56
          ),
        ],
      ),
    );
  }

  void _getHistory() async {
    var sql = SqlUtil.setTable("transfer");
    List<Map> arr = await sql.get();
    List<Map> arrHis = List.from(arr);
//    arrHis.retainWhere((e)=>(e['tokenName']=="ETH"));
    setState(() {
      this.translateList = arrHis;
    });
    print(arr);
  }


}
