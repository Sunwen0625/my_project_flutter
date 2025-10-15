
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';


class CaptureUtil{
  static Future<File?> getCapture(YOLOViewController controller) async {
    final imageData = await controller.captureFrame();
    if (imageData == null) return null;

    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/yolo_capture_$timestamp.jpg');
    await file.writeAsBytes(imageData);
    return file;
  }
}

