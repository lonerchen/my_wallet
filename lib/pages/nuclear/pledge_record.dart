

import 'package:flutter/material.dart';
import 'package:youwallet/model/pledge.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';

class PledgeRecordPage extends StatefulWidget {
  @override
  _PledgeRecordPageState createState() => _PledgeRecordPageState();
}

class _PledgeRecordPageState extends State<PledgeRecordPage> {

  //质押记录数据
  List<PledgeRecord> listData = [PledgeRecord(),PledgeRecord(),PledgeRecord(),PledgeRecord(),PledgeRecord(),
    PledgeRecord(),PledgeRecord(),PledgeRecord(),PledgeRecord(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar(""),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 24,),
            Text("质押记录",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
            SizedBox(height: 24,),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("币种",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                          Text("数量",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                          Text("时间",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: listData.length > 0 ? List.generate(listData.length, (index){
                          return Container(
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Image.asset("images/icon_eth.png",width: 24,height: 24,),
                                SizedBox(width: 6,),
                                Text("${listData[index].coinName}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
                                Expanded(child: Center(child: Text("${listData[index].num}",style: TextStyle(fontSize: 14,color: Color.fromARGB(0xff, 0x1e, 0xd6, 0x9c)),))),
                                Text("${listData[index].time}",style: TextStyle(fontSize: 14,color: MyColors.GRAY_TEXT_99),),
                              ],
                            ),
                          );
                        }) : BaseWidget.getEmptyWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
  
  
  
}
