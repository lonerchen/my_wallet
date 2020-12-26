
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youwallet/http/dio_utils.dart';
import 'package:youwallet/http/url.dart';
import 'package:youwallet/model/income.dart';
import 'package:youwallet/pages/token/token_select.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';

class IncomePage extends StatefulWidget {
  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  
  Map token = Map();

  RefreshController _refreshController = new RefreshController();

  List<Income> incomeList = [Income(),Income(),Income(),Income(),Income(),Income(),Income(),];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBarWhite("收益记录"),
      body: Container(
        color: MyColors.THEME_COLORS,
        child: Stack(
          children: [
            _buildBackGround(),
            _buildTitle(),
            _buildSumBar(),
            _buildList(),
          ],
        ),
      ),
    );
  }
  
  _refresh(){
//    DioUtils.getInstance().post(URL.nuclearList).then((value){
//      setState(() {
//        incomeList = Income.formJsonList(value["data"]);
//      });
//    });
  }

  ///
  /// 标题栏
  ///
  Widget _buildTitle(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 15,),
          Text("选择币种",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
          Expanded(child: Container(height: 0,),),
          InkWell(
            onTap: (){
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(22),topLeft: Radius.circular(22)),
                  ),
                  builder: (context){
                    return TokenSelectDialog();
                  }).then((value){
                if(value != null){
                  setState(() {
                    token = value;
                    _refresh();
                  });
                }
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
                        Image.asset("images/icon_eth.png",width: 24,height: 24,),
                        SizedBox(width: 10,),
                        Text(token["name"] ?? "暂无",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                        SizedBox(width: 24,),
                        Image.asset("images/icon_coin_sel.png",width: 15,height: 15,),
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
    );
  }

  Widget _buildBackGround(){
    return Container(
      margin: EdgeInsets.only(top: 73),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
          color: Colors.white
      ),
    );
  }

  //顶端的总收益数据条
  Widget _buildSumBar(){
    return Container(
      margin: EdgeInsets.only(top: 97),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("总收益:",style: TextStyle(fontSize: 14,color: MyColors.GRAY_TEXT_99),),
              SizedBox(height: 5,),
              Text("99.5654 WFS",style: TextStyle(fontSize: 18,color: MyColors.THEME_COLORS),),
            ],
          ),
          Expanded(child: Container(height: 0,)),
          Container(
            height: 32,
            width: 114,
            decoration: BoxDecoration(
              color: Color.fromARGB(0xff, 0xff, 0xfa, 0xf0),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text("繁殖收益",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                Expanded(child: Container(height: 0,)),
                Icon(Icons.arrow_drop_down,color:MyColors.BLACK_TEXT_22),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildList(){
    return Container(
      margin: EdgeInsets.only(top: 174),
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: (){
          _refreshController.refreshCompleted();
        },
        child: ListView(
          children: incomeList.length > 0 ? _buildItem() : BaseWidget.getEmptyWidget() ,
        ),
      ),
    );
  }

  List<Widget> _buildItem(){
    return List.generate(incomeList.length, (index){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 40,
        decoration: BoxDecoration(
          color: Color.fromARGB(0xff, 0xfa, 0xfa, 0xfa),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text("${incomeList[index].status}WFS",style: TextStyle(fontSize:14,color: Color.fromARGB(0xff, 0x66, 0x66, 0x66)),),
            Expanded(child: Container(height: 0,)),
            Text("${incomeList[index].createdAt}",style: TextStyle(fontSize:14,color: Color.fromARGB(0xff, 0x66, 0x66, 0x66)),),
          ],
        ),
      );
    });
  }

}
