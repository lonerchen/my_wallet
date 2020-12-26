

import 'package:flutter/material.dart';
import 'package:youwallet/value/colors.dart';

class BaseAppBar extends AppBar implements PreferredSizeWidget {

  //头部扩展，支持action文本和自定义大小控件
  AppBar getBaseAppBar(String title,{Color color,List<Widget> actions}){
    return AppBar(
      title: Text(title,style: TextStyle(color:MyColors.BLACK_TEXT_1F,fontSize: 18),),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            iconSize: 18,
            icon: const Icon(Icons.keyboard_arrow_left,size:22,color:MyColors.BLACK_TEXT_1F,),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      actions: actions,
      centerTitle: true,
      backgroundColor: color != null ? color : Colors.white,
      elevation: 0,
    );
  }

  //头部扩展，白色字体
  AppBar getBaseAppBarWhite(String title,{Color color,List<Widget> actions}){
    return AppBar(
      title: Text(title,style: TextStyle(color:Colors.white,fontSize: 18),),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            iconSize: 18,
            icon: const Icon(Icons.keyboard_arrow_left,size:22,color:Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      actions: actions,
      centerTitle: true,
      backgroundColor: color != null ? color : MyColors.THEME_COLORS,
      elevation: 0,
    );
  }

}