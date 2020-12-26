import 'package:flutter/material.dart';
import 'package:youwallet/pages/register/new_wallet_guide.dart';
import 'package:youwallet/pages/splash/splash.dart'; // 启动页面
import 'package:youwallet/debug_page.dart'; // 全局调试
import 'package:youwallet/pages/login/login.dart'; // 解锁登录
import 'package:youwallet/pages/register/new_wallet_guide.dart'; // 钱包引导页

// 钱包操作
import 'package:youwallet/pages/register/new_wallet_first.dart';
import 'package:youwallet/pages/register/new_wallet_second.dart';
import 'package:youwallet/pages/register/new_wallet_load.dart';
import 'package:youwallet/pages/register/new_wallet_check.dart';
import 'package:youwallet/pages/register/new_wallet_mnemonic.dart';
import 'package:youwallet/pages/register/new_wallet_success.dart';
import 'package:youwallet/pages/manage_wallet/manage_list.dart'; // 新建钱包名字
import 'package:youwallet/pages/manage_wallet/set_wallet.dart'; // 新建钱包名字
import 'package:youwallet/pages/register/wallet_export.dart'; // 导出钱包

// token
import 'package:youwallet/pages/token/token_history.dart'; // token交易历史
import 'package:youwallet/pages/token/token_add.dart'; // 添加一种token
import 'package:youwallet/pages/token/token_info.dart'; // 添加一种token

// 设置
import 'package:youwallet/pages/set/set_network.dart'; // 网络设置
import 'package:youwallet/pages/tabs.dart';
import 'package:youwallet/pages/keyboard/keyboard_main.dart';

// 表单
import 'package:youwallet/pages/form/password.dart';
import 'package:youwallet/pages/form/getPassword.dart';

// 订单
import 'package:youwallet/pages/order/order_detail.dart';
import 'package:youwallet/pages/order/order_deep.dart';

// 扫码
import 'package:youwallet/pages/scan/scan.dart';

// 操作反馈
import 'package:youwallet/pages/success/index.dart';

// 定义全局的路由对象
final routes = {
  '/': (context) => new TabsPage(),
  "debug_page": (context) => new DebugPage(),
  "wallet_guide": (context) => new WalletGuide(),
  "set_wallet_name": (context) => new NewWalletName(),
  "manage_wallet": (context) => new ManageWallet(),
  "set_wallet": (context) => new SetWallet(),
  "add_token": (context,{arguments}) => new AddToken(arguments: arguments),
  "token_history":(context) => new TokenHistory(),
  "token_info":(context, {arguments}) => new TokenInfo(arguments: arguments),
  "login": (context) => new Login(),
  "backup_wallet": (context, {arguments}) => new BackupWallet(arguments: arguments),
  "load_wallet": (context,{arguments}) => new LoadWallet(arguments: arguments),
  "wallet_mnemonic": (context,{arguments}) => new WalletMnemonic(arguments: arguments),
  "wallet_check": (context) => new WalletCheck(),
  "wallet_success": (context) => new WalletSuccess(),
  "set_network":  (context) => new NetworkPage(),
  "wallet_export":  (context,{arguments}) => new WalletExport(arguments: arguments),
  "keyboard_main":  (context) => new main_keyboard(),
  "password":  (context) => new PasswordPage(),
  "getPassword":  (context, {arguments}) => new GetPasswordPage(arguments: arguments),
  "splash":  (context) => new Splash(),
  "order_detail":  (context, {arguments}) => new OrderDetail(arguments: arguments),
  "order_deep":  (context, {arguments}) => new OrderDeep(arguments: arguments),
  "scan":  (context, {arguments}) => new Scan(arguments: arguments),
  "success":  (context, {arguments}) => new Success(arguments: arguments),
//  "tabs": (context) => new ContainerPage()
};

var onGenerateRoute = (RouteSettings settings) { // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
       final Route route = MaterialPageRoute(
          builder: (context) => pageContentBuilder(context, arguments: settings.arguments)
       );
       return route;
    }else{
      final Route route = MaterialPageRoute(
          builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};

