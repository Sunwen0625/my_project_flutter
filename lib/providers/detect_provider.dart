import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

import '../utils/capture_util.dart';
import '../utils/flashlight_util.dart';
import '../utils/image_crop_util.dart';
import '../utils/location_utils.dart';
import '../utils/ocr_util.dart';

class DetectProvider with ChangeNotifier {
  final controller = YOLOViewController();

  // 取得 GPS 跟地址
  String? latString;
  String? lngString;
  String? address;
  Future<void> fetchLocation() async {
    try {
      Position pos = await LocationUtils.getCurrentPosition();
      latString = pos.latitude.toString();
      lngString = pos.longitude.toString();
      debugPrint("📍 取得經緯度：lat: $latString, lng: $lngString");
      notifyListeners(); // 先顯示經緯度

      // 再去查地址（這個可能比較慢）
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      Placemark place = placemarks.first;
      address = "${place.street}, ${place.locality}";
      notifyListeners(); // 更新地址
    } catch (e) {
      debugPrint("⚠️ 取得定位失敗 或 地址失敗：$e");
    }
  }
  DateTime _dateTime = DateTime.now();
  DateTime get dateTime => _dateTime;

  //time
  Future<void> currentTime() async {
    // xxxx/xx/xx xx:xx
    _dateTime = DateTime.now();
    notifyListeners();
  }

  // 開關手電筒
  bool isFlashlightOn = false;
  Future<void> toggleFlashlight() async {
    try {
      await FlashlightUtil.toggle(controller);
      isFlashlightOn = FlashlightUtil.isOn;
      notifyListeners(); // 通知 UI 更新
    } catch (e) {
      debugPrint("Flashlight toggle error: $e");
    }
  }

  // 拍照(一張)
  File? lastCapture;
  bool _pendingCrop = false;
  Future<void> captureImage() async {
    final file = await CaptureUtil.getCapture(controller);
    if (file != null) {
      lastCapture = file;
      _pendingCrop = true;
      debugPrint("📸 拍照完成: ${file.path}");
      notifyListeners();
    } else {
      debugPrint("⚠️ 拍照失敗");
    }
  }

  List<YOLOResult> _results = [];
  List<YOLOResult> get results => _results;
  // ✅ 根據偵測結果裁切圖片
  Future<void> getResult(List<YOLOResult> results) async {
    //List<YOLOResult> results =[
    // YOLOResult{classIndex: 63, className: laptop, confidence: 0.865234375, boundingBox: Rect.fromLTRB(28.1, 0.0, 414.6, 386.9)},
    // YOLOResult{classIndex: 66, className: keyboard, confidence: 0.505859375, boundingBox: Rect.fromLTRB(16.8, 399.2, 473.6, 504.5)}
    // ]
    _results = results;
    debugPrint("🔍 偵測到 ${results.length} 個物件");
    for (var r in results) {
      debugPrint("🟦 ${r.className} (${(r.confidence * 100).toStringAsFixed(1)}%) "
          "→ ${r.normalizedBox}");
    }
    notifyListeners();
    // ✅ 若剛拍完照且偵測完成，就立即裁切
    if (_pendingCrop && lastCapture != null && _results.isNotEmpty) {
      _pendingCrop = false;
      await cropAllDetectedObjects();
    }
  }

  //裁切圖片(可多張)
  // 裁切結果（多張）
  List<_CroppedObject> _croppedList = [];
  List<_CroppedObject> get croppedList => _croppedList;

  Future<void> cropAllDetectedObjects() async {
    if (lastCapture == null) {
      debugPrint("⚠️ 尚未有圖片可裁切");
      return;
    }
    if (_results.isEmpty) {
      debugPrint("⚠️ 尚未有偵測結果");
      return;
    }

    final imageFile = lastCapture!;
    _croppedList.clear();


    debugPrint("✂️ 開始裁切 ${_results.length} 個物件...");
    int index = 0;

    for (final result in _results) {
      final croppedFile = await ImageCropUtil.cropByNormalizedBox(
        imageFile: imageFile,
        normalizedBox: result.normalizedBox,
        index:  index,
      );
      getOCRText(croppedFile);

      _croppedList.add(_CroppedObject(
        file: croppedFile,
        label: result.className,
        confidence: result.confidence,
      ));

      debugPrint("✅ 已裁切: ${result.className} → ${croppedFile.path}");
      index++;
    }
    notifyListeners();
  }

  //文字辨識
  String ocrText = "";
  Future<void> getOCRText(File cropped) async {
    ocrText = await OcrUtil.recognizeText(cropped);
  }
}


class _CroppedObject {
  final File file;
  final String label;
  final double confidence;
  _CroppedObject({required this.file, required this.label, required this.confidence});
}