

import 'package:flutter/material.dart';
import 'package:youwallet/widgets/app_bar.dart';

///
/// 专门用来转账以太坊的页面
///

class Erc20TransferPage extends StatefulWidget {
  @override
  _Erc20TransferPageState createState() => _Erc20TransferPageState();
}

class _Erc20TransferPageState extends State<Erc20TransferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar().getBaseAppBar(
          "转账Erc20"
      ),
      body: Container(

      ),
    );
  }
}
