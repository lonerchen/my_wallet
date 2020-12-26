class DappTransaction {
  String gas;
  String value;
  String to;
  String data;
  String from;

  DappTransaction({this.gas, this.value, this.to, this.data, this.from});

  DappTransaction.fromJson(Map<String, dynamic> json) {
    gas = json['gas'];
    value = json['value'];
    to = json['to'];
    data = json['data'];
    from = json['from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gas'] = this.gas;
    data['value'] = this.value;
    data['to'] = this.to;
    data['data'] = this.data;
    data['from'] = this.from;
    return data;
  }
}
