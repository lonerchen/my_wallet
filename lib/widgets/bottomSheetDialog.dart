import 'package:flutter/material.dart';

class BottomSheetDialog extends StatelessWidget {

  List content = []; // modal中的内容
  Function onSuccessChooseEvent;

  // 构造函数
  BottomSheetDialog({
    Key key,
    @required this.content,
    @required this.onSuccessChooseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18)
              ),
              color: Colors.white
            ),
            padding: const EdgeInsets.only(top: 18.0), // 四周填充边距32像素,
            height: 57.0*this.content.length + 18,
            child: Column(
              children: List.generate(this.content.length, (index){
                return buildItem(this.content[index], index,context);
              })
            ),
        );
  }

  Widget buildItem(item,int index ,context) {
    return Container(

      decoration: new BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey,width: 0.5))
      ),
      child: ListTile(
          title: Text(
              index == 0 ? "ETH" : item['name'],
              textAlign: TextAlign.center,
              style: new TextStyle(fontWeight: FontWeight.w700),
          ),
          onTap: () {
            this.onSuccessChooseEvent(item,index);
            Navigator.of(context).pop();
          },
      )
    );
  }

}