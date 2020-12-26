import 'package:flutter/material.dart';
import 'package:youwallet/bus.dart';

class CustomTab extends StatefulWidget {
  List buttons = [];
  String activeIndex;

  CustomTab({
    Key key,
    @required this.activeIndex, // 激活第几个tab
    @required this.buttons,
  }) : super(key: key);

  Page createState() => new Page();
}

class Page extends State<CustomTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: const EdgeInsets.only(bottom: 12.0), // 四周填充边距32像素
        child: new Row(
            children: widget.buttons
                .map((item) => buildItem(item, context))
                .toList()));
  }

  Widget buildItem(item, context) {
    return new Container(
      padding: const EdgeInsets.all(10.0), // 四周填充边距32像素
      decoration: new BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: widget.activeIndex == item
                    ? Colors.lightBlue
                    : Colors.transparent,
                width: 1.0)),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.activeIndex = item;
          });
          eventBus.fire(CustomTabChangeEvent(item));
        }, //写入方法名称就可以了，但是是无参的
        child: new Text(item,
            style: TextStyle(
                color: widget.activeIndex == item
                    ? Colors.lightBlue
                    : Colors.grey)),
      ),
    );
  }
}
