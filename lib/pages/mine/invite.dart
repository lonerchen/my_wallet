import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/http/dio_utils.dart';
import 'package:youwallet/http/url.dart';
import 'package:youwallet/model/invite.dart';
import 'package:youwallet/model/token.dart';
import 'package:youwallet/pages/token/token_select.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';

import 'invite_details.dart';

///
/// 我的邀请 / 我的好友
///
class InvitePage extends StatefulWidget {

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {

  RefreshController refreshController = new RefreshController();

  List<Map> tokenList = new List();
  Map token = Map();

  List<Invite> inviteList = [
//    Invite(),
//    Invite(),
//    Invite(),
//    Invite(),
  ];

  bool isShowSel = false;//是否显示好友团队选项卡

  @override
  void initState() {
    super.initState();
    tokenList = Token.getAvailableToken(Global.context);
    token = tokenList[0];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar(
          "我的好友",
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.only(right:16.0),
            child: Text("规则",style: TextStyle(fontSize: 18,color: MyColors.BLACK_TEXT_22),),
          )),
        ],
      ),
      body: SmartRefresher(
        controller: refreshController,
        onRefresh: (){
          refreshController.refreshCompleted();
          _refresh();
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                _buildTitle(),
                _buildInviteNum(),
                _buildList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// 标题栏
  ///
  Widget _buildTitle(){
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 15,),
          Text("选择币种",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
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
                        Text(token["name"],style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
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

  Widget _buildInviteNum(){
    return Container(
      height: 160,
      padding: EdgeInsets.symmetric(horizontal: 35),
      decoration: BoxDecoration(
        image: DecorationImage(
          image:AssetImage("images/icon_invite_bg.png"),
        )
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("我的好友",style: TextStyle(fontSize: 14,color: Colors.white),),
                Text("367位",style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w600),),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
                onTap: (){
                  setState(() {
                    isShowSel = true;
                  });
                },
                child: Icon(Icons.keyboard_arrow_down,color: Colors.white,size: 30,)
            ),
          ),
          Visibility(
            visible: isShowSel,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 115,
                height: 96,
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap:(){
                          setState(() {
                            isShowSel = false;
                          });
                        },
                          child: Center(child: Text("好友",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),))
                      ),
                    ),
                    Divider(height: 1,),
                    Expanded(
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              isShowSel = false;
                            });
                          },
                          child: Center(child: Text("团队",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),))
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildList(){
    return Container(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: inviteList.length > 0 ? _buildItem() : _buildEmptyWidget(),
      ),
    );
  }

  List<Widget> _buildEmptyWidget(){
    return <Widget>[
      Container(
        height: 500,
        child: Center(
            child: Column(
              children: [
                Image.asset("images/icon_not_invite.png",width:100,height:100),
                SizedBox(height: 18,),
                Text("暂无好友",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
              ],
            )
        ),
      )
    ];
  }

  List<Widget> _buildItem(){
    return List.generate(inviteList.length, (index){
      return Container(
        height: 177,
        margin: EdgeInsets.only(left: 15,right: 15,top: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(inviteList[index].avatar,width: 48,height: 48,),
                SizedBox(width: 10,),
                Text(inviteList[index].name,style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                Expanded(child: Container(height: 0,)),
                Text(inviteList[index].date,style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
              ],
            ),
            SizedBox(height: 15,),
            Divider(height: 1,),
            SizedBox(height: 15,),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return InviteDetailsPage();
                }));
              },
              child: Row(
                children: [
                  Text("繁殖分裂权限"),
                  Expanded(child: Container(height: 0,),),
                  Icon(Icons.keyboard_arrow_right,size:20),
                ],
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(inviteList[index].coinList.length, (index1){
                  return Container(
                    margin: EdgeInsets.only(right: 20),
                      child: Image.asset(inviteList[index].coinList[index1],width: 28,height: 28,)
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }

  _refresh(){
//    DioUtils.getInstance().post(URL.teamMember,params: {
//      "coind":token["id"],
//    }).then((value){
//      setState(() {
////        inviteList = Invite.value["date"]
//      });
//    });
  }

}
