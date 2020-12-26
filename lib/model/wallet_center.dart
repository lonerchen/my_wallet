
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:youwallet/http/dio_utils.dart';
import 'package:youwallet/http/url.dart';

///
/// 中心化钱包
///

class WalletCenter  extends ChangeNotifier {

  //当前钱包的支持的币种类型
  List<WalletCenterToken> walletCenterTokenList = List();

  //当前选中的币种详情
  WalletCenterDetails currentWalletCenter;

  getWalletCenter({int id = -1}) async{
//    Map response = await DioUtils.getInstance().post(URL.accounts);
//    walletCenterTokenList = WalletCenterToken.formJsonList(response["data"]);
//    if(walletCenterTokenList.length > 0 && currentWalletCenter == null) {
//      Map responseDetails = await DioUtils.getInstance().post(
//          URL.accountDetails, params: <String, dynamic>{
//        "id":walletCenterTokenList[0].id,
//      });
//      currentWalletCenter = WalletCenterDetails.fromJson(responseDetails["data"]);
//    }else{
//      //更新一下选中钱包
//      await changeWalletCenter(currentWalletCenter.id);
//    }
    notifyListeners();
  }

  ///
  /// 切换中心化钱包
  ///
  changeWalletCenter(int id) async{
//    if(walletCenterTokenList.length > 0) {
//      Map responseDetails = await DioUtils.getInstance().post(
//          URL.accountDetails, params: <String, dynamic>{
//        "id":id,
////        "id":walletCenterTokenList[index].id,
//      });
//      currentWalletCenter = WalletCenterDetails.fromJson(responseDetails["data"]);
//    }
    notifyListeners();
  }

  ///
  /// 转账
  ///
  transfer(String formAddress,String toAddress,double amount,int coinId)async{
//    Map response = await DioUtils.getInstance().post(URL.transaction,params: <String,dynamic>{
//      "fromAddress":formAddress,
//      "toAddress":toAddress,
//      "amount":amount,
//      "coinId":coinId,
//    });
//    if(response["code"] == 200){
//      showToast("转账成功！");
//      await getWalletCenter();
//    }
  }


  ///
  /// 质押
  ///
  pledgeCoin(double amount,int coinId)async{
//    Map response = await DioUtils.getInstance().post(URL.deposit,params: <String,dynamic>{
//      "amount":amount,
//      "coinId":coinId
//    });
//    if(response["code"] == 200){
//      showToast("质押成功");
//      await getWalletCenter();
//    }
    
  }

  ///
  /// 获取币种列表
  ///
  getCoinList()async{
//    Map response = await DioUtils.getInstance().get(URL.getCoinList);
//    print("币种类型$response");
  }

  ///
  /// 根据id来取得币详情
  ///
  WalletCenterToken getCoin(int coinId){
    WalletCenterToken walletCenterToken = null;
    walletCenterTokenList.forEach((element) {
      if(element.coinId == coinId) {
        walletCenterToken = element;
      }
    });
    return walletCenterToken;
  }

  ///
  /// 
  ///

}


///
/// 中心化钱包账户列表
///
class WalletCenterToken {

  int id;
  int userId;
  int coinId;//币种id
  String name;//币种名字
  String icon;//币种图片
  String rmb;//换算成人民币
  String balance;//余额
  String freeze;//冻结
  String earning;//总收入
  String expend;//总花费
  int status;//网体状态{0。未激活，1。已激活}
  int nuclearActivated;//是否激活核反应（0：未激活 1：已激活）
  int teamId;//团队ID（团长的用户id）
  int slug;//用户标识 （用户标示：0普通用户 1团队长 2创世用户）

  WalletCenterToken(
      {this.id,
        this.userId,
        this.coinId,
        this.name,
        this.icon,
        this.rmb,
        this.balance,
        this.freeze,
        this.earning,
        this.expend,
        this.status,
        this.nuclearActivated,
        this.teamId,
        this.slug});

  static List<WalletCenterToken> formJsonList(dynamic json){
    var list = List<WalletCenterToken>();
    json.forEach((c){
      list.add(new WalletCenterToken.fromJson(c));
    });
    return list;
  }

  WalletCenterToken.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    coinId = json['coin_id'];
    name = json['name'];
    icon = json['icon'];
    rmb = json['rmb'];
    balance = json['balance'];
    freeze = json['freeze'];
    earning = json['earning'];
    expend = json['expend'];
    status = json['status'];
    nuclearActivated = json['nuclear_activated'];
    teamId = json['team_id'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['coin_id'] = this.coinId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['rmb'] = this.rmb;
    data['balance'] = this.balance;
    data['freeze'] = this.freeze;
    data['earning'] = this.earning;
    data['expend'] = this.expend;
    data['status'] = this.status;
    data['nuclear_activated'] = this.nuclearActivated;
    data['team_id'] = this.teamId;
    data['slug'] = this.slug;
    return data;
  }
}


///
/// 中心化钱包账户详情
///
class WalletCenterDetails {
  int id;
  int userId;
  int coinId;
  String name;//币种名字
  String icon;//币种图片
//  String rmb;//换算成人民币
  String secret;//账户私钥
  String address;//账户地址
  String balance;
  String freeze;
  String earning;
  String expend;
  int status;
  int nuclearActivated;
  int parentId;
  String parentLink;
  int teamId;
  String slug;
  String createdAt;
  String updatedAt;

  WalletCenterDetails(
      {this.id,
        this.userId,
        this.coinId,
        this.name,
        this.icon,
        this.secret,
        this.address,
        this.balance,
        this.freeze,
        this.earning,
        this.expend,
        this.status,
        this.nuclearActivated,
        this.parentId,
        this.parentLink,
        this.teamId,
        this.slug,
        this.createdAt,
        this.updatedAt});

  WalletCenterDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    coinId = json['coin_id'];
    name = json['name'];
    icon = json['icon'];
//    rmb = json['rmb'];
    secret = json['secret'];
    address = json['address'];
    balance = json['balance'];
    freeze = json['freeze'];
    earning = json['earning'];
    expend = json['expend'];
    status = json['status'];
    nuclearActivated = json['nuclear_activated'];
    parentId = json['parent_id'];
    parentLink = json['parent_link'];
    teamId = json['team_id'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    print(this);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['coin_id'] = this.coinId;
    data['name'] = this.name;
    data['icon'] = this.icon;
//    data['rmb'] = this.rmb;
    data['secret'] = this.secret;
    data['address'] = this.address;
    data['balance'] = this.balance;
    data['freeze'] = this.freeze;
    data['earning'] = this.earning;
    data['expend'] = this.expend;
    data['status'] = this.status;
    data['nuclear_activated'] = this.nuclearActivated;
    data['parent_id'] = this.parentId;
    data['parent_link'] = this.parentLink;
    data['team_id'] = this.teamId;
    data['slug'] = this.slug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
