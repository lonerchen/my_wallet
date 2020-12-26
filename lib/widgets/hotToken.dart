import 'package:flutter/material.dart';
import 'package:youwallet/global.dart';
import 'package:youwallet/value/colors.dart';

class HotToken extends StatelessWidget {

  final onHotTokenCallBack;
  HotToken({Key key, this.onHotTokenCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: Global.hotToken.map((item) => _buildItem(item)).toList());
  }

  Widget _buildItem(item) {
//    return List.generate(item.length, (index){

    if (item['network'] == Global.getPrefs('network')) {
      return InkWell(
        onTap: (){
          this.onHotTokenCallBack(item);
        },
        child: Container(
          height: 56,
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/icon_eth.png", width: 34, height: 34,),
              SizedBox(width: 16,),
              Container(
                width: 152,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${item["name"]}", style: TextStyle(fontSize: 14,
                        color: MyColors.BLACK_TEXT_22,
                        fontWeight: FontWeight.w600),),
                    Text("${item["address"]}", maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12, color: MyColors.GRAY_TEXT_99,),)
                  ],
                ),
              ),
              Expanded(child: Container(height: 0,),),
              Image.asset("images/icon_remove.png", width: 24, height: 24,),
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
//    });

}
