
import 'package:flutter/material.dart';
import 'package:youwallet/model/Integral.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';

///
/// 积分钱包
///

class IntegralPage extends StatefulWidget {
  @override
  _IntegralPageState createState() => _IntegralPageState();
}

class _IntegralPageState extends State<IntegralPage> {

  List<Integral> integralList = [Integral(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar("积分钱包"),
      body: Container(
        child: Column(
          children: [
            _buildIntegralTitle(),
            _buildList(),
          ],
        ),
      ),
    );
  }

  ///
  /// 积分钱包标题
  ///
  Widget _buildIntegralTitle(){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("icon_integral_bg.png",)
        ),
      ),
      child: Column(
        children: [

        ],
      ),
    );
  }

  ///
  /// 列表
  ///
  Widget _buildList(){
    return Container(
      child: ListView(
        children: integralList.length > 0 ? _buildItem() : BaseWidget.getEmptyWidget(),
      ),
    );
  }

  ///
  ///
  ///
  List<Widget> _buildItem(){
    return List.generate(integralList.length, (index){
      return Container(

      );
    });
  }

}
