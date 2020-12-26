

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:youwallet/global.dart';

///
/// 拦截器 用来打印错误
///
class DefaultInterceptor extends InterceptorsWrapper{

  @override
  Future onRequest(RequestOptions options) {
    print("DIO请求：url = ${options.uri} 参数 = ${options.queryParameters}");
    print("DIO请求：url = ${options.uri} Body = ${options.data}");
    //如果AccountToken不为空的话，就使用该token进行请求
    if(Global.accountToken != "") {
      options.headers.addAll(<String, dynamic>{
        "Authorization": "Bearer ${Global.accountToken}",
//        "Token": Global.accountToken,
        "Access-Control-Allow-Headers": "Origin, Content-Type, Cookie,X-CSRF-TOKEN, Accept,Authorization, X-XSRF-TOKEN, X-Requested-With",
      });
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print("DIO返回：responseData = ${response.data}");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print("DIO错误：errResponse = ${err.response}");
    showToast("${err.type.index} : ${err.message} : ${err.response?.toString()}");
    return super.onError(err);
  }

}