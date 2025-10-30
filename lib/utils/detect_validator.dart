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

  /// ✅ 驗證是否存在至少一組符合條件的 car + MIU + licence plate
  ///
  /// 條件：
  /// 1️⃣ 同時包含 car、MIU、licence plate 三種類別
  /// 2️⃣ car 與 MIU 必須重疊或 car 在 MIU 上方
  /// 3️⃣ car 與 licence plate 必須重疊
  bool validateResults(List<YOLOResult> results) {
    final validGroups = getValidGroups(results);
    return validGroups.isNotEmpty;
  }

  /// 驗證 YOLO 偵測結果邏輯
  /// 🔁 將所有符合條件的 (licence plate + car + MIU) 組合成 List<List<YOLOResult>>
  ///
  /// 回傳格式：
  /// ```
  /// [
  ///   [licencePlate1, car1, iou1],
  ///   [licencePlate2, car2, iou2],
  ///   ...
  /// ]
  /// ```
  List<List<YOLOResult>> getValidGroups(List<YOLOResult> results) {
    final hasCar = results.any((r) => r.className == 'car');
    final hasIou = results.any((r) => r.className == 'MIU');
    final hasLicense = results.any((r) => r.className == 'licence plate');

    if (!(hasCar && hasIou && hasLicense)) {
      debugPrint("❌ 缺少必要類別：car / MIU / licence plate");
      return [];
    }

    final cars = results.where((r) => r.className == 'car');
    final ious = results.where((r) => r.className == 'MIU');
    final plates = results.where((r) => r.className == 'licence plate');

    final validGroups = <List<YOLOResult>>[];

    for (var car in cars) {
      YOLOResult? matchedIou;
      YOLOResult? matchedPlate;

      // car 與 MIU：需重疊或 car 在上方
      for (var iou in ious) {
        if (_isAbove(car.boundingBox, iou.boundingBox) ||
            _isOverlap(car.boundingBox, iou.boundingBox)) {
          matchedIou = iou;
          break;
        }
      }

      // car 與 licence plate：必須重疊
      for (var plate in plates) {
        if (_isOverlap(car.boundingBox, plate.boundingBox)) {
          matchedPlate = plate;
          break;
        }
      }

      // 若 car 同時找到對應的 plate 與 iou，就算一組
      if (matchedIou != null && matchedPlate != null) {
        validGroups.add([matchedPlate, car, matchedIou]);
        debugPrint("✅ 成功匹配一組: plate=${matchedPlate.className}, car=${car.className}, iou=${matchedIou.className}");
      }
    }

    debugPrint("📦 共找到 ${validGroups.length} 組有效結果");
    return validGroups;
  }

  /// 判斷 car 是否在 iou 上方
  bool _isAbove(Rect car, Rect iou) {
    return car.bottom >= iou.top;
  }

  /// 判斷兩個矩形是否重疊
  bool _isOverlap(Rect a, Rect b) {
    return a.left < b.right &&
        a.right > b.left &&
        a.top < b.bottom &&
        a.bottom > b.top;
  }
}