


class URL{

//  static const String BASE_URL = "http://hybrid.aoya.cool";
  static const String BASE_URL = "http://47.97.192.202:8084/";

  ///
  ///创建账号 导入钱包或者创建钱包之后，将助记词发给服务器
  /// @param hash = 助记词hash值
  /// @param address = eth地址
  ///
  static String createUser = "/api/user/create";

  ///
  /// post
  /// body : tokenRequest类
  ///
  static String login = "/oauth/token";

  ///
  /// post
  /// 档案修改
  /// token
  /// body : name
  /// body : portrait
  ///
  static String profile = "/api/user/profile";

  ///
  /// post
  /// 获取用户信息
  /// token
  ///
  static String userInfo = "/api/user/info";

  ///
  /// get
  /// 我的团队
  /// param : coinId 币种Id
  ///
  static String myTeam = "/api/user/myTeam";

  ///
  /// get
  /// 获取币种列表
  ///
  static String getCoinList = "/api/coins";

  ///
  /// get
  /// 我的邀请
  /// param ：coinId 币种Id
  ///
  static String myMember = "/api/user/myMembers";

  ///
  /// get
  /// 团队成员信息
  /// param ：userId 用户Id
  /// param ：coinId 币种Id
  ///
  static String teamMember = "/api/user/teamMember";

  ///
  /// post
  /// 转账（建立用户关系）
  /// param ：formAddress 当前账户的地址
  /// param ：toAddress 目标账户地址
  /// param ：amount 转账金额
  /// param ：coinId 币种id
  ///
  static String transaction = "/api/transaction/transfer";

  ///
  /// post
  /// 质押
  /// param ：amount 质押金额
  /// param ：coinId 币种id
  ///
  static String deposit = "/api/transaction/deposit";

  ///
  /// get
  /// 交易记录列表
  /// param ：coinId 币种ID
  /// param ：status 交易状态
  /// param ：type 类型
  /// param ：page 分页当前页面0
  /// param ：perPage 每页条数
  ///
  static String records = "/api/transaction/record";

  ///
  /// get
  /// 交易详情
  /// param ： id 交易记录id
  ///
  static String recordDetails = "/api/transaction/details";

  ///
  /// get
  /// 获取DAPP
  ///
  static String pandora = "/api/pandora";

  ///
  /// post
  /// 中心化钱包列表
  /// 用户账户列表
  ///
  static String accounts = "/api/user/accounts";

  ///
  /// post
  /// 用户账户详情
  /// param : id 币种id
  ///
  static String accountDetails = "/api/user/accountDetails";

  ///
  /// post
  /// 添加地址
  /// param : address
  /// param : bridege_id
  /// param : description
  ///
  static String addAddress = "/api/address/create";

  ///
  /// delete
  /// 删除地址
  /// param : id 地址id
  ///
  static String deleteAddress = "/api/address/delete";

  ///
  /// get
  /// 获取地址列表
  /// param : page 分页 默认0
  /// param : perPage 每页条数
  ///
  static String getAddress = "/api/address/list";

  ///
  /// PUT
  /// 更新地址
  /// param : id
  /// param : address
  /// param : bridege_id
  /// param : description
  ///
  static String updateAddress = "/api/address/update";

  ///
  /// post
  /// 矿池列表
  ///
  static String nuclearCoinList = "/api/nuclear/coin";

  ///
  /// post
  /// 加入矿池 激活
  /// body coin_id 2
  ///
  static String nuclearJoin = "/api/nuclear/user/activate";

  ///
  /// post
  /// 用户矿池总收益
  ///
  static String nuclearSum = "/api/nuclear/user/earnings";

  ///
  /// post
  /// 收益方式记录
  ///
  static String nuclearList = "/api/nuclear/way";

  ///
  /// post
  /// 日收益前10
  /// body coin_id = 网体id
  /// body nuclear_id = 收益方式ID
  ///
  static String nuclearTopDay = "/api/nuclear/top/day";

  ///
  /// post
  /// 累计收益前10
  /// body coin_id = 网体id
  /// body nuclear_id = 收益方式ID
  ///
  static String nuclearTopTotal = "/api/nuclear/top/total";

}