
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/http/dio_utils.dart';
import 'package:youwallet/http/url.dart';

class UserInfo extends ChangeNotifier{



  int id;//用户头像
  String name;//用户名称
  String portrait;//用户头像
  String hash;//助记词hash值
  String loginIp;
  int status;
  String createdAt;
  String updatedAt;

  UserInfo(){
    if(Global.accountToken != ""){
      getUserInfo();
    }
  }


  fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    portrait = json["portrait"];
    hash = json["hash"];
    status = json["status"];
    loginIp = json["loginIp"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["portrait"] = portrait;
    map["hash"] = hash;
    map["status"] = status;
    map["loginIp"] = loginIp;
    map["createdAt"] = createdAt;
    map["updatedAt"] = updatedAt;
    return map;
  }

  ///
  /// 获取用户资料
  ///
  Future getUserInfo() async {
//    Map accountMap = await DioUtils.getInstance().post("${URL.userInfo}");
//    fromJson(accountMap["data"]);
//    notifyListeners();
  }

  ///
  /// 更新用户资料
  ///
  Future saveUserInfo({File fileBase64,String name}) async{
    var data;
//    if(fileBase64 != null){
//      data = await DioUtils.getInstance().postUpload("${URL.profile}",flle: fileBase64);
//    }else{
//      data = await DioUtils.getInstance().post("${URL.profile}",body: <String,dynamic>{
//        "name":name
//      });
//    }
//    print(data);
  }


}

