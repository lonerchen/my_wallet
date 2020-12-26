

import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

class ToastUtils{

  ///
  /// 显示复制成功
  ///
  static showCopyOk(){
    Widget w = Image.asset("images/icon_copy_ok.png",width: 190,height: 130,);
    showToastWidget(w);
  }

}