
//小程序类
class Dapp{

  int id;
  String name;
  String img;
  String url;
  int status;
  String created_at;
  String updated_at;

  Dapp({this.id,this.name, this.img, this.url, this.status, this.created_at,
      this.updated_at});

  static List<Dapp> formJsonList(dynamic jsonList){
    var list = List<Dapp>();
    jsonList.forEach((c){
      list.add(Dapp.fromJson(c));
    });
    return list;
  }

  Dapp.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    img = json["img"];
    url = json["url"];
    status = json["status"];
    created_at = json["created_at"];
    updated_at = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["img"] = img;
    map["url"] = url;
    map["status"] = status;
    map["created_at"] = created_at;
    map["updated_at"] = updated_at;
    return map;
  }
  
}