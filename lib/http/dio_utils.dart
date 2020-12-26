

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:youwallet/http/url.dart';

import 'interceptor.dart';

///
/// http_server 用来处理去中心化钱包逻辑
/// 使用这块来处理我们自己服务器的逻辑
///
class DioUtils{


  static DioUtils _instance;
  static Dio _dio;
  BaseOptions _options;

  //单例实现
  DioUtils._(){
    print("初始化网络请求工具");
    _options = new BaseOptions(
      baseUrl: URL.BASE_URL,
       connectTimeout: 30000,
      // receiveTimeout: _config.receiveTimeout,
      headers: {'Content-Type': 'application/json', 'User-Agent': 'youwallet'},

    );

    _dio = new Dio(_options);
    _dio.interceptors.add(DefaultInterceptor());
  }

  static DioUtils getInstance(){
    if(_instance == null){
      _instance = DioUtils._();
    }
    return _instance;
  }

  ///
  /// post请求
  ///
  ///
  Future<Map<dynamic,dynamic>> post(
      String url,
      {
        //url后面带着的参数
        Map<String,dynamic> params,
        //上传文件的body，或者实体类body
        Map<String,dynamic> body,
        //拦截异常处理,不传默认弹出一个toast
        Function onError,
      })async{
    RequestOptions options = new RequestOptions(method:"POST");
    options.data = json.encode(body);
    var result;
    try{
      result = await _dio.post(url,queryParameters: params,options: options);
    }catch(e){
      onError.call();
    }
    return result.data;
  }

  ///
  /// get请求
  ///
  ///
  Future<Map<dynamic,dynamic>> get(
      String url,
      {
        //url后面带着的参数
        Map<String,dynamic> params,
        //拦截异常处理,不传默认弹出一个toast
        Function onError,
      })async{
    var result;
    try{
      result = await _dio.get(url,queryParameters: params);
    }catch(e){
      onError.call();
    }
    return result.data;
  }

  ///
  /// post请求
  ///
  Future<Map<dynamic,dynamic>> delete(
      String url,
      {
        //url后面带着的参数
        Map<String,dynamic> params,
        //拦截异常处理,不传默认弹出一个toast
        Function onError,
      })async{
    var result;
    try{
      result = await _dio.delete(url,queryParameters: params);
    }catch(e){
      onError.call();
    }
    return result.data;
  }


  ///
  /// post上传
  ///
  ///
  Future<Map<dynamic,dynamic>> postUpload(
      String url,
      {
        //url后面带着的参数
        File flle,
        Function onError,
      })async{
    var postData = FormData.fromMap(
        {"portrait": await MultipartFile.fromFile(flle.path, filename: flle.path)});//file是服务端接受的字段字段，如果接受字段不是这个需要修改
    var option = Options(method: "POST", contentType: "multipart/form-data");//上传文件的content-type 表单

    var result;
    try{
      result = await _dio.post(url,options: option,data: postData);
    }catch(e){
      onError.call();
    }
    return result.data;
  }

  ///
  /// 显示加载dialog
  ///
  showLoading(){

  }

}