

import 'package:flutter/material.dart';
import 'package:youwallet/model/Message.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';

import 'message_details.dart';

///
/// 消息页/公告页面
///
class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  List<Message> messageList =[Message(),Message(),Message(),Message(),Message(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBarWhite("公告"),
      body: Container(
        color: MyColors.THEME_COLORS,
        child: Stack(
          children: [
            _buildBackGround(),
            _buildList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackGround(){
    return Container(
      margin: EdgeInsets.only(top: 39),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
          color: Colors.white
      ),
    );
  }

  Widget _buildList(){
    return Container(
      margin: EdgeInsets.only(top: 60),
      child: ListView(
        children: messageList.length > 0 ? _buildItem() : BaseWidget.getEmptyWidget() ,
      ),
    );
  }

  List<Widget> _buildItem(){
    return List.generate(messageList.length, (index){
      return InkWell(
        onTap: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context){
              return MessageDetailsPage(messageList[index]);
            })
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 60,
          decoration: BoxDecoration(
            color: Color.fromARGB(0xff, 0xfa, 0xfa, 0xfa),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${messageList[index].title}",style: TextStyle(fontSize:14,color: MyColors.BLACK_TEXT_22),),
              SizedBox(height: 5,),
              Text("2020.09.05",style: TextStyle(fontSize:12,color: MyColors.GRAY_TEXT_99),),
            ],
          ),
        ),
      );
    });
  }

}
