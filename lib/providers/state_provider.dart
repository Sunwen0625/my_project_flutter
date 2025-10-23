import 'package:flutter/material.dart';

import 'detect_provider.dart';


class StateProvider with ChangeNotifier {

  DetectProvider? _detectProvider;
  void setDetect(DetectProvider detectProvider) {
    _detectProvider = detectProvider;
  }


  bool _isDevMode = false;
  bool get isDevMode => _isDevMode;

  String _selectedYoloModel = ''; // 預設值
  String get selectedYoloModel => _selectedYoloModel;

  bool _isCameraActive = false; //  新增相機狀態
  bool get isCameraActive => _isCameraActive;



  void toggleDevMode() {
    _isDevMode = !_isDevMode;
    notifyListeners();
  }

  /// 📷 切換相機按鈕狀態
  void toggleCamera() {
    _isCameraActive = !_isCameraActive;
    debugPrint("📸 Camera active: $_isCameraActive");

    if (_isCameraActive) {
      // ✅ 啟用 YOLO 模型
      _detectProvider?.changeModel("redline_plus_int8");
      debugPrint("🚀 啟用 YOLO 模型：$_selectedYoloModel");
    } else {
      // ❌ 關閉模型或停止動作
      debugPrint("🛑 停止 YOLO 模型");
      _detectProvider?.changeModel("");
    }

    notifyListeners();
  }


  void setYoloModel(String model) {
    _selectedYoloModel = model;
    debugPrint("🧠 已選擇 YOLO 模型：$_selectedYoloModel");
    _detectProvider?.changeModel(_selectedYoloModel);
    notifyListeners();
  }
}