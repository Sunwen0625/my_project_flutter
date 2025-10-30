import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_project/providers/photo_provider.dart';
import 'package:my_project/utils/current_time_utils.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';



import '../models/photo_model.dart';
import '../utils/capture_util.dart';
import '../utils/detect_validator.dart';
import '../utils/flashlight_util.dart';
import '../utils/image_crop_util.dart';
import '../utils/location_utils.dart';
import '../utils/ocr_util.dart';


class DetectProvider with ChangeNotifier {

  PhotoProvider? _photoProvider;
  void setPhotoProvider(PhotoProvider provider) {
    _photoProvider = provider;
  }
  final controller = YOLOViewController();


  bool _isDevMode = false;
  bool get isDevMode => _isDevMode;

  String _selectedYoloModel = ''; // 預設值
  String get selectedYoloModel => _selectedYoloModel;

  bool _isCameraActive = false; //  新增相機狀態
  bool get isCameraActive => _isCameraActive;


  void changeModel(String modelPath){
    controller.switchModel(modelPath,YOLOTask.detect);
  }
  void toggleDevMode() {
    _isDevMode = !_isDevMode;
    notifyListeners();
  }

  // 📷 切換相機按鈕狀態
  void toggleCamera() {
    _isCameraActive = !_isCameraActive;
    debugPrint("📸 Camera active: $_isCameraActive");

    if (_isCameraActive) {
      // ✅ 啟用 YOLO 模型
      changeModel("redline_plus_int8");
      debugPrint("🚀 啟用 YOLO 模型：$_selectedYoloModel");
    } else {
      // ❌ 關閉模型或停止動作
      debugPrint("🛑 停止 YOLO 模型");
      changeModel("");
    }

    notifyListeners();
  }

  void setYoloModel(String model) {
    _selectedYoloModel = model;
    debugPrint("🧠 已選擇 YOLO 模型：$_selectedYoloModel");
    changeModel(_selectedYoloModel);
    notifyListeners();
  }

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

  String dateTimeString = "";
  // 取得時間
  Future<void> getCurrentTime() async {
    final currentTime  = CurrentTimeUtils().getCurrentDateTime();
    dateTimeString = currentTime;
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
      getCurrentTime();
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
    final DetectValidator validator = DetectValidator(selectedYoloModel);
    final isReadyToCrop = _pendingCrop && lastCapture != null;
    final hasValidSizeObject = results.any(
          (r) => validator.isObjectLargeEnough(
        r.className,
        r.normalizedBox.width,
        r.normalizedBox.height,
      ),
    );

    final hasValidateResults = validator.validateResults(results);

    final shouldCropNow = isReadyToCrop  && hasValidateResults ;

    _results = results;

    debugPrint("🔍 偵測到 ${results.length} 個物件");
    for (var r in results) {
      debugPrint(
        "🟦 ${r.className} (${(r.confidence * 100).toStringAsFixed(1)}%) "
            "→ ${r.normalizedBox}",
      );
    }

    notifyListeners();
    // ✅ 若剛拍完照且偵測完成，就立即裁切
    if (shouldCropNow) {
      _pendingCrop = false;
      await cropAllDetectedObjects( validator);

    }
  }

  //裁切圖片(可多張)
  // 裁切結果（多張）

  String? ocrText = "";

  Future<void> cropAllDetectedObjects(DetectValidator validator) async {
    if (lastCapture == null) {
      debugPrint("⚠️ 尚未有圖片可裁切");
      return;
    }
    if (_results.isEmpty) {
      debugPrint("⚠️ 尚未有偵測結果");
      return;
    }
    final imageFile = lastCapture!;
    final validGroups = validator.getValidGroups(_results);

    if (validGroups.isEmpty) { debugPrint("⚠️ 沒有符合條件的組合，不裁切"); return; }


    debugPrint("✂️ 開始裁切 ${validGroups.length} 組符合條件的物件...");
    int index = 0;

    for (final group in validGroups) {
      final plate = group[0]; // licence plate
      final car = group[1]; // car
      // final iou = group[2]; // MIU (不裁)

      final plateFile = await ImageCropUtil.cropByNormalizedBox(
        imageFile: imageFile,
        normalizedBox: plate.normalizedBox,
        index: index,
      );

      // 📝 OCR 文字
      final text = await OcrUtil.getOCRText(plateFile);
      final regex = RegExp(r'^[A-Za-z]{3}[-._~]?\d{4}$');

        if (text != null && regex.hasMatch(text)) {
          debugPrint("📝 OCR 文字：$text");
          ocrText = text;
        } else {
          debugPrint("⚠️ OCR 文字無效 $text");
         // ocrText = null;
          ocrText = text;
        }

    final carFile = await ImageCropUtil.cropByNormalizedBox(
      imageFile: imageFile,
      normalizedBox: car.normalizedBox,
      index: index + 1,
    );

      final photo = PhotoModel(
        imagePath: imageFile,
        cutCarImagePath: carFile,
        cutLicensePlateImagePath:plateFile ,
        date: DateTime.now().toString().split('.')[0],
        address: address ?? '未知地點',
        longitude: lngString ?? '',
        latitude: latString ?? '',
        licensePlate: ocrText ?? '',
      );

      //添加歷史紀錄內
      _photoProvider?.addPhoto(photo);

      debugPrint("✅ 已裁切車子並儲存紀錄: ${carFile.path}");
      index++;
    }
    notifyListeners();
  }


}

