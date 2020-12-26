

import 'package:flutter/material.dart';
import 'package:youwallet/value/colors.dart';

class BaseWidget{

  ///
  /// ListView中的内容为空
  ///
  static List<Widget> getEmptyWidget(){
    return [
      Container(
        height: 100,
        child: Center(
          child: Text("暂无记录!",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),
          ),
        ),
      )
    ];
  }

  ///
  /// 默认样式的输入框，单行
  ///
  static Widget getDefaultTextField(
    {String hintText = "输入钱包名称",TextEditingController textEditingController}
      ){
    return Container(
      height: 56,
      child: new TextField(
        controller: textEditingController,
        style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99),
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // 设置圆角
              borderSide: BorderSide.none // 设置不要边框
          ),
        ),
      ),
    );
  }

}