
import 'package:flutter/cupertino.dart';
import 'package:youwallet/http/dio_utils.dart';
import 'package:youwallet/http/url.dart';

///
/// 保存在服务器的地址本
///
class AddressBook extends ChangeNotifier{

  //地址分页
  int page = 0;
  List<AddressInfo> addressList = List();

  //地址详情
  AddressInfo addressInfo;

  addAddressBook({String address,int bridge_id,String description})async{
//    await DioUtils.getInstance().post(URL.addAddress,params: <String,dynamic>{
//      "address":address,
//      "bridge_id":bridge_id,
//      "description":description,
//    }).then((value){
//      if(value["code"] == 200) {
//        getAddressList();
//      }
//    });
  }

  getAddressList({int page = 0,int perPage = 50})async{
//    Map response = await DioUtils.getInstance().get(URL.getAddress,params: <String,dynamic>{
//      "page":page,
//      "perPage":perPage,
//    });
//    addressList = AddressInfo.formJsonList(response["data"]);
//    notifyListeners();
  }

  delAddress(int id)async{
//    Map response = await DioUtils.getInstance().delete(URL.deleteAddress,params: <String,dynamic>{
//      "id":id,
//    });
//    if(response["code"] == 200) {
//      await getAddressList();
//    }
  }

  detailsAddress(int id)async{
//    Map response = await DioUtils.getInstance().get(URL.getAddress,params: <String,dynamic>{
//      "id":id,
//    });
//    addressInfo = AddressInfo.fromJson(response["data"]);
//    notifyListeners();
  }

}

class AddressInfo{

  int id;
  String address;//地址
  int bridge_id;//链id
  String description;//可选描述

  AddressInfo(this.address, this.bridge_id, this.description);

  static List<AddressInfo> formJsonList(dynamic jsonList){
    var list = List<AddressInfo>();
    jsonList.forEach((c){
      list.add(new AddressInfo.fromJson(c));
    });
    return list;
  }

  AddressInfo.fromJson(dynamic json) {
    id = json["id"];
    address = json["address"];
    bridge_id = json["bridge_id"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["address"] = address;
    map["bridge_id"] = bridge_id;
    map["description"] = description;
    return map;
  }

}