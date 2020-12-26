
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:sqflite/utils/utils.dart';

class FormatUtils{

  /// 币价格、数量
  static String coinFormat(num number, {int decimal = 2}) {
    if (number == null) {
      return '';
    }
    Function wrap = (s) => s;
    //增加万位
//    if (number > 10000) {
//      number /= 10000;
//      wrap = (s) => "$s万";
//    }

    String f = "###,##0";
    if (decimal > 0) {
      f += ".";
      for (int i = 0; i < decimal; i++) {
        f += "0";
      }
    }

    try {
      return wrap(NumberFormat(f).format(number));
    } catch (e) {
      return "0.00";
    }
  }

  ///
  /// base64加密
  ///
  static String encodeBase64(String str){
    var content = utf8.encode(str);
    var digest = base64Encode(content);
    return digest;
  }

  ///
  /// base64解密
  ///
  static String decodeBase64(String str){
    return String.fromCharCodes(base64Decode(str));
  }


  ///
  /// md5加密
  ///
  static String encodeMd5(String data){
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex(digest.bytes);
  }

}