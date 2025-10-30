import 'package:flutter/cupertino.dart';
import 'package:ultralytics_yolo/models/yolo_result.dart';


class DetectValidator {
  final String selectedYoloModel;

  DetectValidator(this.selectedYoloModel);

  /// 判斷目標是否夠大
  bool isObjectLargeEnough(String className, double width, double height) {
    final area = width * height;
    debugPrint("📏 $className 的面積為 $area");

    if (selectedYoloModel == 'redline_plus2_int8') {
      if (className == 'car' && area > 0.33) return true;
    } else if (selectedYoloModel == 'yolo11n_int8') {
      return area > 0.33;
    }

    return false;
  }

  /// 驗證 YOLO 偵測結果邏輯
  bool validateResults(List<YOLOResult> results) {
    final hasCar = results.any((r) => r.className == 'car');
    final hasIou = results.any((r) => r.className == 'MIU');
    final hasLicense = results.any((r) => r.className == 'licence plate');

    if (!(hasCar && hasIou && hasLicense)) {
      return false;
    }

    final cars = results.where((r) => r.className == 'car');
    final ious = results.where((r) => r.className == 'MIU');
    final plates = results.where((r) => r.className == 'licence plate');

    // 檢查每台車
    for (var car in cars) {
      bool carHasIou = false;
      bool carHasPlate = false;

      // car 與 MIU：需重疊或 car 在上方
      for (var iou in ious) {
        if (_isAbove(car.boundingBox, iou.boundingBox) ||
            _isOverlap(car.boundingBox, iou.boundingBox)) {
          carHasIou = true;
          break;
        }
      }

      // car 與 licence plate：必須重疊
      for (var plate in plates) {
        if (_isOverlap(car.boundingBox, plate.boundingBox)) {
          carHasPlate = true;
          break;
        }
      }

      if (carHasIou && carHasPlate) {
        // ✅ 條件全部成立
        return true;
      }
    }

    return false;
  }

  /// 判斷 car 是否在 iou 上方
  bool _isAbove(Rect car, Rect iou) {
    return car.bottom <= iou.top;
  }

  /// 判斷兩個矩形是否重疊
  bool _isOverlap(Rect a, Rect b) {
    return a.left < b.right &&
        a.right > b.left &&
        a.top < b.bottom &&
        a.bottom > b.top;
  }
}