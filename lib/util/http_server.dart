import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youwallet/global.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as httpLib;
import 'package:web3dart/crypto.dart';

class Http {
  static Http instance;
  static String token;
  static Dio _dio;
  BaseOptions _options;

  // 获取实例，如果实例存在就不用新建
  static Http getInstance() {
    if (instance == null) {
      instance = new Http();
    }
    return instance;
  }

  // http类的构造函数
  // 初始化 Options
  Http() {
    _options = new BaseOptions(
      baseUrl: Global.getBaseUrl(),
      // connectTimeout: _config.connectTimeout,
      // receiveTimeout: _config.receiveTimeout,
      headers: {'Content-Type': 'application/json', 'User-Agent': 'youwallet'},
    );

    _dio = new Dio(_options);

    // 请求拦截器
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // Do something before request is sent
      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    }, onResponse: (Response response) async {
      // Do something with response data
      return response; // continue
    }, onError: (DioError e) async {
      // Do something with response error
      return e; //continue
    }));
  }

  // get 请求封装
  get(url, {options, cancelToken}) async {
    print('get:::url：$url ');
    Response response;
    try {
      response = await _dio.get(url, cancelToken: cancelToken);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get请求取消! ' + e.message);
      } else {
        print('get请求发生错误：$e');
      }
    }
    return response.data;
  }

  // post请求封装
  // url还必须有一个默认值
  // 这个跟以太坊进行交互，所有请求的url都是固定的
  // 但是也不能保证后期不会有其他的url进来
  /*
  * 参数说明
  * url     _options中已经配置了baseUrl，它就是一个完整的URL，和以太坊的所有交互都是同一个url
  * params  接口调用时拼接的数据
  * to      合约地址，默认是tempMatchAddress合约,大部分情况下都可以不传
  * method  以太坊的调用函数，默认是eth_call，读操作，不需要gas
   */
  post(
      {url = "",
      options,
      cancelToken,
      params = null,
      to = Global.tempMatchAddress,
      method = 'eth_call'}) async {
    Response response;
    Map data = {
      'jsonrpc': '2.0',
      'method': method,
      'id': DateTime.now().millisecondsSinceEpoch,
      'params': []
    };
    // 调用eth_call，params里面需要加上合约地址，就是参数to
    if (method == 'eth_call') {
      params['to'] = to;
      data['params'] = [params, 'latest'];
    } else {
      data['params'] = params;
    }
    try {
      response = await _dio.post(url, data: data, cancelToken: cancelToken);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get请求取消! ' + e.message);
      } else {
        print('post请求发生错误：$e');
      }
    }
    return response.data;
  }

  /*
  * 发起交易（转账，取消交易，兑换）所有需要写链的操作都可以调用这个接口
  * 参数说明
  * address  token地址
  * obj 燃料费参数
  * postData //转账token的必备参数
  * isEth 转以太坊，false = 转token货币
  */
  transaction(String form,String to, String amount,Map token,Map obj, String postData,{bool isEth = false}) async {
    print('start http server transaction');
    String rpcUrl = Global.getBaseUrl();
    final client = Web3Client(rpcUrl, httpLib.Client());
    final credentials =
        await client.credentialsFromPrivateKey(obj['privateKey']);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int chainId = prefs.getInt("chainId") ?? 3;
    Transaction transaction;
    if(isEth){
      transaction = await createEthereumTransaction(form,to,amount,obj['gasLimit'],obj['gasPrice'],-1,);
    }else{
//      transaction = await createErc20Transaction(form,to,amount,obj['gasLimit'],obj['gasPrice'],-1,token: token);
      transaction = Transaction(
            to: EthereumAddress.fromHex(token["address"]),
            gasPrice: obj['gasPrice'],
            maxGas: obj['gasLimit'],
            value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 0),
            data: hexToBytes(postData));
    }
    var rsp = await client.sendTransaction(
        credentials,
        transaction,
        chainId: chainId // 没有这个参数会报RPCError: got code -32000 with msg "invalid sender".
//        Transaction(
//            to: EthereumAddress.fromHex(address),
//            gasPrice: obj['gasPrice'],
//            maxGas: obj['gasLimit'],
//            value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 0),
//            data: hexToBytes(postData)),

        );
    print("transaction => $rsp");
    return rsp;
  }

  static Future<Transaction> createErc20Transaction(
      String from, String to, String amount, int gasLimit, EtherAmount gasPrice, int nonce,
      {Map token}) async {
    if (token != null) {

      String operationHex =
          '0xa9059cbb000000000000000000000000' + to.toLowerCase().substring(2);
      String valueHex =
      numPow2BigInt(double.parse(amount), int.parse(token["decimals"])).toRadixString(16);
      String tokenHex =
      ('0000000000000000000000000000000000000000000000000000000000000000' +
          valueHex)
          .substring(valueHex.length);
      String dataHex = operationHex + tokenHex;

      Transaction transaction = new Transaction(
        from: EthereumAddress.fromHex(from),
        to: EthereumAddress.fromHex(token["address"]),
        maxGas: gasLimit,
        gasPrice: gasPrice,
        value: EtherAmount.zero(),
        data: hexToBytes(dataHex),
//        nonce: nonce,
      );

      return transaction;
    } else {
      return null;
    }
  }

  static Future<Transaction> createEthereumTransaction( String fromAddress,
      String toAddress, String amount, int gasLimit, EtherAmount gasPrice, int nonce) async {
    print("greate key");
    Transaction transaction = Transaction(
      from: EthereumAddress.fromHex(fromAddress),
      to: EthereumAddress.fromHex(toAddress),
      maxGas: gasLimit,
      gasPrice: gasPrice,

      value: EtherAmount.inWei(numPow2BigInt(double.parse(amount), 18)),
      data: Uint8List(0),
//      nonce: nonce,
    );
    return transaction;
  }

  static BigInt numPow2BigInt(num value, int decimals) {
    String bigValue = (value.toDouble() * pow(10, decimals)).toString();
    print(bigValue);
    BigInt bigIntValue =
    BigInt.parse(bigValue.substring(0, bigValue.indexOf('.')));
    print(bigIntValue);
    return bigIntValue;
  }


}
