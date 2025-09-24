import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class CameraYoloDetect extends StatefulWidget {
  const CameraYoloDetect({super.key});

  @override
  State<CameraYoloDetect> createState() => _CameraYoloDetectState();
}

class _CameraYoloDetectState extends State<CameraYoloDetect> {
  @override
  Widget build(BuildContext context) {
    return YOLOView(
      modelPath: 'yolov8n_int8',
      task: YOLOTask.detect,
      onResult: (results) {
        print('Found ${results.length} objects!');
        for (final result in results) {
          print('${result.className}: ${result.confidence}');
        }
      },
    );
  }
}
