
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youwallet/model/network.dart';
import 'package:youwallet/pages/tabs/tab_defi.dart';
import 'package:youwallet/util/number_format.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/app_bar.dart';

class TranslateDetailsPage extends StatefulWidget {

  final Map translate;

  TranslateDetailsPage(this.translate);

  @override
  _TranslateDetailsPageState createState() => _TranslateDetailsPageState();

}

class _TranslateDetailsPageState extends State<TranslateDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar("详情"),
      body: Container(
        child: Column(
          children: [
            _buildTitle(),
            SizedBox(height: 20,),
            _buildInfo(),
            SizedBox(height: 20,),
            _buildTranslateInfo(),
            SizedBox(height: 20,),
            _buildWebsite(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(left: 15,right: 15,top: 15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Image.asset("images/icon_success.png"),
          SizedBox(height: 13,),
          Text("${widget.translate["status"]}",style: TextStyle(fontSize: 16,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
          SizedBox(height: 9,),
          Text("${DateUtil.formatDateMs(int.parse(widget.translate["createTime"]))}",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
          SizedBox(height: 19,),
        ],
      ),
    );
  }

  Widget _buildInfo(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(left: 15,right: 15),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 15,),
          Row(
            children: [
              Container(
                width: 80,
                child: Text("金额",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
              ),
              Text("${widget.translate["num"]} ${widget.translate["tokenName"]}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
            ],
          ),
          SizedBox(height: 15,),
//          Row(
//            children: [
//              Container(
//                width: 80,
//                child: Text("矿工费",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
//              ),
//              Column(
//                children: [
//                  Text("${widget.translate["gas"]}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
////                  Text("${widget.translate["gasLimit"]}",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
//                ],
//              ),
//            ],
//          ),
//          SizedBox(height: 15,),
          Row(
            children: [
              Container(
                width: 80,
                child: Text("收款地址：",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
              ),
              Text("${NumberFormat.addressFormat(widget.translate["toAddress"])}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
              InkWell(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: widget.translate["toAddress"]??""));
                  showToast("拷贝成功!");
                },
                child: Image.asset("images/icon_copy.png",width: 14,height: 14,),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Container(
                width: 80,
                child: Text("收款地址：",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
              ),
              Text("${NumberFormat.addressFormat(widget.translate["fromAddress"])}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
              InkWell(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: widget.translate["fromAddress"]??""));
                  showToast("拷贝成功!");
                },
                child: Image.asset("images/icon_copy.png",width: 14,height: 14,),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Container(
                width: 80,
                child: Text("备注：",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
              ),
              Text("",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
            ],
          ),
          SizedBox(height: 15,),
        ],
      ),
    );
  }

  Widget _buildTranslateInfo(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(left: 15,right: 15),
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: Row(
        children: [

          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text("交易号：",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                    ),
                    Text("${NumberFormat.addressFormat(widget.translate["hash"])}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
                    InkWell(
                      onTap: (){
                        Clipboard.setData(ClipboardData(text: widget.translate["hash"]??""));
                        showToast("拷贝成功!");
                      },
                      child: Image.asset("images/icon_copy.png",width: 14,height: 14,),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Container(
                      width: 80,
                      child: Text("区块：",style: TextStyle(fontSize: 12,color: MyColors.GRAY_TEXT_99),),
                    ),
                    Text("${widget.translate["nonce"]}",style: TextStyle(fontSize: 12,color: MyColors.BLACK_TEXT_22),),
                  ],
                ),
              ],
            ),
          ),
          QrImage(data: widget.translate["hash"],size: 80,),
        ],
      ),
    );
  }

  Widget _buildWebsite(){
    return InkWell(
      onTap: (){
        _launchURL(widget.translate["hash"]);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset("images/icon_eth_website.png",width: 14,height: 14,),
              Text("到Etherscan查询更详细信息",style: TextStyle(fontSize: 12,color: MyColors.THEME_COLORS),),
            ],
          )
      ),
    );
  }

  _launchURL(hash) async {
    String network = Provider.of<Network>(context).network;
    String url = 'https://$network.etherscan.io/tx/$hash';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}