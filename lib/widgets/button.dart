import 'package:flutter/material.dart';
import 'package:youwallet/value/colors.dart';

class BaseButton{

  ///
  /// 主题色的按钮
  ///
  Widget getBaseButton({
    @required String text,
    double fontSize = 14,
    String img,
    double width = 345,
    double height = 56,
    Color color = MyColors.THEME_COLORS,
    Color disabledColor = MyColors.BUTTON_DISABLE,
    @required VoidCallback onPressed,}
  ){
    return Container(
      width: width,
      height: height,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(6)
            )
        ),
        onPressed: onPressed,
        splashColor: color,
        color: color,
        disabledColor: disabledColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            img == null ?
                Container(height:0):Image.asset("$img",width: 17,height: 17,),
            SizedBox(width: 6,),
            Text(
              "$text",
              style: TextStyle(color: Colors.white, fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }

}

