
//相册工具，保存图片到相册
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class GalleryUtils{



  ///
  /// 拍照弹窗
  ///
  ///
  /// 选择照片
  /// needCrop 是否需要裁剪
  /// compressQuality 压缩率
  ///
  Future<File> showPhotoSelect(BuildContext context,{bool needCrop = true,int compressQuality = 50})async{
    File file ;
    file = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => _selectPhotoDialog(context),
    );
    if(file != null){
      //需要裁剪
      if(needCrop) {
        File croppedFile = await ImageCropper.cropImage(
            sourcePath: file.path,
            compressQuality: compressQuality,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
            androidUiSettings: AndroidUiSettings(
              toolbarTitle: '裁剪',
              toolbarColor: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              toolbarWidgetColor: Colors.black87,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              hideBottomControls: true,
            ),
            iosUiSettings: IOSUiSettings(
              title: "裁剪",
              doneButtonTitle: "完成",
              cancelButtonTitle: "取消",
              rotateClockwiseButtonHidden: true,
              rotateButtonsHidden: true,
              resetButtonHidden: true,
              aspectRatioPickerButtonHidden: true,
              aspectRatioLockDimensionSwapEnabled: true,
              rectWidth: 200,
              rectHeight: 200,
            )
        );
        return croppedFile;
      }else{
        return file;
      }
    }
    return file;
  }

  ///
  /// 照片弹窗布局
  ///
  // 底部弹出菜单actionSheet
  Widget _selectPhotoDialog(BuildContext context) {
    return new CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text(
            '打开相机拍照',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () {
            //打开相机，选取照片
            ImagePicker.pickImage(source: ImageSource.camera).then((path){
              Navigator.of(context).pop(path);
            });
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            '打开相册，选取照片',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'PingFangRegular',
            ),
          ),
          onPressed: () {
            // 打开相册，选取照片
            ImagePicker.pickImage(source: ImageSource.gallery).then((path){
              Navigator.of(context).pop(path);
            });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text(
          '取消',
          style: TextStyle(
            fontSize: 13.0,
            fontFamily: 'PingFangRegular',
            color: const Color(0xFF666666),
          ),
        ),
        onPressed: () {
          // 关闭菜单
          Navigator.of(context).pop();
        },
      ),
    );
  }


}