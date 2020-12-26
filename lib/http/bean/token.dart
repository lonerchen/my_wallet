//登录时请求的实体类
class TokenRequest {

    String client_id = "3";
    String client_secret = "zdg5Ka0VcxPkX4elZZYQY5SN6fxYcvmHIrMWQuDq";
    String grant_type = "password";
    String password = "0";
    String scope = "*";
    String username = "";//只传入该参数即可，助记词的hash值

    ///
    ///username 助记词hash
    ///password 钱包密码
    ///
    TokenRequest({this.username});


    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['client_id'] = this.client_id;
        data['client_secret'] = this.client_secret;
        data['grant_type'] = this.grant_type;
        data['password'] = this.password;
        data['scope'] = this.scope;
        data['username'] = this.username;
        return data;
    }

}