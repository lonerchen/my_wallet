import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';

class InviteDetailsPage extends StatefulWidget {
  @override
  _InviteDetailsPageState createState() => _InviteDetailsPageState();
}

class _InviteDetailsPageState extends State<InviteDetailsPage> {

  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar("详情"),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _buildInfo(),
              _buildCoinList(),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// 用户信息
  ///
  Widget _buildInfo(){
    return Container(
      height:141,
      padding: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("images/icon_invite_details_bg.png")
        ),
      ),
      child: Row(
        children: [
          Image.asset("images/icon_default_avatar.png",width: 48,height: 48,),
          SizedBox(width: 10,),
          Text("张三",style: TextStyle(fontSize: 14,color: Colors.white),),
          Expanded(child: Container(height: 0,)),
          Text("2019.08.21",style: TextStyle(fontSize: 12,color: Colors.white),),
        ],
      ),
    );
  }

  ///
  /// 币种收益列表
  ///
  Widget _buildCoinList(){
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset("images/icon_eth.png",width: 28,height: 28,),
                    SizedBox(width: 10,),
                    Text("ETH",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                  ],
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    setState(() {
                      isExpand = !isExpand;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment : CrossAxisAlignment.start,
                          children: [
                            Text("质押量",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                            SizedBox(height: 8,),
                            Text("10000",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment : CrossAxisAlignment.start,
                          children: [
                            Text("提供算力值mol",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                            SizedBox(height: 8,),
                            Text("10000",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                          ],
                        ),
                      ),
                      SizedBox(width: 50,),
                      isExpand ? Icon(Icons.keyboard_arrow_down,color: MyColors.BLACK_TEXT_22,size: 20,) : Icon(Icons.keyboard_arrow_right,color: MyColors.BLACK_TEXT_22,size: 20,),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                _buildExpands(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExpands(){
    return Visibility(
      visible: isExpand,
      child: Container(
        child: Column(
          children: [

            Divider(height: 1,),
            SizedBox(height: 15,),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MyColors.THEME_COLORS,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text("兑换比率:",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
                Text("1 ETH ≈ 2500 VPN",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                Expanded(child: Container(height: 0,)),
                Text("2019.08,02",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
              ],
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text("兑换量:",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
                Text("0.2 ETH   2500 VPN",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
              ],
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text("提供算力:",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
                Text("5000mol",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
              ],
            ),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }



}
