import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youwallet/http/dio_utils.dart';
import 'package:youwallet/http/url.dart';
import 'package:youwallet/model/dapp.dart';
import 'package:youwallet/pages/common/dapp.dart';
import 'package:youwallet/pages/tabs/tab_defi.dart';
import 'package:youwallet/value/colors.dart';
import 'package:youwallet/value/style.dart';
import 'package:youwallet/widgets/app_bar.dart';
import 'package:youwallet/widgets/base.dart';

class TabDappPage extends StatefulWidget {


  @override
  _TabDappPageState createState() => _TabDappPageState();
}

class _TabDappPageState extends State<TabDappPage> {


  List<Dapp> dapp =[
      Dapp(id: 1,name: "Uniswap",img: "images/icon_eth.png",url: "https://uniswap.tokenpocket.pro/#/swap"),
  ];

  RefreshController dappRefreshController = new RefreshController();

  TextEditingController searchController = new TextEditingController();

  String searchText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dappRefreshController.dispose();
  }

  _refresh(){
//    DioUtils.getInstance().get(URL.pandora·).then((value){
//      setState(() {
//        dapp = Dapp.formJsonList(value["data"]);
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: BaseAppBar().getBaseAppBar(""),

      body: Container(
        child: SmartRefresher(
          controller: dappRefreshController,
          enablePullDown: true,
          header: ClassicHeader(),
          onRefresh: ()async{
            dappRefreshController.refreshCompleted();
            _refresh();
          },
          child: Column(
            children: [
              SizedBox(height: 50,),
              _buildSearchBar(),
              Expanded(
                child: GridView(
                  padding: EdgeInsets.only(top: 80),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: dapp.length > 0 ? 2 : 1,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 1,
                  ),
                  children: dapp.length > 0 ? List.generate(dapp.length, (index){
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context){
                            return TabDefiPage();
                          })
                        );
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(dapp[index].img,width: 50,height: 50,),
                            SizedBox(height: 10,),
                            Text(dapp[index].name,style: TextStyle(fontSize: 14,color:MyColors.BLACK_TEXT_22 ),),
                          ],
                        ),
                      ),
                    );
                  }) : BaseWidget.getEmptyWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          //搜索框
          Expanded(
            child: Container(
              height: 36,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: MyColors.GRAY_TEXT_EE,
                borderRadius: BorderRadius.circular(17.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 15,),
                  Expanded(
                    child: Container(
                      height: 20,
                      child: TextField(
                        controller: searchController,
                        maxLines: 1,
                        scrollPadding: EdgeInsets.all(0),
                        style: TextStyle(color: MyColors.BLACK_TEXT_22,fontSize: 14),
                        onSubmitted: (text){
                          if(text != ""){
                            searchText = text;
//                            if(!recordList.contains(text)) {
//                              recordList.add(text);
//                            }
//                            _saveRecord();
                            this._startDApp(text);
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.all(0),
                          hintText: "搜索DApp",
                          hintStyle: TextStyle(color: MyColors.GRAY_TEXT_99,fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: (){
                        searchController.text = "";
                        searchText = "";
                      },
                      child: Icon(Icons.cancel,color: MyColors.GRAY_TEXT_D8,size: 16,)
                  ),
                ],
              ),
            ),
          ),
//          SizedBox(width: 14,),
          //取消文本
//          GestureDetector(
//              onTap: (){
//                Navigator.pop(context);
//              },
//              child: Text("取消",style: MyTextStyle.TEXT_S14_CTIT,)
//          ),
        ],
      ),
    );
  }

  _startDApp(String url){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context){
          return TabDefiPage(url:url);
        })
    );
  }

}
