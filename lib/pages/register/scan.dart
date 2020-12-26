
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:r_scan/r_scan.dart';
import 'package:youwallet/util/media.dart';
import 'package:vibration/vibration.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with TickerProviderStateMixin{

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController qrViewController;

  //扫码框浮动动画
  double percentage = 0.0;//min = 0 max = 1;
  AnimationController percentageAnimationController;

  BuildContext _context;

  //防止监听器多次pop
  bool isResult = false;

  //当前闪光灯打开还是关闭
  bool isFlash = false;

  //震动时长
  int vibrationTime = 500;

  //音效播放器
  SoundPlayer soundPlayer = new SoundPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000))
      ..repeat()
      ..addListener(() {
        setState(() {
          percentage = percentageAnimationController.value;
        });
      });
    soundPlayer.init("sound/qrcode_completed.mp3");
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    percentageAnimationController?.dispose();
//    soundPlayer?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("扫一扫",style: TextStyle(color: Colors.black87),),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              iconSize: 18,
              icon: const Icon(Icons.arrow_back_ios,color: Colors.black87,),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          _buildScanFrame(),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                SizedBox(height: 60,),
                _buildScanHint(),
                Expanded(child: Container(width: 0,),),
                _buildToolBar(),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///
  /// 扫码提示
  ///
  Widget _buildScanHint(){
    return Container(
      padding: EdgeInsets.all(5),
      child: Text("将二维码放入框中,即可自动扫描",style: TextStyle(color: Colors.white),),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.black45
      ),
    );
  }

  ///
  /// 扫码框
  ///
  Widget _buildScanFrame(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CustomPaint(
        size: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        painter: ScanFramePainter(percentage),
      ),
    );
  }

  ///
  /// 二维码扫描结果
  ///
  void _onQRViewCreated(QRViewController controller) {
    this.qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        print(qrText);
        if(!isResult) {
          Vibration.vibrate(duration: vibrationTime);
          soundPlayer.playSound();
          Navigator.pop(_context, qrText);
          isResult = true;
        }
      });
    });
  }

  ///
  /// 工具栏
  /// 打开闪关灯 跟 从相册识别二维码
  ///
  Widget _buildToolBar(){
    return Container(
      color: Colors.black45,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            onTap: (){
              setState(() {
                qrViewController.toggleFlash();
                isFlash = !isFlash;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(isFlash ? "images/icon_scan_flash_open.png" : "images/icon_scan_flash_close.png",width: 30,height: 30,),
                SizedBox(width: 10,),
                Text("灯光",style: TextStyle(color: Colors.white60),),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              ImagePicker.pickImage(source: ImageSource.gallery).then((path){
                print(path);
                RScan.scanImagePath(path.path).then((data){
                  if(data != null && data.message != "") {
                    print(data.message);
                    Vibration.vibrate(duration: vibrationTime);
                    soundPlayer.playSound();
                    Navigator.pop(_context,data.message);
                  }else{
                    showToast("识别图片失败");
                  }
                });
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("images/icon_scan_photo.png",width: 30,height: 30,),
                SizedBox(width: 10,),
                Text("相册",style: TextStyle(color: Colors.white60),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///
/// 自己绘制的蒙版页面
///
class ScanFramePainter extends CustomPainter {

  double percentage;//扫码游标浮动

  ScanFramePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {

    ///
    /// 注意:frameWidget + (centerWidget * 2) = 必须等于1
    ///

    //扫码框的宽度
    double frameWidget = size.width * 0.7;

    // 横向居中值
    double centerWidget = size.width * 0.15;

    //距离顶部值
    double marginTopWidget = size.height * 0.2;

    var paint = Paint();
    paint.isAntiAlias = true;

    //灰色蒙版
    paint.color = Colors.black38;
    paint.strokeWidth = 2;
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, marginTopWidget), paint);
    canvas.drawRect(Rect.fromLTRB(0, marginTopWidget, centerWidget, marginTopWidget + frameWidget), paint);
    canvas.drawRect(Rect.fromLTRB(centerWidget + frameWidget, marginTopWidget, size.width, marginTopWidget + frameWidget), paint);
    canvas.drawRect(Rect.fromLTRB(0, marginTopWidget + frameWidget, size.width, size.height), paint);


    //白色框
    paint.color = Colors.white70;
    paint.strokeWidth = 1;
    canvas.drawLine(Offset(centerWidget,marginTopWidget), Offset(centerWidget + frameWidget,marginTopWidget), paint);
    canvas.drawLine(Offset(centerWidget,marginTopWidget), Offset(centerWidget,marginTopWidget + frameWidget), paint);
    canvas.drawLine(Offset(centerWidget + frameWidget,marginTopWidget), Offset(centerWidget + frameWidget,marginTopWidget + frameWidget), paint);
    canvas.drawLine(Offset(centerWidget,marginTopWidget + frameWidget), Offset(centerWidget + frameWidget,marginTopWidget + frameWidget), paint);

    //蓝色边框
    paint.color = Colors.blue;
    paint.strokeWidth = 2;
    canvas.drawLine(Offset(centerWidget,marginTopWidget), Offset(centerWidget + 20,marginTopWidget), paint);
    canvas.drawLine(Offset(centerWidget,marginTopWidget), Offset(centerWidget,marginTopWidget + 20), paint);

    canvas.drawLine(Offset(centerWidget + frameWidget,marginTopWidget), Offset(centerWidget + frameWidget - 20,marginTopWidget), paint);
    canvas.drawLine(Offset(centerWidget + frameWidget,marginTopWidget), Offset(centerWidget + frameWidget,marginTopWidget+20), paint);

    canvas.drawLine(Offset(centerWidget + frameWidget,marginTopWidget + frameWidget), Offset(centerWidget + frameWidget,marginTopWidget + frameWidget - 20), paint);
    canvas.drawLine(Offset(centerWidget + frameWidget,marginTopWidget + frameWidget), Offset(centerWidget + frameWidget - 20,marginTopWidget + frameWidget), paint);
//
    canvas.drawLine(Offset(centerWidget,marginTopWidget + frameWidget), Offset(centerWidget + 20,marginTopWidget + frameWidget), paint);
    canvas.drawLine(Offset(centerWidget,marginTopWidget + frameWidget), Offset(centerWidget,marginTopWidget + frameWidget - 20), paint);

    //扫码浮动标
    Rect rect = Rect.fromLTRB(centerWidget,marginTopWidget,centerWidget + frameWidget,marginTopWidget + frameWidget);
    Paint shaderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..shader = gradient.createShader(rect);
    canvas.drawLine(Offset(centerWidget,marginTopWidget +(0 + (percentage * frameWidget))),Offset(centerWidget + frameWidget, marginTopWidget + (0 + (percentage * frameWidget))), shaderPaint);

  }

  final Gradient gradient = new LinearGradient(
    colors: [
      Color.fromARGB(0x00, 0x21, 0x96, 0xF3),
      Colors.blue,
      Color.fromARGB(0x00, 0x21, 0x96, 0xF3),
    ],
  );

  @override
  bool shouldRepaint(ScanFramePainter oldDelegate) {
    return true;
  }
}
