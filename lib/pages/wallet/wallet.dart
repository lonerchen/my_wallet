import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youwallet/model/account.dart';
import 'package:youwallet/model/token.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:youwallet/model/wallet_center.dart';
import 'package:youwallet/pages/manage_wallet/manage_list.dart';
import 'package:youwallet/pages/manage_wallet/select.dart';
import 'package:youwallet/pages/register/scan.dart';
import 'package:youwallet/pages/token/token_select.dart';
import 'package:youwallet/pages/wallet/center_transfer.dart';
import 'package:youwallet/pages/wallet/centralization.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/loadingDialog.dart';
import 'package:youwallet/model/wallet.dart' as walletModel;
import 'package:youwallet/widgets/userMenu.dart';

import 'decentralization.dart';

class WalletPage extends StatefulWidget {


  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin{


  List<Map> tokenArr = [];
  List<Map> wallets = []; // 用户添加的钱包数组
  int current_wallet = 0;
  String current_wallet_address = "";

  //当前选择的币种类型
  int coinIndex = 0;

  //下啦刷新控制器
  RefreshController _uncenterRefreshController;

  //用来刷新Page的页面
  GlobalKey uncenterKey = new GlobalKey();


  //钱包类型 去中心化钱包与中心化钱包
  final List<Tab> myTabs = <Tab>[
    new Tab(text: "ERC20",),
    new Tab(text: "TPX20",),
  ];

  //钱包模块下标 0对应的是去中心化钱包  其余对应各种中心化钱包
  ValueNotifier _walletIndex = ValueNotifier(0);

  //钱包模块的page控制器
  TabController _walletController;

  //控制侧方的窗口弹出
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    //区中心化钱包与中心化钱包选择模块的初始化
    _walletController = TabController(
      vsync: this,
      length: myTabs.length,
      initialIndex: _walletIndex.value,
    )..addListener(() {
      // 监听 & 记录 index
      if (_walletController.indexIsChanging) {
        return;
      }
      setState(() {
        _walletIndex.value = _walletController.index;
      });
    });
    _uncenterRefreshController = new RefreshController();
    _initWallet();
  }

  @override
  void dispose() {
    super.dispose();
    _walletController.dispose();
    _uncenterRefreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: new UserMenu(),
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 47,),
          _buildCoinSelect(),
          SizedBox(height: 24,),
          _buildPageBar(),
        ],
      ),
    );
  }
  
  Widget _buildCoinSelect(){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 15,),
          _walletIndex.value == 0 ?
          InkWell(
            borderRadius: BorderRadius.circular(19.5),
            onTap: (){
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(22),topLeft: Radius.circular(22)),
                  ),
                  builder: (context){
                return SelectPage();
              }).then((value){
                if(value != null){
                  Navigator.pushNamed(context, "wallet_guide");
                }else{
                  _refresh();
                }
              });
            },
            child: Container(
              height: 39,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(19.5)),
                color: Colors.white
              ),
              child: Consumer<walletModel.Wallet>(
                builder: (context, Wallet, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 39,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 13,),
//                        Image.asset(listUncenterCoin[coinIndex].image,width: 24,height: 24,),
                            SizedBox(width: 10,),
                            Text(Wallet.currentWalletObject['name'].length == 0
                                ? 'Wallet${Wallet.currentWalletObject['id']}'
                                : Wallet.currentWalletObject['name'],style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                            SizedBox(width: 24,),
                            Image.asset("images/icon_coin_sel.png",width: 20,height: 20,),
                            SizedBox(width: 13,),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          )
              : InkWell(
                  onTap: (){
                    showModalBottomSheet(context: context, builder: (context){
                      return TokenSelectDialog();
                    });
                  },
                  child: Container(
                    height: 39,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(19.5)),
                        color: Colors.white
                    ),
                    child: Consumer<WalletCenter>(
                        builder: (context, walletCenter, child) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 39,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 13,),
                                    Image.asset(walletCenter.currentWalletCenter?.icon ?? "",width: 24,height: 24,),
                                    SizedBox(width: 10,),
                                    Text("${walletCenter.currentWalletCenter?.name?? ""}",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                                    SizedBox(width: 24,),
                                    Image.asset("images/icon_coin_sel.png",width: 20,height: 20,),
                                    SizedBox(width: 13,),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                    ),
                  ),
                ),
          Expanded(child: Container(height: 0,),),
          _walletIndex.value == 0
              ? GestureDetector(
                  onTap: (){
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Icon(Icons.more_horiz,size: 27,color: Color.fromARGB(0xff, 0x00, 0x00, 0x00),) ,
                )
              : InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        return ScanPage();
                      })
                    ).then((value) {
                      if(value != null)
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return CenterTransfer(inputAddress: value);
                        })
                      );
                    });
                  },
                  child: Image.asset("images/icon_center_scan.png",height: 24,width: 24,)
                ),
          SizedBox(width: 15,)
        ],
      ),
    );
  }

  Widget _buildPageBar(){
    return Expanded(
      child: Container(
        child: Consumer<walletModel.Wallet>(
          builder: (context, Wallet, child){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: TabBar(
                    controller: _walletController,
                    tabs: myTabs,
                    labelColor: MyColors.THEME_COLORS,
                    unselectedLabelColor: MyColors.BLACK_TEXT_22,
                    labelStyle: TextStyle(fontSize: 16),
                    unselectedLabelStyle: TextStyle(fontSize: 14),
//                indicator: BoxDecoration(
//                  borderRadius: BorderRadius.circular(20),
//                  color: MyColors.THEME_COLORS
//                ),
                    indicatorColor: MyColors.THEME_COLORS,
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
//                indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                        controller: _walletController,
                        children: [
                          SmartRefresher(
                            controller: _uncenterRefreshController,
                            enablePullDown: true,
                            header: ClassicHeader(),
                            onRefresh: ()async{
                              await _refresh();
                              (uncenterKey.currentState as DecentralizationPageState).initData();
                              _uncenterRefreshController.refreshCompleted();
                            },
                            child: SingleChildScrollView(
                              child: Container(
                                child: DecentralizationPage(uncenterKey,Wallet.currentWalletObject,),
                              ),
                            ),
                          ),
//                          SingleChildScrollView(
//                            child:
                            Container(
                              child: CentralizationPage(),
                            ),
//                          ),
                        ]
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 首页下拉刷新
  // 刷新钱包的ETH余额
  // 刷新每个token的余额
  Future<void> _refresh() async {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            //调用对话框
            text: '刷新中...',
          );
        });
    String address =
    Provider.of<walletModel.Wallet>(context).currentWalletObject['address'];
    // 更新钱包的ETH余额
    await Provider.of<walletModel.Wallet>(context).updateWallet(address);
    // 更新钱包里面多个token的余额
    await Provider.of<Token>(context).updateBalance(address);
//    await Provider.of<AccountToken>(context).getAccountToken(Provider.of<walletModel.Wallet>(context).currentWalletObject['mnemonic'], "");
    final snackBar = new SnackBar(content: new Text('刷新结束'));
    Scaffold.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  _initWallet()async{


  }

}
