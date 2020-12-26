/// id : 24
/// user_id : 1
/// earnings : "1.93051374"
/// gain_coin_id : 3
/// user : {"id":1,"name":"测试用户"}
/// gain_coin : {"id":3,"name":"CND","icon":"http://192.168.1.249/adminFile/images/timg.jpg"}

class Top10 {
  int id;
  int userId;
  String earnings;
  int gainCoinId;
  UserBean user;
  Gain_coinBean gainCoin;

  static List<Top10> formJsonList(dynamic jsonList){
    var list = List<Top10>();
    jsonList.forEach((c){
//      list.add(new Top10.fromMap(c));
    });
    return list;
  }

  static Top10 fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Top10 top10Bean = Top10();
    top10Bean.id = map['id'];
    top10Bean.userId = map['user_id'];
    top10Bean.earnings = map['earnings'];
    top10Bean.gainCoinId = map['gain_coin_id'];
    top10Bean.user = UserBean.fromMap(map['user']);
    top10Bean.gainCoin = Gain_coinBean.fromMap(map['gain_coin']);
    return top10Bean;
  }

  Map toJson() => {
    "id": id,
    "user_id": userId,
    "earnings": earnings,
    "gain_coin_id": gainCoinId,
    "user": user,
    "gain_coin": gainCoin,
  };
}

/// id : 3
/// name : "CND"
/// icon : "http://192.168.1.249/adminFile/images/timg.jpg"

class Gain_coinBean {
  int id;
  String name;
  String icon;

  static Gain_coinBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Gain_coinBean gain_coinBean = Gain_coinBean();
    gain_coinBean.id = map['id'];
    gain_coinBean.name = map['name'];
    gain_coinBean.icon = map['icon'];
    return gain_coinBean;
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
  };
}

/// id : 1
/// name : "测试用户"

class UserBean {
  int id;
  String name;

  static UserBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserBean userBean = UserBean();
    userBean.id = map['id'];
    userBean.name = map['name'];
    return userBean;
  }

  Map toJson() => {
    "id": id,
    "name": name,
  };
}