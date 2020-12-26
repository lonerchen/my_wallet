import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/model/dapp_transaction.dart';
import 'package:youwallet/pages/mine/address.dart';
import 'package:youwallet/service/token_service.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/bottomSheetDialog.dart';
import 'package:youwallet/widgets/button.dart';
import 'package:youwallet/widgets/customStepper.dart';
import 'package:youwallet/widgets/modalDialog.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:youwallet/model/token.dart';
import 'package:youwallet/model/book.dart';
import 'package:youwallet/service/trade.dart';
import 'package:youwallet/bus.dart';
import 'package:youwallet/db/sql_util.dart';
import 'package:youwallet/widgets/customButton.dart';
import 'package:youwallet/widgets/tokenSelectSheet.dart';
import 'package:youwallet/widgets/loadingDialog.dart';
import 'package:youwallet/global.dart';
import 'package:decimal/decimal.dart';
import 'package:youwallet/widgets/inputDialog.dart';

//03926ab4d3e6f76a339a27ace1aa02add63e1589e693e6f5812fe5c144344987
class TabTransfer extends StatefulWidget {

  String inputAddress = "";
  Map token = null;

  final DappTransaction dappTransaction;

  TabTransfer({this.inputAddress,this.dappTransaction,this.token});

  @override
  State<StatefulWidget> createState() {
    return new Page();
  }
}

class Page extends State<TabTransfer> {
  String balance = '';
  final globalKey = GlobalKey<ScaffoldState>();
  var value;
  static String defaultToAddress = '';

  // 定义TextEditingController()接收收款地址的输入值
  TextEditingController _addressController = new TextEditingController();
  // 定义TextEditingController()余额的输入值
  TextEditingController _numController = new TextEditingController();

  // 选择的token
  Map token = {};

  //展示的名称
  String name = "选择币种";

  //当前是否转账以太坊
  bool isEth = false;

  // 定义TextEditingController()，接收联系人备注
  TextEditingController _addressRemarkInput;

  //数据初始化
  @override
  void initState() {
    super.initState();
    if(widget.token != null){
      token = widget.token;
      isEth = false;
      token = widget.token;
      balance = widget.token['balance'];
      name = widget.token['name'];
    }
    if(widget.dappTransaction != null){
      _addressController = new TextEditingController(text: widget.dappTransaction.to);
//      String _num = idget.dappTransaction.da
      _numController = new TextEditingController(text: widget.dappTransaction.to);
    }


    _addressController = TextEditingController(text:widget.inputAddress);
    // 监听页面切换，刷新交易的状态
    eventBus.on<TabChangeEvent>().listen((event) {
      print("event listen =》${event.index}");
      if (event.index == 3) {
        print('刷新当前的token余额');
        print(Global.toAddress);
        this._getBalance();
      } else {
        print('do nothing');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }

  double slider = 1.0;
  Widget layout(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      appBar: BaseAppBar().getBaseAppBar(""),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _buildTitle(),
              _buildSelCoin(),
              SizedBox(height: 23,),
              _buildAddressInput(),
              SizedBox(height: 23,),
              _buildNum(),
              SizedBox(height: 130,),
              _buildNextButton(),
              SizedBox(height: 49,),
            ],
          ),
        ),
      )
    );
  }

  ///
  /// 标题
  ///
  Widget _buildTitle(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 19),
      child: Row(
        children: <Widget>[
          Text("转账",style: TextStyle(fontSize: 20,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
          Expanded(child: Container(height: 0,)),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return UnCenterAddressPage();
                  }
              )).then((value){
                if(value != null){
                  _addressController.text = value;
                  setState(() {

                  });
                }
              });
            },
            child: Visibility(
              visible: widget.dappTransaction == null,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Text("地址本",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                    SizedBox(width: 5,),
                    Image.asset("images/icon_address_book.png",width: 24,height: 23,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// 接收地址输入栏
  ///
  Widget _buildAddressInput(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("接收地址",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.all(15),
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6)
            ),
            child: TextField(
              maxLines: 1,
              readOnly: widget.dappTransaction != null,
              style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "输入或粘贴钱包地址",
                hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
              ),
              controller: _addressController,
            ),
          ),
        ],
      ),
    );
  }


  ///
  /// 选择币种
  ///
  Widget _buildSelCoin(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("选择币种",style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
//              if (Provider.of<Token>(context).items.toList().length == 0) {
//                print('当前选项数量为0，不弹出');
//                Global.showSnackBar(context, '请先前往首页添加token');
//              } else {
                this.selectToken(context);
//              }
            },
            child: Container(
              padding: EdgeInsets.all(15),
              height: 56,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6)
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  maxLines: 1,
                  style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNum(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("数量",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99,),),
              Expanded(child: Container(height: 0,)),
              Text("余额：${this.balance ?? "--"} ${name??="--"}",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99,),),
            ],
          ),
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.all(15),
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 12),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "输入数量",
                      hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                    ],
                    controller: _numController,
                  ),
                ),
                GestureDetector(
                    onTap: (){
                      _numController.text = "${this.balance ?? "0"}";
                    },
                    child: Text("全部 ",style: TextStyle(color: MyColors.THEME_COLORS,fontSize: 12),)
                ),
                Text("| ${name ?? "--"}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildNextButton(){
    return BaseButton().getBaseButton(text: "下一步", onPressed: (){
//      Navigator.push(context, MaterialPageRoute(builder: (context){
//        return TransferCheckPage(Ethereum());
//      }));
      checkInput();
    });
  }

  void checkInput() {
    print(this.token);
    if (this.token.isEmpty) {
      this.showSnackbar('请选择token');
      return;
    }

    // 对转账金额做数字校验
    try {
      if (Decimal.parse(this._numController.text) <= Decimal.parse('0')) {
        this.showSnackbar('金额必须大于0');
        return;
      }
      List strs = this._numController.text.split('.');
      if (strs.length == 2) {
        if (strs[1].length > Global.priceDecimal) {
          this.showSnackbar(
              '价格小数最多${Global.priceDecimal}位，你输入了${strs[1].length}位');
          return;
        }
      }
    } catch (e) {
      print(e);
      this.showSnackbar('你输入的金额无法识别');
      return;
    }

    if (this._addressController.text == '') {
      this.showSnackbar('请输入收款地址');
      return;
    }

    if (this._addressController.text.length != 42) {
      this.showSnackbar('收款地址长度不符合42位长度要求');
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GenderChooseDialog(
              title: '确认付款?',
              content: '',
              onCancelChooseEvent: () {
                Navigator.of(context).pop();
                // 关闭键盘
                FocusScope.of(context).requestFocus(FocusNode());
                this.showSnackbar('取消转账');
              },
              onSuccessChooseEvent: () {
                Navigator.of(context).pop('confirm');
                // 关闭键盘
                FocusScope.of(context).requestFocus(FocusNode());
              });
        }).then((val) {
      print(val);
      if (val == 'confirm') {
        this.startTransfer();
      }
    });
  }

  /// 弹出底部的选择列表
  selectToken(context) async {
    // String wallet =
    //     Provider.of<walletModel.Wallet>(context).currentWalletObject['address'];
    // List tokens = Provider.of<Token>(context)
    //     .items
    //     .where((e) => (e['wallet'] == wallet))
    //     .toList();
    // if (tokens.length == 0) {
    //   print('当前钱包没有token');
    //   final snackBar = new SnackBar(content: new Text('还没有添加token'));
    //   Scaffold.of(context).showSnackBar(snackBar);
    //   return;
    // }
    List<Map> list = new List();
    list.add(Provider.of<Wallet>(context).currentWalletObject);
    list.addAll(Provider.of<Token>(context).items);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return BottomSheetDialog(
              content: list,
              onSuccessChooseEvent: (res,index) {
                setState(() {
                  isEth = index == 0;
                  token = res;
                  balance = res['balance'];
                  name = isEth ? "ETH" : res['name'];
                });
              });
        });
  }

  // 定义bar上的内容
  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        title: const Text('转账'),
        elevation: 0.0,
        actions: this.appBarActions(),
        automaticallyImplyLeading: false //设置没有返回按钮
        );
  }

  appBarActions() {
    return <Widget>[
      new Container(
        width: 50.0,
        child: new IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.pushNamed(context, "token_history");
          },
        ),
      )
    ];
  }

  // 更新当前选中的token的余额
  Future<void> _getBalance() async {
    print('start ${this.token}');
    if (this.token.isEmpty) {
      print('当前token为空，不更新余额');
    } else {
      if(isEth){
        await Provider.of<Wallet>(context).updateWallet(this.token["address"]);
      }else {
        print('start');
        String balance = await TokenService.getTokenBalance(this.token);
        print('balance => ${balance}');
        await Provider.of<Token>(context).updateTokenBalance(
            this.token, balance);
      }
      setState(() {
        this.balance = balance;
      });
    }
  }

  // 更新联系人
//  Future<void> _getBookList() async {
//      print('_getBookList');
//      List res = await Provider.of<Book>(context).getBookList();
//      print(res);
////      setState(() {
////        this.balance =  balance;
////      });
//
//  }

  // 显示提示
  void showSnackbar(String text) async {
    final snackBar = SnackBar(content: Text(text));
    globalKey.currentState.showSnackBar(snackBar);
  }

  // 开始转账
  Future<void> startTransfer() async {

    print(_numController.text);
    String from = Provider.of<Wallet>(context).currentWallet;
    String to = _addressController.text;
    String num = _numController.text;
    // obj里面包括私钥，gaslimit，gasprice
    Navigator.pushNamed(context, "getPassword").then((obj) async {
      if(obj != null) {
        showDialog<Null>(
            context: context, //BuildContext对象
            barrierDismissible: false,
            builder: (BuildContext context) {
              return new LoadingDialog(
                //调用对话框
                text: '转账中...',
              );
            });
        try {
          String txnHash = await Trade.sendToken(
              from, to, num, this.token, obj, isEth);
          // 保存转账记录
          this.saveTransfer(from, to, num, txnHash, this.token,"0");
          // 保存转账人到常用联系人表
          await Provider.of<Book>(context).saveBookAddress([to, '']);
          // 拿到hash值，根据hash值查询以太坊打包是否成功
          this.checkOrderStatus(txnHash, 0);
        } catch (e) {
          print(e);
          this.showSnackbar(e.toString());
          Navigator.pop(context);
        }
      }
    });
  }

  void checkOrderStatus(String hash, int index) async {
    Map response = await Trade.getTransactionByHash(hash);
    print("第${index}次查询");
    print(response);
    if (response != null && response['blockHash'] != null) {
      print('打包成功，以太坊返回了交易的blockHash');
      Future.delayed(Duration.zero,(){
        Navigator.pop(context);
      });
      this.showSnackbar('转账成功');
      await this.updateTransferStatus(hash,response['nonce'],response['blockHash']);
      await this._getBalance();
      Future.delayed(Duration.zero,(){
        Navigator.pop(context,hash);
      });
    } else {
      if (index > 30) {
        print('已经轮询了30次，打包失败');
        Navigator.pop(context);
        this.showSnackbar('交易超时');
      } else {
        Future.delayed(Duration(seconds: 2), () {
          this.checkOrderStatus(hash, index + 1);
        });
      }
    }
  }

  // 构建wrap用的小选项
  Widget buildTagItem(item) {
    return new Chip(
      // avatar: Icon(Icons.people,size: 20.0, color: Colors.black26),
      label: GestureDetector(
        child:
            new Text(item['remark'] != '' ? item['remark'] : item['address']),
        onTap: () {
          print(item);
          this.setState(() {
            _addressController = TextEditingController(text: item['address']);
          });
        },
      ),
      deleteIcon: Icon(Icons.edit, size: 20.0, color: Colors.black26),
      onDeleted: () {
        this.editAddressRemark(item);
      },
    );
  }

  // 调起输入框，输入联系人备注
  void editAddressRemark(Map item) {
    setState(() {
      _addressRemarkInput =
          TextEditingController(text: item['remark'] ?? item['address']);
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InputDialog(
              title: '编辑联系人备注',
              hintText: '���输入',
              controller: this._addressRemarkInput,
              onCancelChooseEvent: () {
                Navigator.pop(context);
              },
              onSuccessChooseEvent: () {
                this.editRemarkCallback(item);
              });
        });
  }

  // 编辑联系人的回调函数
  editRemarkCallback(Map item) async {
    print(item);
    await Provider.of<Book>(context).updateBookReamrk(
        {'remark': this._addressRemarkInput.text, 'address': item['address']});
    Navigator.pop(context);
  }

  void saveTransfer(String fromAddress, String toAddress, String num,
      String txnHash, Map token,String gas) async {
    var sql = SqlUtil.setTable("transfer");
    String sql_insert =
        'INSERT INTO transfer(fromAddress, toAddress, tokenName, tokenAddress, num,gas, hash ,createTime) VALUES(?, ?, ?, ?, ?, ?, ?, ?)';
    List list = [
      fromAddress,
      toAddress,
      name,
      token['address'],
      num,
      gas,
      txnHash,
      DateTime.now().millisecondsSinceEpoch
    ];
    int id = await sql.rawInsert(sql_insert, list);
    print("转账记录插入成功=》${id}");
  }

  Future<void> updateTransferStatus(String txnHash,nonce,blockHash) async {
    print('开始更新数据表 =》 ${txnHash}');
    var sql = SqlUtil.setTable("transfer");
    int i = await sql.update({'status': ' 转账成功',"nonce":nonce,"blockHash":blockHash}, 'hash', txnHash,);
    print('更新完毕=》${i}');
  }
}
///
/// export https_proxy=http://127.0.0.1:7890;
/// export http_proxy=http://127.0.0.1:7890;
/// export all_proxy=socks5://127.0.0.1:7890
///