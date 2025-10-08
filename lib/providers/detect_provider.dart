import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo/yolo_view.dart';

import '../utils/capture_util.dart';
import '../utils/flashlight_util.dart';
import '../utils/image_crop_util.dart';
import '../utils/location_utils.dart';
import '../utils/ocr_util.dart';

class DetectProvider with ChangeNotifier{
  final controller = YOLOViewController();


  // 取得 GPS 跟地址
  String? latString;
  String? lngString ;
  String? address;
  Future<void> fetchLocation() async {
    try {
      Position pos = await LocationUtils.getCurrentPosition();
      latString = pos.latitude.toString();
      lngString = pos.longitude.toString();
      print("📍 取得經緯度：lat: $latString, lng: $lngString");
      notifyListeners(); // 先顯示經緯度

      // 再去查地址（這個可能比較慢）
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      Placemark place = placemarks.first;
      address = "${place.street}, ${place.locality}";
      notifyListeners(); // 更新地址
    } catch (e) {
      print("⚠️ 取得定位失敗 或 地址失敗：$e");
    }
  }

  // 開關手電筒
  bool isFlashlightOn = false;
  Future<void> toggleFlashlight() async {
    try {
      await FlashlightUtil.toggle(controller);
      isFlashlightOn = FlashlightUtil.isOn;
      notifyListeners(); // 通知 UI 更新
    } catch (e) {
      print("Flashlight toggle error: $e");
    }
  }


  // 拍照
  File? lastCapture;
  Future<void> captureImage() async {
    final file = await CaptureUtil.getCapture(controller);
    if (file != null) {
      lastCapture = file;
      notifyListeners();
      cropImage();
    }
  }

  //檢測
  List<String> _detectedClasses = [];
  List<String> get detectedClasses => _detectedClasses;
  void updateResults(List<String> classNames) {
    _detectedClasses = classNames;
    print("更新結果: $_detectedClasses");
    notifyListeners();
  }

  late YOLOResult _result = [] as YOLOResult ;
  YOLOResult get result => _result;
  // ✅ 根據偵測結果裁切圖片
  Future<void> getResult(YOLOResult results) async {
    _result = results;
    print("🔍 偵測結果: $_result");
    notifyListeners();
  }

  //裁切圖片
  File? cropped;
  Future<void> cropImage() async{
    if (lastCapture == null) {
      print("⚠️ 尚未有圖片可裁切");
      return;
    }
    if (result.className=="laptop") {
      final imageFile = lastCapture!;
      cropped = await ImageCropUtil.cropByRect(
          imageFile: imageFile, normalizedBox: result.normalizedBox);
      notifyListeners();
      print("🔍 裁切結果: $cropped");

      getOCRText();
    }
  }

  //文字辨識
  String ocrText = "";
  Future<String> getOCRText() async {
    ocrText = await OcrUtil.recognizeText(cropped!);
    return ocrText;
  }


}