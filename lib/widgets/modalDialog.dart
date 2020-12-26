import 'package:flutter/material.dart';
import 'package:youwallet/value/colors.dart';

class GenderChooseDialog extends Dialog {
  var title; //modal的标题
  String content = ""; // modal中的内容
  Function onCancelChooseEvent;
  Function onSuccessChooseEvent;

  // 构造函数
  GenderChooseDialog({
    Key key,
    this.title = "提示",
    this.content,
    this.onCancelChooseEvent,
    @required this.onSuccessChooseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.all(24.0),
        child: new Material(
            type: MaterialType.transparency,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      padding:
                          const EdgeInsets.fromLTRB(0, 40.0, 0, 0),
                      decoration: ShapeDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(6.0),
                          ))),
                      margin: const EdgeInsets.all(12.0),
                      child: new Column(children: <Widget>[
                        // 标题区域
                        new Container(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            child: Center(
                                child: new Text(title,
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(fontSize: 14.0,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600)))),
                        // 内容区域
                        new Container(
                          padding: new EdgeInsets.all(10.0),
                          child: new Text(content),
                        ),
                        Divider(height: 1,),
                        // 选择按钮区域
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _buttonChooseItemWid(1),
                              _buttonChooseItemWid(2)
                            ])
                      ]))
                ])));
  }

  Widget _buttonChooseItemWid(var gender) {
    return Expanded(
      child: GestureDetector(
          onTap: () {
            // 这里调用回调函数必须是函数名字+()
            if (gender == 1) {
              print(gender);
              this.onCancelChooseEvent();
            } else {
              print(gender);
              this.onSuccessChooseEvent();
            }
          },
          child: Container(
            height: 47,
            color: gender == 1 ? MyColors.THEME_COLORS : Colors.white,
            child: Center(
              child: Text(gender == 1 ? '取消' : '确定',
                  style: TextStyle(
                      color: gender == 1 ? Colors.white : Colors.grey,
                      fontSize: 15.0)),
            ),
          )),
    );
  }
}
