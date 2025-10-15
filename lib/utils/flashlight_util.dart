
import 'package:ultralytics_yolo/yolo_view.dart';


class FlashlightUtil {
  static bool _isOn = false;

  static bool get isOn => _isOn;

  static Future<void> toggle(YOLOViewController controller) async {
    try {
     // await controller.toggleFlashlight(_isOn);
      _isOn = !_isOn;
    } on Exception catch (e) {
      print("Flashlight error: $e");
    }
  }
}
