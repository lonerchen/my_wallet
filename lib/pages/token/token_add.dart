import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:youwallet/service/token_service.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/loadingDialog.dart';
import 'package:youwallet/widgets/tokenList.dart';
import 'package:youwallet/widgets/tokenLogo.dart';
import 'package:youwallet/widgets/hotToken.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/model/token.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/bus.dart';

class AddToken extends StatefulWidget {
  final arguments;

  AddToken({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new Page();
  }
}

class Page extends State<AddToken> {
  List tokenArr = new List();
  Map token = {};
  bool showHotToken = true;
  TextEditingController searchController;

  final globalKey = GlobalKey<ScaffoldState>();

  //数据初始化
  @override
  void initState() {
    super.initState();
    print('token add initState');
    // initState在整个生命周期中只执行一次，
    // 所以把初始化异步获取数据的代码放在这里
    // 为什么不放在didChangeDependencies里面呢？因为它会导致这个逻辑被自行两次
    // 这里一定要用Future.delayed把异步逻辑包起来，
    // 因为页面还没有build，没有context，执行执行会发生异常

    Future.delayed(Duration.zero, () {
      if (!widget.arguments.isEmpty) {
          this.startSearch(widget.arguments['address']);
      }
      initData();
    });
  }

  initData()async{
    var myToken = Provider.of<Token>(context).items;
    myToken.forEach((element) {
      addAData(element);
    });
    Global.hotToken.forEach((element) {
      addAData(element);
    });
    setState(() {
    });
  }

  //去除重复数据
  void addAData(Map addValue){
    int length= tokenArr.length;
    if(length==0){
      tokenArr.add(addValue);
    }else {
      for (int i = 0; i < length; i++) {
        Map a = tokenArr[i];
        if (a["address"] == addValue["address"]) {
          return;
        }
      }
      tokenArr.add(addValue);
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        appBar:BaseAppBar().getBaseAppBar(""),
        body: Builder(builder: (BuildContext context) {
          return new Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  _buildSearchBar(),
                  SizedBox(height: 20,),
                  buildPage(),
                ],
              ));
        }));
  }

  // 根据用户输入，决定是否显示热门token
  Widget buildPage() {
      return Consumer<Token>(
        builder: (context,token,child) {
          return Expanded(
            child: ListView(
              children: List.generate(tokenArr.length, (index) => _buildItem(tokenArr[index],token)),
            ),
          );
        },
      );
  }

  Widget _buildItem(item , Token tokenList){
    bool isAdd = false;
    //已经添加的token
    Map token;
    for(int i =0;i <tokenList.items.length;i++){
      isAdd = tokenList.items[i]["address"] == item["address"];
      if(isAdd){
        token = tokenList.items[i];
       break;
      }
    }

    return Container(
      height: 56,
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("images/icon_eth.png", width: 34, height: 34,),
          SizedBox(width: 16,),
          Container(
            width: 152,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${item["name"]}", style: TextStyle(fontSize: 14,
                    color: MyColors.BLACK_TEXT_22,
                    fontWeight: FontWeight.w600),),
                Text("${item["address"]}", maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12, color: MyColors.GRAY_TEXT_99,),)
              ],
            ),
          ),
          Expanded(child: Container(height: 0,),),
          GestureDetector(
            onTap: (){
              if(isAdd){
                tokenList.remove(token);
              }else{
                this.startSearch(item['address']);
              }
            },
              child: Image.asset(isAdd ? "images/icon_remove.png" : "images/icon_add.png", width: 24, height: 24,),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchBar(){
    return Container(
      child: Row(
        children: <Widget>[
          //搜索框
          Expanded(
            child: Container(
              height: 36,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color:Color.fromARGB(0xff, 0xb0, 0xb0, 0xb0)),
                borderRadius: BorderRadius.circular(17.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                        this.startSearch(searchController.value.text);
                    },
                      child: Image.asset("images/icon_search_theme.png",width: 16,height: 16,)
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: Container(
                      height: 20,
                      child: TextField(
                        controller: searchController,
                        maxLines: 1,

                        scrollPadding: EdgeInsets.all(0),
                        style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14),
                        onSubmitted: (text){
                          this.startSearch(text);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.all(0),
                          hintText: "搜索合约地址",

                          hintStyle: TextStyle(color: MyColors.GRAY_TEXT_D8,fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 14,),
          //取消文本
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
              child: Text("取消",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 14),)
          ),
        ],
      ),
    );
  }

  void startSearch(String text) async {
    if (!text.startsWith('0x')) {
      this.showSnackbar('合约地址必须0x开头');
      return;
    }

    if (text.length != 42) {
      this.showSnackbar('地址长度不是42位');
      return;
    }
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(
            //调用对话框
            text: '搜索中...',
          );
        });
    // 获取token小数点、名字、余额这三个异步操作可以做成一个链式调用
    Future(() async {
      int decimals = await TokenService.getDecimals(text);
      print('decimals id $decimals');
      return Future.value(decimals);
    }).then((res) {
      Future.wait([
        TokenService.getTokenName(text),
        TokenService.getTokenBalance({'address': text, 'decimals': res})
      ]).then((list) {
        print(list);
        Map token = {};
        token['address'] = text;
        token['wallet'] = Global.getPrefs("currentWallet");
        token['name'] = list[0];
        token['balance'] = list[1];
        token['decimals'] = res;
        token['rmb'] = '';
        token['network'] = Global.getPrefs("network");
        setState(() {
          this.token = token;
          this.showHotToken = false;
        });
        Navigator.pop(context);
        saveToken(token);
      }).catchError((e) {
        print('catchError');
        print(e);
        this.showSnackbar('没有搜索到token');
        Navigator.pop(context);
      }).whenComplete(() {
        print("名字和余额查询完毕");
      });
    }).catchError((onError) {
      print('catchError');
      print(onError);
      Navigator.pop(context);
      this.showSnackbar('当前网络没有搜索到该token');
    }).whenComplete(() {
      print("全部完成");
    });
  }

  // 定义bar右侧的icon按钮
  appBarActions() {
    return <Widget>[
      new Container(
        width: 50.0,
        child: new IconButton(
          icon: new Icon(IconData(0xe61d, fontFamily: 'iconfont')),
          onPressed: () async {
            String code = await Global.scan(context);
            if (code == null) {
              return;
            }
            List arr = code.split(':');
            if (arr[1] == 'token') {
              Navigator.pushNamed(context, "add_token",
                  arguments: {'address': arr[0]});
            } else if (arr[1] == 'transfer') {
              Global.setToAddress(arr[0]);
              eventBus.fire(TabChangeEvent(3));
            } else {
              // print(code);
              // 如果模式无法匹配，就跳转扫码结果页面，显示扫码内容
              Navigator.pushNamed(context, "scan",
                  arguments: {'res': code, 'allowCopy': true});
            }
          },
        ),
      )
    ];
  }

  void showSnackbar(String text) {
    final snackBar = SnackBar(content: Text(text));
    globalKey.currentState.showSnackBar(snackBar);
  }

  // SHT智能合约地址,测试用
  // 0x3d9c6c5a7b2b2744870166eac237bd6e366fa3ef

  // 将搜索到的token填充到页面中
  buildTokenList(arr) {
    return new tokenList(arr: arr);
  }

  void saveToken(Map token) async {
    int id = await Provider.of<Token>(context).add(token);
    print(id);
    if (id == 0) {
      this.showSnackbar('token已经添加，不可以重复添加');
    } else {
      this.showSnackbar('token添加成功');
    }
  }
}
