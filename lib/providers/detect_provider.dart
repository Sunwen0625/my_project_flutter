
import 'dart:ffi';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:ultralytics_yolo/yolo_view.dart';

import '../utils/capture_util.dart';
import '../utils/location_utils.dart';

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


  // 拍照
  File? lastCapture;
  Future<void> captureImage() async {
    final file = await CaptureUtil.getCapture(controller);
    if (file != null) {
      lastCapture = file;
      notifyListeners();
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


}