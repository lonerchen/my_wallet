
import 'package:flutter/material.dart';
import 'package:youwallet/model/Message.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';

class MessageDetailsPage extends StatefulWidget {

  final Message message;

  MessageDetailsPage(this.message);

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppBar().getBaseAppBarWhite("公告"),
      body: Container(
        color: MyColors.THEME_COLORS,
        child: Stack(
          children: [
            _buildBackGround(),
          ],
        ),
      ),
    );
  }


  Widget _buildBackGround(){
    return Container(
      margin: EdgeInsets.only(top: 39),
      padding: EdgeInsets.only(left: 15,right: 15,top: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18),topRight: Radius.circular(18)),
          color: Colors.white
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(widget.message.avatar,width: 38,height: 38,),
                SizedBox(width: 10,),
                Text(widget.message.name,style: TextStyle(color:MyColors.BLACK_TEXT_22,fontSize: 16 ),),
                Expanded(child: Container(height: 0,)),
                Text(widget.message.date,style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 12),),

              ],
            ),
            SizedBox(height: 21,),
            Text(widget.message.title,style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 16),),
            SizedBox(height: 20,),
            Text(widget.message.content,style: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 14),),
          ],
        ),
      ),
    );
  }

}
