/// id : 1
/// slug : "breed"
/// title : "繁殖"
/// status : 1
/// created_at : "2020-10-08 15:42:42"
/// updated_at : "2020-10-08 15:45:32"

class Income {
  int _id;
  String _slug;
  String _title;
  int _status;
  String _createdAt;
  String _updatedAt;

  int get id => _id;
  String get slug => _slug;
  String get title => _title;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Income({
      int id, 
      String slug, 
      String title, 
      int status, 
      String createdAt, 
      String updatedAt}){
    _id = id;
    _slug = slug;
    _title = title;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  static List<Income> formJsonList(dynamic jsonList){
    var list = List<Income>();
    jsonList.forEach((c){
      list.add(new Income.fromJson(c));
    });
    return list;
  }

  Income.fromJson(dynamic json) {
    _id = json["id"];
    _slug = json["slug"];
    _title = json["title"];
    _status = json["status"];
    _createdAt = json["createdAt"];
    _updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["slug"] = _slug;
    map["title"] = _title;
    map["status"] = _status;
    map["createdAt"] = _createdAt;
    map["updatedAt"] = _updatedAt;
    return map;
  }

}