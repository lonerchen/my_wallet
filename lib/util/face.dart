import 'package:flutter/services.dart';

///
/// 百度人脸相关的原生调用
///
class Web3ViewChannel{

  //百度人脸识别的方法
  MethodChannel _channel = const MethodChannel('com.flutter.common/face');

  //初始化百度人脸识别
  String _faceInitMethod = "faceInit";

  //打开人脸识别页面
  String _faceStartMethod = "web3ViewStart";

  ///
  /// 初始化人脸识别库
  ///
  Future<String> faceInit()async{
    String result = await _channel.invokeMethod(_faceInitMethod);
    return result;
  }

  ///
  /// 打开人脸识别页面
  ///
  Future<String> faceStart({chainId,rpcServerUrl,walletAddress,url})async{
    String result = await _channel.invokeMethod(_faceStartMethod,<String,String>{
      "chainId":chainId,
      "rpcServerUrl":rpcServerUrl,
      "walletAddress":walletAddress,
      "url":url
    });
    return result;
  }

}