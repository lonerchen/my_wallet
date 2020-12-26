

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youwallet/model/user.dart';
import 'package:youwallet/pages/mine/center_address.dart';
import 'package:youwallet/pages/mine/message.dart';
import 'package:youwallet/util/gallery.dart';
import 'package:youwallet/value/colors.dart';

import '../mine/address.dart';
import '../mine/income.dart';
import '../mine/invite.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {

  RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = new RefreshController();
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
      body: SmartRefresher(
        controller: refreshController,
        onRefresh: (){
          refreshController.refreshCompleted();
          Provider.of<UserInfo>(context).getUserInfo();
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                _buildInfo(),
                _buildItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// 上半部分个人信息块
  ///
  Widget _buildInfo(){
    return Consumer<UserInfo>(
      builder: (context,userInfo,child) =>Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height:161,
                padding: EdgeInsets.only(left: 15,right: 15,top: 53),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/icon_mine_top_bg.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("个人中心",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 20,fontWeight: FontWeight.w600),),
                    Expanded(child: Container(height: 0,)),
                    Image.asset("images/icon_mine_settings.png",width: 20,height: 20,),

                  ],
                ),
              ),
            ),
            Container(
              height: 188,
              margin: EdgeInsets.only(left: 15,right: 15,top: 100),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 21,),
                  //头像
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap:()async{
                          File flie = await GalleryUtils().showPhotoSelect(context);
//                          List bytes =await flie.readAsBytes();
//                          String bs64 = base64Encode(bytes);
                          userInfo.saveUserInfo(fileBase64:flie,);

                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: userInfo?.portrait != null ? NetworkImage(userInfo.portrait) : AssetImage("images/icon_default_avatar.png",),
                            ),
                            borderRadius: BorderRadius.circular(90)
                          ),
//                          child: userInfo.portrait != null ? Image.network(userInfo.portrait) : Image.asset("images/icon_default_avatar.png",width: 56,height: 56,),
                        )
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
                          showDialog(
                              context: context,
                            builder: (context){
                                return DialogWidget();
                            }
                          ).then((value){
                            if(value != null){
                              userInfo.saveUserInfo(name:value);
                            }
                          });
                        },
                        child: Text(userInfo.name ?? "未设置用户名",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600,fontSize: 16),)
                      ),
                      SizedBox(width: 10,),
                      Container(
                        height: 23,
                        width: 90,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(0xff, 0x20, 0x2e, 0x44),
                          borderRadius: BorderRadius.circular(17),

                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset("images/icon_first_user.png",width: 12,height: 12,),
                            SizedBox(width: 3,),
                            Text("创世用户",style: TextStyle(color: Colors.white,fontSize: 12),),
                          ],
                        ),

                      ),

                      Expanded(child: Container(height: 0,)),
                      Icon(Icons.keyboard_arrow_right,size: 15,),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    color: MyColors.LINE_COLOR,
                    width: 325,
                    height: 2,
                  ),
                  SizedBox(height: 12,),
                  //功能条
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return InvitePage();
                              }
                          ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("images/icon_mine_invite.png",width: 36,height: 36,),
                            SizedBox(height: 5,),
                            Text("我的邀请",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14,fontWeight: FontWeight.w600),)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context){
                                return IncomePage();
                              }
                          ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("images/icon_mine_record.png",width: 36,height: 36,),
                            SizedBox(height: 5,),
                            Text("收益记录",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14,fontWeight: FontWeight.w600),)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => CenterAddressPage(true),
                          ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("images/icon_mine_address.png",width: 36,height: 36,),
                            SizedBox(height: 5,),
                            Text("地址本",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14,fontWeight: FontWeight.w600),),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///
  /// 下班部分功能块
  ///
  Widget _buildItem(){
    return Container(
      margin: EdgeInsets.only(left: 15,right: 15,top: 15),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return MessagePage();
                })
              );
            },
            child: Container(
              height: 55,
              child: Row(
                children: <Widget>[
                  Image.asset("images/icon_mine_message.png",width: 26,height: 26,),
                  SizedBox(width: 10,),
                  Text("公告",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22,),),
                  Expanded(child: Container(height: 0,)),
                  Icon(Icons.chevron_right,size: 15,),
                ],
              ),
            ),
          ),
          Container(
            height: 55,
            child: Row(
              children: <Widget>[
                Image.asset("images/icon_mine_about.png",width: 26,height: 26,),
                SizedBox(width: 10,),
                Text("关于我们",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22,),),
                Expanded(child: Container(height: 0,)),
                Icon(Icons.chevron_right,size: 15,),
              ],
            ),
          ),
          InkWell(
            onTap: (){
//              MyApp.logout(context);
            },
            child: Container(
              height: 55,
              child: Row(
                children: <Widget>[
                  Image.asset("images/icon_mine_about.png",width: 26,height: 26,),
                  SizedBox(width: 10,),
                  Text("退出登录",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22,),),
                  Expanded(child: Container(height: 0,)),
                  Icon(Icons.chevron_right,size: 15,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class DialogWidget extends StatefulWidget {
  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 280,
          height: 145,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("昵称",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
              SizedBox(height: 10,),
              Container(
                width: 215,
                height: 42,
                color: Color.fromARGB(0xfF, 0xfa, 0xfb, 0xfc),
                child: TextField(
                  maxLines: 1,
                  onSubmitted: (text){
                    Navigator.of(context).pop(text);
                  },

                  style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "输入昵称",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
