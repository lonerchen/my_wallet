
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youwallet/http/dio_utils.dart';
import 'package:youwallet/http/url.dart';
import 'package:youwallet/model/pool.dart';
import 'package:youwallet/model/top10.dart';
import 'package:youwallet/model/wallet_center.dart';
import 'package:youwallet/pages/nuclear/pledge.dart';
import 'package:youwallet/pages/nuclear/pledge_record.dart';
import 'package:youwallet/pages/nuclear/rule_dialog.dart';
import 'package:youwallet/pages/token/token_select.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/modalDialog.dart';

import '../../global.dart';


///
/// 核变页面
/// 
class TabNuclearPage extends StatefulWidget {
  @override
  _TabNuclearPageState createState() => _TabNuclearPageState();
}

class _TabNuclearPageState extends State<TabNuclearPage> with TickerProviderStateMixin{

  //矿池列表
  List<Pool> poolList = new List();

  //钱包类型 去中心化钱包与中心化钱包
  List<Tab> tabTitles = <Tab>[
    new Tab(text: "日繁殖奖励",),
    new Tab(text: "日分裂奖励",),
    new Tab(text: "日分化奖励",),
  ];

  //激活后参数
  final List<String> tabActivatedValue = [
    "总收益","上轮收益","我的算力","上轮产币","全网产币"
  ];
  //激活后参数下标
  int tabActivatedIndex = 0;

  //收益
  List<Income> incomeList = new List();

  //收益类型
  List<IncomeType> incomeTypeList = new List();

  //模拟Top10繁殖数据
  List<Top10> top10FZList = [
    Top10(), Top10(),Top10(), Top10(),Top10(), Top10(),Top10(), Top10(),Top10(), Top10(),
  ];
  //模拟Top10分裂数据
  List<Top10> top10FLList = [
    Top10(), Top10(),Top10(), Top10(),Top10(), Top10(),Top10(), Top10(),Top10(), Top10(),
  ];
  //模拟Top10分化数据
  List<Top10> top10FHList = [
//    Top10(), Top10(),Top10(), Top10(),Top10(), Top10(),Top10(), Top10(),Top10(), Top10(),
  ];

  TabController _top10Controller;
  ValueNotifier _top10Index = ValueNotifier(0);

  //距离十二点的倒计时
  Timer timerDay;

  //现在的时间
  DateTime dateTime = DateTime.now();

  RefreshController _refreshController = new RefreshController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timerDay = new Timer.periodic(Duration(seconds: 1), (timer){
      if(mounted){
        setState(() {
          dateTime = DateTime.now();
        });
      }
    });
    _top10Controller = TabController(
      vsync: this,
      length: tabTitles.length,
      initialIndex: _top10Index.value,
    )..addListener(() {
      // 监听 & 记录 index
      if (_top10Controller.indexIsChanging) {
        return;
      }
      setState(() {
        _top10Index.value = _top10Controller.index;
      });
    });
    _refresh(Global.context);
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
      body: SmartRefresher(
        controller: _refreshController,
        header: ClassicHeader(),
        onRefresh: ()async{
          await _refresh(context);
          _refreshController.refreshCompleted();
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 60,),
                _buildTitle(),
                SizedBox(height: 22,),
                _buildCountdown(),
                SizedBox(height: 15,),
                _buildNotify(),
                SizedBox(height: 15,),
                _buildCoinSel(),
                SizedBox(height: 15,),
                _buildActivation(),
                _buildActivated(),
                SizedBox(height: 15,),
                _buildActivatedValue(),
                SizedBox(height: 30,),
                _buildTop10(),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTitle(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Text("欢迎来到Wifi",style: TextStyle(fontSize: 24,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
          Expanded(child: Container(height: 0,)),
          InkWell(
            onTap: (){
              showDialog(context: context,builder: (contexy) => RuleDialog());
            },
            child: Row(
              children: [
                Image.asset("images/icon_rule.png",width: 20,height: 20,),
                SizedBox(width: 8,),
                Text("规则",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14),),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCountdown(){
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
            image: AssetImage("images/icon_nuclear_bg.png"),
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("距离次轮分红剩余",style: TextStyle(color: Colors.white,fontSize: 14),),
            Text("${(dateTime.hour - 23).abs()}:${(dateTime.minute - 59).abs()}:${(dateTime.second - 59).abs()}",style: TextStyle(color: Colors.white,fontSize: 36,fontWeight: FontWeight.w600),),
          ],
        ),
      ),
    );
  }

  Widget _buildNotify(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Image.asset("images/icon_notify.png",width: 22,height: 22,),
          SizedBox(width: 6,),
          Expanded(
            child: Text(
              '关于"参与ETF交易，瓜分第四期SpaceM代参与Ethereal"',
              style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          Image.asset("images/icon_right_arrow.png",width: 12,height: 12,),
        ],
      ),
    );
  }

  Widget _buildCoinSel(){
    return Consumer<WalletCenter>(
      builder: (context,walletCenter,child) =>Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Text("选择币种激活权限",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14,fontWeight: FontWeight.w600),),
            SizedBox(width: 10,),
            Expanded(
              child: InkWell(
                onTap: (){
                  showModalBottomSheet(context: context, builder: (context) => TokenSelectDialog()).then((value){
                    if(value != null && value){
                      _refresh(context);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.THEME_COLORS,width: 0.5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.only(left: 6,right: 6,top: 6,bottom: 6),
                  child: Row(
                    children: <Widget>[
                      Image.network(walletCenter.currentWalletCenter?.icon ?? "",width: 24,height: 24,),
                      SizedBox(width: 6,),
                      Text(walletCenter.currentWalletCenter?.name ?? "",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),),
                      Expanded(child: Container(height: 0,)),
                      Icon(Icons.arrow_drop_down,color: MyColors.BLACK_TEXT_22,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// 未激活布局
  ///
  Widget _buildActivation(){
    return Consumer<WalletCenter>(
      builder: (context,walletCenter,child) =>Visibility(
        visible: walletCenter.currentWalletCenter?.nuclearActivated == 0,
        child: Container(
          height: 62,
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Color.fromARGB(0xff, 251, 233, 223),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 18,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("质押2000WFS即可激活",style: TextStyle(color: Color.fromARGB(0xff, 220, 139, 119),fontSize: 12),),
                  Text('"繁殖及分裂权限"',style: TextStyle(color: Color.fromARGB(0xff, 179, 105, 85),fontSize: 15),),
                ],
              ),
              Expanded(child: Container(height: 0,)),
              BaseButton().getBaseButton(text: "立即激活", width:90,height:30,fontSize:12,onPressed: ()async{

                for(int i=0;i < poolList.length ; i++){
                  //查看该币种是否有矿池
                  if(walletCenter.currentWalletCenter.coinId == poolList[i].id){
                    //有矿池之后判断余额够不够，不够跳转质押页面，够的话，直接弹窗问要不要激活
                    if(double.parse(walletCenter.currentWalletCenter.balance) >= double.parse(poolList[i].activateNums)){
                      //todo 弹窗激活矿池
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return GenderChooseDialog(
                                title: '确认激活"${walletCenter.currentWalletCenter.name}"?',
                                content: '',
                                onCancelChooseEvent: () {
                                  Navigator.of(context).pop();
                                  // 关闭键盘
                                  FocusScope.of(context).requestFocus(FocusNode());
                                },
                                onSuccessChooseEvent: () {
                                  Navigator.of(context).pop('confirm');
                                  // 关闭键盘
                                  FocusScope.of(context).requestFocus(FocusNode());
                                });
                          }).then((val) async{
                            print(val);
                            if (val == 'confirm') {
//                              Map response = await DioUtils.getInstance().post(URL.nuclearJoin,params: <String,dynamic>{
//                                "coin_id":walletCenter.currentWalletCenter.coinId
//                              });
//                              await _refresh(context);
//                              await walletCenter.getWalletCenter();
//                              print("激活货币$response");
                            }
                        });
                    }else{
                      //跳转质押页面
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return PledgeCoinPage();
                        }),
                      );
                    }
                  }
                }
              }),
              SizedBox(width: 18,),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// 已激活布局
  ///
  Widget _buildActivated(){
    return Consumer<WalletCenter>(
      builder: (context,walletCenter,child) => Visibility(
        visible: walletCenter.currentWalletCenter?.nuclearActivated == 1,
        child: Container(
          height: 62,
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Color.fromARGB(0xff, 232, 247, 187),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 18,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("该币种已激活",style: TextStyle(color: Color.fromARGB(0xff, 176, 211, 91),fontSize: 12),),
                  Text('质押获取更多收获',style: TextStyle(color: Color.fromARGB(0xff, 121, 202, 84),fontSize: 15),),
                ],
              ),
              Expanded(child: Container(height: 0,)),
              BaseButton().getBaseButton(text: "立即开启", width:90,height:30,color:Color.fromARGB(0xff, 121, 202, 84),fontSize:12,onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){
                    return PledgeRecordPage();
                  }),
                );
              }),
              SizedBox(width: 18,),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// 激活后参数
  ///
  Widget _buildActivatedValue(){
    return Consumer<WalletCenter>(
      builder: (context,walletCenter,child) => Visibility(
        visible: walletCenter.currentWalletCenter?.nuclearActivated == 1,
        child: Container(
          margin: EdgeInsets.only(top: 25,bottom: 25),
          padding: EdgeInsets.only(left: 15),
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabActivatedValue.length, (index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          tabActivatedIndex = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6,horizontal: 12),
                        decoration: BoxDecoration(
                          color: tabActivatedIndex == index ? MyColors.THEME_COLORS : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text("${tabActivatedValue[index]}",style: TextStyle(color: tabActivatedIndex == index ? Colors.white : MyColors.BLACK_TEXT_22,fontSize: 14),),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(incomeList.length, (index){
                    return Container(
                      height: 100,
                      width: 105,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/icon_activated_bg.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 15,),
                          Text("${incomeList[index].earnings}${incomeList[index].gainCoin.name}",style: TextStyle(fontSize: 14,color: Colors.white),),
                          SizedBox(height: 4,),
                          Text("我的${incomeList[index].nuclear.title}总收益",style: TextStyle(fontSize: 12,color: Colors.white),),
                        ],
                      ),
                    );
                  }),
//                  <Widget>[
//
//                    Container(
//                      height: 100,
//                      width: 105,
//                      decoration: BoxDecoration(
//                        image: DecorationImage(
//                          image: AssetImage("images/icon_activated_bg.png"),
//                          fit: BoxFit.fill,
//                        ),
//                      ),
//                      child: Column(
//                        children: <Widget>[
//                          SizedBox(height: 15,),
//                          Text("99.4423ETH",style: TextStyle(fontSize: 14,color: Colors.white),),
//                          SizedBox(height: 4,),
//                          Text("我的繁殖总收益",style: TextStyle(fontSize: 12,color: Colors.white),),
//                        ],
//                      ),
//                    ),
//                    Container(
//                      height: 100,
//                      width: 105,
//                      decoration: BoxDecoration(
//                        image: DecorationImage(
//                          image: AssetImage("images/icon_activated_bg.png"),
//                          fit: BoxFit.fill,
//                        ),
//                      ),
//                      child: Column(
//                        children: <Widget>[
//                          SizedBox(height: 15,),
//                          Text("99.4423ETH",style: TextStyle(fontSize: 14,color: Colors.white),),
//                          SizedBox(height: 4,),
//                          Text("我的繁殖总收益",style: TextStyle(fontSize: 12,color: Colors.white),),
//                        ],
//                      ),
//                    ),
//                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop10(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset("images/icon_top10.png",width: 22,height: 22,),
              SizedBox(width: 8,),
              Text("TOP10",style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 18),),
            ],
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: <Widget>[
                TabBar(
                  tabs: tabTitles,
                  controller: _top10Controller,
                  labelColor: MyColors.THEME_COLORS,
                  unselectedLabelColor: MyColors.BLACK_TEXT_22,
                  labelStyle: TextStyle(fontSize: 14),
                  unselectedLabelStyle: TextStyle(fontSize: 14),
                  indicatorColor: MyColors.THEME_COLORS,
                  indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: true,
                ),
                Container(
                  height: 330,
                  child: TabBarView(
                    controller: _top10Controller,
                    children: List.generate(tabTitles.length, (index) {
                      return Container(
                        height: 330,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          children: getListItem(index),
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getListItem(int index){
    List<Top10> dataList = index == 0 ? top10FZList : index == 1 ?  top10FLList : top10FHList;
    List<Widget> widgetList = new List();
    if(dataList.length == 0){
      widgetList = BaseWidget.getEmptyWidget();
    }else {
      for (int i = 0; i < dataList.length; i++) {
        widgetList.add(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 30,
              child: Row(
                children: <Widget>[
                  //todo top10 信息
//                  Text("${i + 1}", style: TextStyle(
//                    color: MyColors.GRAY_TEXT_99, fontSize: 14,),),
//                  SizedBox(width: 30,),
//                  Text("${dataList[i].phone}", style: TextStyle(
//                      color: MyColors.BLACK_TEXT_22, fontSize: 14),),
//                  Expanded(child: Container(height: 0,)),
//                  Text("${dataList[i].balance}${dataList[i].coinName}", style: TextStyle(
//                      color: Color.fromARGB(0xff, 0x1E, 0xd6, 0x9c)),),
                ],
              ),
            )
        );
      }
    }
    return widgetList;
  }

  _refresh(BuildContext context)async{
//    WalletCenter walletCenter = Provider.of<WalletCenter>(context);
//    Map listResponse = await DioUtils.getInstance().post(URL.nuclearCoinList,);
//    poolList = Pool.formJsonList(listResponse["data"]);
//    print("矿池数据列表:$listResponse");
//
//    Map listResponse1 = await DioUtils.getInstance().post(URL.nuclearSum,body: <String,dynamic>{
//      "coin_id":walletCenter.currentWalletCenter?.coinId,
//    });
//    incomeList = Income.formJsonList(listResponse1["data"]);
//    print("矿池数据总收益:$listResponse1");
//
//    Map listResponse2 = await DioUtils.getInstance().post(URL.nuclearList,body: <String,dynamic>{
////      "coin_id":walletCenter.currentWalletCenter?.coinId,
//    });
//    incomeTypeList = IncomeType.formJsonList(listResponse2["data"]);
//    tabTitles = new List();
//    for(int i = 0;i < incomeTypeList.length;i++){
//      tabTitles.add(new Tab(text: "日${incomeTypeList[i].title}奖励",),);
//      //top10数据
//      Map top10Day = await DioUtils.getInstance().post(URL.nuclearTopDay,params: <String,dynamic>{
//        "coin_id":walletCenter.currentWalletCenter?.coinId,
//        "nuclear_id":incomeTypeList[i].id
//      });
//      if(i == 0){
////        top10FZList = Top10.fromMap(map)
//      }
//      print("top10数据$top10Day");
//    }
//    print("矿池收益方式列表:$listResponse2");


    setState(() {

    });
//    Map listResponse3 = await DioUtils.getInstance().post(URL.nuclearTopDay,body: <String,dynamic>{
//      "coinId":walletCenter.currentWalletCenter.coinId,
//    });
//    print("日收益前10:$listResponse2");

  }
  
}
