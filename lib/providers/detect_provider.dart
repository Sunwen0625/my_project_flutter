
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:ultralytics_yolo/yolo_view.dart';

import '../utils/capture_util.dart';
import '../utils/location_utils.dart';

class DetectProvider with ChangeNotifier{
  final controller = YOLOViewController();

  String? lat;
  String? long;
  File? lastCapture;

  // 取得 GPS
  Future<void> fetchLocation() async {
    try {
      Position pos = await LocationUtils.getCurrentPosition();
      lat = pos.latitude.toString();
      long = pos.longitude.toString();
      print("lat: ${lat} -- long: ${long}");
      notifyListeners(); // 通知 UI 更新
    } catch (e) {
      print("⚠️ 取得定位失敗：$e");
    }
  }
  // 拍照
  Future<void> captureImage() async {
    final file = await CaptureUtil.getCapture(controller);
    if (file != null) {
      lastCapture = file;
      notifyListeners();
    }
  }
}