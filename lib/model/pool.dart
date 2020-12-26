/// id : 2
/// name : "WIFI"
/// icon : "http://47.97.192.202:8084/adminFile/images/ef7eb17b0c1e63a5bf2ba41c07e40915.jpg"
/// activate_nums : 2000.00000000

class Pool {
  int id;
  String name;
  String icon;
  String activateNums;

  static List<Pool> formJsonList(dynamic jsonList){
    var list = List<Pool>();
    jsonList.forEach((c){
      list.add(Pool.fromMap(c));
    });
    return list;
  }
  static Pool fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Pool poolBean = Pool();
    poolBean.id = map['id'];
    poolBean.name = map['name'];
    poolBean.icon = map['icon'];
    poolBean.activateNums = map['activate_nums'];
    return poolBean;
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "activate_nums": activateNums,
  };
}

class Income {
  int nuclearId;
  String earnings;
  int gainCoinId;
  String options;
  NuclearBean nuclear;
  Gain_coinBean gainCoin;

  static List<Income> formJsonList(dynamic jsonList){
    var list = List<Income>();
    jsonList.forEach((c){
      list.add(Income.fromMap(c));
    });
    return list;
  }

  static Income fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Income poolBean = Income();
    poolBean.nuclearId = map['nuclear_id'];
    poolBean.earnings = map['earnings'];
    poolBean.gainCoinId = map['gain_coin_id'];
    poolBean.options = map['options'];
    poolBean.nuclear = NuclearBean.fromMap(map['nuclear']);
    poolBean.gainCoin = Gain_coinBean.fromMap(map['gain_coin']);
    return poolBean;
  }

  Map toJson() => {
    "nuclear_id": nuclearId,
    "earnings": earnings,
    "gain_coin_id": gainCoinId,
    "options": options,
    "nuclear": nuclear,
    "gain_coin": gainCoin,
  };
}

/// id : 2
/// name : "WIFI"
/// icon : "http://47.97.192.202:8084/adminFile/images/ef7eb17b0c1e63a5bf2ba41c07e40915.jpg"

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
/// title : "繁殖"

class NuclearBean {
  int id;
  String title;

  static NuclearBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    NuclearBean nuclearBean = NuclearBean();
    nuclearBean.id = map['id'];
    nuclearBean.title = map['title'];
    return nuclearBean;
  }

  Map toJson() => {
    "id": id,
    "title": title,
  };
}


/// id : 2
/// slug : "split"
/// title : "分裂"
/// status : 1
/// created_at : "2020-10-08 15:43:02"
/// updated_at : "2020-10-08 15:45:48"

class IncomeType {
  int id;
  String slug;
  String title;
  int status;
  String createdAt;
  String updatedAt;

  static List<IncomeType> formJsonList(dynamic jsonList){
    var list = List<IncomeType>();
    jsonList.forEach((c){
      list.add(IncomeType.fromMap(c));
    });
    return list;
  }

  static IncomeType fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    IncomeType poolBean = IncomeType();
    poolBean.id = map['id'];
    poolBean.slug = map['slug'];
    poolBean.title = map['title'];
    poolBean.status = map['status'];
    poolBean.createdAt = map['created_at'];
    poolBean.updatedAt = map['updated_at'];
    return poolBean;
  }

  Map toJson() => {
    "id": id,
    "slug": slug,
    "title": title,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

