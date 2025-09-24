import 'package:torch_light/torch_light.dart';

class FlashlightUtil {
  static bool _isOn = false;

  static bool get isOn => _isOn;

  static Future<void> toggle() async {
    try {
      if (_isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      _isOn = !_isOn;
    } on Exception catch (e) {
      print("Flashlight error: $e");
    }
  }

  static Future<void> turnOn() async {
    try {
      await TorchLight.enableTorch();
      _isOn = true;
    } on Exception catch (e) {
      print("Flashlight error: $e");
    }
  }

  static Future<void> turnOff() async {
    try {
      await TorchLight.disableTorch();
      _isOn = false;
    } on Exception catch (e) {
      print("Flashlight error: $e");
    }
  }
}