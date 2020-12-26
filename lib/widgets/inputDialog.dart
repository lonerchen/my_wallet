import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:youwallet/value/colors.dart';

class InputDialog extends Dialog {

  var title; //modal的标题
  String hintText = ""; // modal中的内容
  TextEditingController controller;
  Function onCancelChooseEvent;
  Function onSuccessChooseEvent;
  TextEditingController _input = TextEditingController();

  // 构造函数
  InputDialog({
    Key key,
    this.title = "提示",
    this.hintText = "",
    @required this.controller,
    @required this.onCancelChooseEvent,
    @required this.onSuccessChooseEvent,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.all(48.0),
        child: new Material(
            type: MaterialType.transparency,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      padding: const EdgeInsets.fromLTRB(
                          0.0, 20.0, 0.0, 0.0),
                      decoration: ShapeDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ))),
                      margin: const EdgeInsets.all(12.0),
                      child: new Column(children: <Widget>[
                        // 标题区域
                        new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 0.0, 10.0, 10.0),
                            child: Center(
                                child: new Text(title,
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                    )))),
                        // 内容区域
                        new Container(
                          decoration: new BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black26,
                                      width: 1.0
                                  ) // 只设置顶部边框
                              )
                          ),
                          child: new TextField(
                            controller: this.controller == null ? _input : this.controller,
//                            controller: this._input,
                            decoration: InputDecoration(
                              hintText: this.hintText,

                              border: OutlineInputBorder(
                                // borderSide: BorderSide(color: Colors.grey),
                                  borderSide: BorderSide.none
                              ),
//                              focusedBorder: OutlineInputBorder(
//                                borderSide: BorderSide(color: Colors.grey),
//                              ),
                            ),
                          ),
                        ),
                        // 选择按钮区域
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _buttonChooseItemWid(context,1),
                              _buttonChooseItemWid(context,2)
                            ])
                      ])
                  )
                ]
            )
        )
    );
  }

  Widget _buttonChooseItemWid(BuildContext context, var gender) {
    return Expanded(
      child: InkWell(
          onTap: onCancelChooseEvent != null && this.onSuccessChooseEvent !=null ?
          gender == 1 ? this.onCancelChooseEvent : this.onSuccessChooseEvent :(){
            if(gender == 2) {
              if (_input.text.length >= 8 && _input.text.length <= 20) {
                Navigator.pop(context, _input.text);
              }else{
                showToast("请输入8～20位数的密码");
              }
            }else{
              Navigator.pop(context);
            }
          },
          child: Container(
            alignment: Alignment.center,
            // width: MediaQuery.of(context).size.width*0.5,
            height: 47,
            decoration: BoxDecoration(
              borderRadius: gender == 1 ? BorderRadius.only(bottomLeft: Radius.circular(8)) : BorderRadius.only(bottomRight: Radius.circular(8)),
              color: gender == 1 ? MyColors.THEME_COLORS: Colors.white,
            ),
            child: Text(gender == 1 ? '取消' : '确定',
                style: TextStyle(
                    color: gender == 1 ? Colors.white: MyColors.GRAY_TEXT_99,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700
                )
            ),
          )
      ),
    );
  }

}