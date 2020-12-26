
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/http/bean/token.dart';
import 'package:youwallet/http/dio_utils.dart';
import 'package:youwallet/http/url.dart';
import 'package:youwallet/model/token.dart';
import 'package:youwallet/model/wallet.dart';

///
/// 验证类
///
class AccountToken{

    String access_token;
    int expires_in;
    String refresh_token;
    String token_type;

    AccountToken();

    AccountToken.fromJson(dynamic json) {
        this.token_type = json["token_type"];
        this.expires_in = json["expires_in"];
        this.access_token = json["access_token"];
        this.refresh_token = json["refresh_token"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['access_token'] = this.access_token;
        data['expires_in'] = this.expires_in;
        data['refresh_token'] = this.refresh_token;
        data['token_type'] = this.token_type;
        return data;
    }

    ///
    /// 钱包的助记词还有密码
    ///
    static Future getAccountToken(String mnemonic) async {
//        Map accountMap = await DioUtils.getInstance().post("${URL.login}",body:new TokenRequest(username:mnemonic ).toJson());
//        var accountToken = AccountToken.fromJson(accountMap);
//        Global.accountToken = accountToken.access_token;
    }

}

