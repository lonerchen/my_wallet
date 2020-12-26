import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/model/network.dart';
import 'package:youwallet/model/wallet.dart';
import 'package:youwallet/pages/wallet/erc20_transfer.dart';
import 'package:youwallet/pages/wallet/eth_transfer.dart';

class DAppWebViewPage extends StatefulWidget{
  String url;
  String firstUrl; //进来加载的第一个url
  String title = "";

  bool isBack = false;

  bool isScrollHint = false;

  @override
  _DAppWebViewPageState createState() => _DAppWebViewPageState();

  DAppWebViewPage(this.url);
}

class _DAppWebViewPageState extends State<DAppWebViewPage>{
  
  WebViewController _webViewController; // 添加一个controller

  ///
  /// 交易eth主币
  ///
  JavascriptChannel signTransaction(BuildContext context) => JavascriptChannel(
      name: 'signTransaction', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print("js:signTransaction = " + message.message);
        var messageList = message.message.split("#");
        var id = messageList[0];
        List<String> dataList = messageList[1].split(",");
        if(dataList.length > 3) {
          //data.gas+","+data.value+","+data.to+","+data.data+","+data.gasPrice
//          var gas = dataList[0];
//          var value = dataList[1];
//          var to = dataList[2];
//          var data = dataList[3];
//          var gasPrice = dataList[4];
//          Navigator.push(context,
//              MaterialPageRoute(builder: (context) => EthTransferPage(gas,value,to,data,gasPrice))).then((value) async {
//            //交易成功，返回hash
//            if (value != null && value.lenght > 10) {
//              String responseString = "window.ethereum.sendResponse($id, ['$value'])";
//              await _webViewController.evaluateJavascript(responseString).then((value) {
//                print(value);
//              });
//            }else{
//              String errorString = "window.ethereum.sendError($id,[])";
//              await _webViewController.evaluateJavascript(errorString).then((value) {
//                print(value);
//              });
//            }
//          });
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
        List<String> dataList = messageList[1].split(",");
        if(dataList.length > 3) {
          //data.gas+","+data.to+","+data.data+","+data.gasPrice
          var gas = dataList[0];
          var to = dataList[0];
          var data = dataList[0];
          var gasPrice = dataList[0];

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Erc20TransferPage())).then((value) async {
            //交易成功，返回hash
            if (value != null && value.lenght > 10) {
              String responseString = "window.ethereum.sendResponse($id, ['$value'])";
              await _webViewController.evaluateJavascript(responseString).then((value) {
                print(value);
              });
            }else{
              String errorString = "window.ethereum.sendError($id,[])";
              await _webViewController.evaluateJavascript(errorString).then((value) {
                print(value);
              });
            }
          });
        }


      });

  ///
  /// h5请求信息
  ///
  JavascriptChannel eth_requestAccounts(BuildContext context) => JavascriptChannel(
      name: 'eth_requestAccounts', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        Wallet wallet = Provider.of<Wallet>(context);
        String address = wallet.currentWalletObject["address"];
        print("js:eth_requestAccounts = " + message.message);
        var messageList = message.message.split("#");
        var id = messageList[0];
        String responseString = "window.ethereum.sendResponse(${messageList[0]}, ['$address'])";
//        String errorString = "window.ethereum.sendError(${messageList[0]},[])";
        await _webViewController.evaluateJavascript(responseString).then((value) {
          print(value);
        });

      });

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: null,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Container(
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.black87, fontSize: 18),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              iconSize: 18,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
              ),
              onPressed: () {
                _webViewController.canGoBack().then((isBack) {
                  if (isBack) {
                    _webViewController.goBack();
                  } else {
                    Navigator.pop(context);
                  }
                });
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Consumer2<Wallet,Network>(
        builder: (context,wallet,network,child) => Container(
//          color: Colors.blue,
          child: WebView(
            initialUrl: widget.url,
            // 加载的url
//          userAgent:"random", // h5 可以通过navigator.userAgent判断当前环境
            gestureNavigationEnabled: true,
//          debuggingEnabled: true,
            javascriptMode: JavascriptMode.unrestricted,
            // 启用 js交互，默认不启用JavascriptMode.disabled
            javascriptChannels: <JavascriptChannel>[
              signTransaction(context),
              signErc20Transaction(context),
              eth_requestAccounts(context),
              
            ].toSet(),
            onWebViewCreated: (WebViewController web) {
              _webViewController = web;
              _webViewController.getTitle().then((title) {
                print(title);
                setState(() {
                  widget.title = title.replaceAll("\"", "");
                });
              });
              if (widget.firstUrl == null) {
                _webViewController.currentUrl().then((url) {
                  widget.firstUrl = url;
                });
              }
            },

            onPageFinished: (String value) async {
              // webView 页面加载调用
              // flutter 调用h5 端方法
              await _webViewController
                  .evaluateJavascript('document.title')
                  .then((title) {
                // 获取网页title
                setState(() {
                  widget.title = title.replaceAll("\"", "");
                });
              });
              await _webViewController.canGoBack().then((value) {
                setState(() {
                  widget.isBack = value;
                });
              });
              
              //web3provider注入
              String rpcurl = await Global.getBaseUrl();
              String address = wallet.currentWalletObject["address"];
              String chainId = "${network.chainId}";
              String js = await rootBundle.loadString("assets/trust.js");
              String js1 = await rootBundle.loadString("assets/init.js");
              js1 = js1.replaceFirst("\$rpcurl", rpcurl);
              js1 = js1.replaceFirst("\$address", address);
              js1 = js1.replaceFirst("\$chainId", chainId);
              await _webViewController.evaluateJavascript(js).then((value){
                print(value);
              });
              await _webViewController.evaluateJavascript(js1).then((value){
                print(value);
              });

            },
          ),
        ),
      ),
    );
  }

}


