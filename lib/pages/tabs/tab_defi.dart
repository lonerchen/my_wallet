import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youwallet/db/sql_util.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/model/dapp_transaction.dart';
import 'package:youwallet/model/network.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:youwallet/pages/wallet/erc20_transfer.dart';
import 'package:youwallet/pages/wallet/eth_transfer.dart';
import 'package:youwallet/pages/wallet/un_center_transfer.dart';
import 'package:youwallet/service/trade.dart';
import 'package:youwallet/util/face.dart';
import 'package:youwallet/util/wallet_crypt.dart';
import 'package:youwallet/model/wallet.dart' as myWallet;
import 'package:http/http.dart';

import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/inputDialog.dart';

class TabDefiPage extends StatefulWidget {

  final String url;

  TabDefiPage({this.url});

  @override
  _TabDefiPageState createState() => _TabDefiPageState();
}

class _TabDefiPageState extends State<TabDefiPage> {

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ///
  /// 交易eth主币
  ///
  JavascriptChannel signTransaction(BuildContext context) => JavascriptChannel(
      name: 'signTransaction', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("js:signTransaction = " + message.message);
        var messageList = message.message.split("#");
        var id = messageList[0];
        var data = JsonDecoder().convert(messageList[1]);
        DappTransaction dappTransaction = DappTransaction.fromJson(data);

        String rpcurl = await Global.getBaseUrl();
        if(dappTransaction != null) {
          var httpClient = new Client();
          var ethClient = new Web3Client(rpcurl, httpClient);

          myWallet.Wallet wallet = Provider.of<myWallet.Wallet>(context);
          Network network = Provider.of<Network>(context);

          String pwd = await _showPasswordDialog();
          String privateKey = await wallet.getPrivateKey(pwd);

          var h = HEX.decode(dappTransaction.data.substring(2, dappTransaction.data.length));
          Uint8List uint8list = Uint8List.fromList(h);

          var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
          EtherAmount amount = await ethClient.getGasPrice();
//          String gasValue =  dappTransaction.gas.substring(2,dappTransaction.gas.length);
//          BigInt bigInt = BigInt.parse(gasValue,radix:16);

          String hash = await ethClient.sendTransaction(
            credentials,
            Transaction(
              from: EthereumAddress.fromHex(dappTransaction.from),
              to: EthereumAddress.fromHex(dappTransaction.to),
//              gasPrice: EtherAmount.inWei(bigInt),
              gasPrice: amount,
              maxGas: 5000000,
              value: EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.parse(dappTransaction.value.replaceAll("0x", ""),radix: 16)),
              data: uint8list,
            ),
            chainId: network.chainId,
          );
          //country jungle wrap worth soccer online wage cram skin castle noodle oval
          print(hash);
          if (hash != null) {
            String responseString = "window.ethereum.sendResponse($id, ['$hash'])";
            await _webViewController.evaluateJavascript(responseString).then((value) async{
              // 保存转账记录
              await this.saveTransfer(dappTransaction.from, dappTransaction.to, "~Dapp", hash, {"name":"ETH","address":"~Dapp",},"0");
              await checkOrderStatus(hash,0);
            });
          }else{
            String errorString = "window.ethereum.sendError($id,[])";
            await _webViewController.evaluateJavascript(errorString).then((value) {
              print(value);
            });
          }
        }

      });

  ///
  /// 交易token代币
  ///
  JavascriptChannel signErc20Transaction(BuildContext context) => JavascriptChannel(
      name: 'signErc20Transaction', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("js:signErc20Transaction = " + message.message);
        var messageList = message.message.split("#");
        var id = messageList[0];
        var data = JsonDecoder().convert(messageList[1]);
        DappTransaction dappTransaction = DappTransaction.fromJson(data);

        String rpcurl = await Global.getBaseUrl();
        if(dappTransaction != null) {
          var httpClient = new Client();
          var ethClient = new Web3Client(rpcurl, httpClient);

          myWallet.Wallet wallet = Provider.of<myWallet.Wallet>(context);
          Network network = Provider.of<Network>(context);

          String pwd = await _showPasswordDialog();
          String privateKey = await wallet.getPrivateKey(pwd);

          var h = HEX.decode(dappTransaction.data.substring(2, dappTransaction.data.length));
          Uint8List uint8list = Uint8List.fromList(h);

          var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
          EtherAmount amount = await ethClient.getGasPrice();
//          String gasValue =  dappTransaction.gas.substring(2,dappTransaction.gas.length);
//          BigInt bigInt = BigInt.parse(gasValue,radix:16);

          String hash = await ethClient.sendTransaction(
            credentials,
            Transaction(
              from: EthereumAddress.fromHex(dappTransaction.from),
              to: EthereumAddress.fromHex(dappTransaction.to),
//              gasPrice: EtherAmount.inWei(bigInt),
              gasPrice: amount,
              maxGas: 5000000,
//              value: EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.parse(dappTransaction.value.replaceAll("0x", ""),radix: 16)),
              data: uint8list,
            ),
            chainId: network.chainId,
          );
          //country jungle wrap worth soccer online wage cram skin castle noodle oval
          print(hash);
          if (hash != null) {
            String responseString = "window.ethereum.sendResponse($id, ['$hash'])";
            await _webViewController.evaluateJavascript(responseString).then((value) async{
              print(value);

              // 保存转账记录
              await this.saveTransfer(dappTransaction.from, dappTransaction.to, "~Dapp", hash, {"name":"~Dapp","address":"~Dapp",},"0");
              await checkOrderStatus(hash,0);
            });
          }else{
            String errorString = "window.ethereum.sendError($id,[])";
            await _webViewController.evaluateJavascript(errorString).then((value) {
              print(value);
            });
          }
        }


      });

  // 获取密码
  Future<String>  _showPasswordDialog()async{
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InputDialog(
              title: 'DApp请求一笔交易',
              hintText: '请输入密码'
          );
        }
    );
  }

  ///
  /// 保存交易记录
  ///



  ///
  /// h5请求信息
  ///
  JavascriptChannel eth_requestAccounts(BuildContext context) => JavascriptChannel(
      name: 'eth_requestAccounts', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        myWallet.Wallet wallet = Provider.of<myWallet.Wallet>(context);
        String address = wallet.currentWalletObject["address"];
        print("js:eth_requestAccounts = " + message.message);
        var messageList = message.message.split("#");
        var id = messageList[0];
        if(id.length > 4) {
          String responseString = "window.ethereum.sendResponse($id, ['$address'])";
//        String errorString = "window.ethereum.sendError(${messageList[0]},[])";
          await _webViewController.evaluateJavascript(responseString).then((
              value) {
            print(value);
          });
        }

      });


  ///
  /// h5请求信息
  ///
  JavascriptChannel test(BuildContext context) => JavascriptChannel(
      name: 'test', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("test = " + message.message);
      });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: ()async{
              bool isBack = await _webViewController.canGoBack();
              if(isBack){
                _webViewController.goBack();
              }
            }),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: ()async{
                _webViewController.reload();
              }),
        ],
      ),
      body: Consumer2<myWallet.Wallet,Network>(
        builder: (context,wallet,network,widget){
          return Container(
//            child: getPlatformView(wallet,network),
            child: WebView(
//              initialUrl: "https://uniswap.tokenpocket.pro/#/swap",
              initialUrl: this.widget.url == null ? "https://www.beepool.biz/" : this.widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              userAgent: "random",
              onWebViewCreated: (controller)async{
                _webViewController = controller;
                },
              javascriptChannels: <JavascriptChannel>{
                signTransaction(context),
                signErc20Transaction(context),
                eth_requestAccounts(context),
                test(context),
              },
              onPageFinished: (str)async{
//                String js = 'window.rpcurl="${Global.getBaseUrl()}";window.wsrpc="${Global.getWSBaseUrl()}"; window.defaultAccount = "${wallet.currentWalletObject["address"]}";window.setConfig();';
                String rpcurl = await Global.getBaseUrl();
                String address = wallet.currentWalletObject["address"];
                String chainId = "${network.chainId}";
                String js = await rootBundle.loadString("assets/trust.js");
//                String js = await rootBundle.loadString("assets/web3_min.js");
                String js1 = await rootBundle.loadString("assets/trust_init.js");
//                var address = "0xb44b516931375c9f7bfce23e339b70a811da9885";
//                var rpcurl = "https://ropsten.infura.io/v3/9ff09f1a3c284d28830665290dab81c5";
//                var chainId = "3";
                js1 = js1.replaceFirst("\$rpcurl", rpcurl);
                js1 = js1.replaceFirst("\$address", address);
                js1 = js1.replaceFirst("\$chainId", chainId);
                await _webViewController.evaluateJavascript(js).then((value){
                  print(value);
                });
                await _webViewController.evaluateJavascript(js1).then((value){
                  print(value);
                });//
              },
            ),
          );
        },
      ),
    );
  }

  Future checkOrderStatus(String hash, int index) async {
    Map response = await Trade.getTransactionByHash(hash);
    print("第${index}次查询");
    print(response);
    if (response != null && response['blockHash'] != null) {
      print('打包成功，以太坊返回了交易的blockHash');
//      this.showSnackbar('转账成功');
      await this.updateTransferStatus(hash,response['nonce'],response['blockHash']);
    } else {
      if (index > 30) {
        print('已经轮询了30次，打包失败');
        Navigator.pop(context);
//        this.showSnackbar('交易超时');
      } else {
        Future.delayed(Duration(seconds: 2), () {
          this.checkOrderStatus(hash, index + 1);
        });
      }
    }
  }

  Future saveTransfer(String fromAddress, String toAddress, String num,
      String txnHash, Map token,String gas) async {
    var sql = SqlUtil.setTable("transfer");
    String sql_insert =
        'INSERT INTO transfer(fromAddress, toAddress, tokenName, tokenAddress, num,gas, hash ,createTime) VALUES(?, ?, ?, ?, ?, ?, ?, ?)';
    List list = [
      fromAddress,
      toAddress,
      token['name'],
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
