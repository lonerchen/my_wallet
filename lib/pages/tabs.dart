import 'package:flutter/material.dart';
import 'package:youwallet/pages/tabs/tab_dapp.dart';
import 'package:youwallet/pages/tabs/tab_defi.dart';
import 'package:youwallet/pages/tabs/tab_mine.dart';
import 'package:youwallet/pages/tabs/tab_nuclear.dart';
import 'package:youwallet/pages/tabs/tab_wallet.dart'; // 钱包引导页TabExchange
import 'package:youwallet/pages/tabs/tab_exchange.dart'; // 钱包引导页
import 'package:youwallet/db/sql_util.dart';
import 'package:youwallet/bus.dart';
import 'package:youwallet/pages/wallet/wallet.dart';
import 'package:youwallet/value/colors.dart';

class _Item {
  String name, activeIcon, normalIcon;
  _Item(this.name, this.activeIcon, this.normalIcon);
}


///这个页面是作为四个tab页的容器，以Tab为基础控制每个item的显示与隐藏
class TabsPage extends StatefulWidget {

  // 实例化
  TabsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContainerPageState();
  }
}


class _ContainerPageState extends State<TabsPage> {

  List<Widget> pages; // 存放tab页面的数组

  int myIndex;

  int _selectIndex = 0; // 当前tab的索引

  final defaultItemColor = Color.fromARGB(255, 125, 125, 125);

  final itemNames = [
    _Item('首页', 'images/icon_center_wallet_sel.png','images/icon_center_wallet.png'),
    _Item('矿池', 'images/icon_center_mining_sel.png','images/icon_center_mining.png'),
    _Item('DeFi', 'images/icon_center_defi_sel.png','images/icon_center_defi.png'),
    _Item('DAPP', 'images/icon_center_dapp_sel.png','images/icon_center_dapp.png'),
    _Item('我的', 'images/icon_center_mine_sel.png','images/icon_center_mine.png'),
  ];

  List<BottomNavigationBarItem> itemList;
  Future _future;

  List wallets = [];

  // 构造函数
  // _ContainerPageState({Key key, @required this.myIndex,}) : super(key: key);

  @override
  void initState() {
    super.initState();
    _future = getWallet();
    // 将四个tab页面初始化为一个数组pages
    if(pages == null){
      pages = [
        new WalletPage(),
        new TabNuclearPage(),
        new TabDefiPage(),
        new TabDappPage(),
        new MinePage()
      ];
    }
    if(itemList == null){
      this.itemList = itemNames.map((item) =>
          BottomNavigationBarItem(
            icon: Image.asset(
              item.normalIcon,
              width: 24.0,
              height: 24.0,
            ),
            title: Text(
              item.name,
              style: TextStyle(fontSize: 9.0),
            ),
            activeIcon: Image.asset(item.activeIcon, width: 24.0, height: 24.0))
          ).toList();
    }

    eventBus.on<TabChangeEvent>().listen((event) {
      setState(() {
        _selectIndex = event.index;
      });
    });

  }

  // todo: 删除这个函数，从全局状态容器中调用它的逻辑
  Future getWallet() async {
    var sql = SqlUtil.setTable("wallet");
    List res = await sql.get();
    this.wallets = res;
  }


//Stack（层叠布局）+ Offstage组合,解决状态被重置的问题
  Widget _getPagesWidget(int index) {
    // print(index);
    return Offstage(
      offstage: _selectIndex != index,
      child: TickerMode(
        enabled: _selectIndex == index,
        child: pages[index],
      ),
    );
  }


  @override
  void didUpdateWidget(TabsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
//    List wallets = Provider.of<Wallet>(context).items;
//    if (wallets.length == 0) {
//      Navigator.pushNamed(context, "wallet_guide");
//    }
      return Scaffold(
        body: new Stack(
          children: [
            _getPagesWidget(0),
            _getPagesWidget(1),
            _getPagesWidget(2),
            _getPagesWidget(3),
            _getPagesWidget(4),
          ],
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          items: itemList,
          onTap: (int index) {
            print('当前tab索引=> ${index}');
            eventBus.fire(TabChangeEvent(index));
            setState(() {
              _selectIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectIndex,
          selectedLabelStyle: TextStyle(fontSize: 9,color: MyColors.THEME_COLORS),
          unselectedLabelStyle: TextStyle(fontSize: 9,color: MyColors.BLACK_TEXT_22),
          selectedItemColor: MyColors.THEME_COLORS,
          unselectedItemColor:  MyColors.BLACK_TEXT_22,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          //选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type: BottomNavigationBarType.fixed,时生效）
          // fixedColor: Colors.lightBlue,
        ),
      );
    }
}