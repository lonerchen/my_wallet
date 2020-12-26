import 'package:flutter/material.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/widgets/button.dart';

class RuleDialog extends StatefulWidget {
  @override
  _RuleDialogState createState() => _RuleDialogState();
}

class _RuleDialogState extends State<RuleDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 280,
          height: 541,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Text("规则",style: TextStyle(fontSize: 18,color: MyColors.BLACK_TEXT_22,fontWeight: FontWeight.w600),),
              SizedBox(height: 20,),
              Expanded(
                  child: SingleChildScrollView(
                    child: Text("想要激活享受繁殖分裂权限，必须激活币种网体，然后对该币种进行质押，从而激活该币种的繁殖分裂权限。 \n\n何谓激活币种网体？ \n激活币种网体实际上就是绑定上下级的过程。 举例说明：在公链钱包内，用户A给用户B首次转账一笔 “WIFI” Token，此时用户A与用户B绑定上下级关系，同时用户B的 “WIFI” 币种网体被激活。 \n\n何谓质押，激活繁殖分裂权限？ \n用户B激活“WIFI” 币种网体后，用户B拿ERC20钱包里的“WIFI”质押进公链钱包从而激活''WIFI''的繁殖分裂权限。",style: TextStyle(fontSize: 14,color: MyColors.BLACK_TEXT_22),),
                  )
              ),
              SizedBox(height: 34,),
              BaseButton().getBaseButton(text: "好的",width: 120,height: 40,color: Color.fromARGB(0xff, 0x1e, 0xd6, 0x9c), onPressed: (){
                Navigator.of(context).pop();
              }),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
