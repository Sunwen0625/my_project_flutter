import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/location_utils.dart';

class GpsProvider  with ChangeNotifier {
  String? lat;
  String? long;

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
}