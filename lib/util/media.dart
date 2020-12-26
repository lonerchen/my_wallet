
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';

///
/// 音效播放器
///
class SoundPlayer{

  //音效播放器
  FlutterSound flutterSound;
  //音效的二进制文件
  Uint8List _soundData;


  init(String assets) async{
    flutterSound = new FlutterSound();
    var bytes = await rootBundle.load("$assets");
    _soundData = bytes.buffer.asUint8List(0);
  }

  playSound()async{
    if(flutterSound != null && _soundData != null)
      await flutterSound.startPlayerFromBuffer(_soundData);
  }

  close()async{
    await flutterSound.stopRecorder();
  }

}