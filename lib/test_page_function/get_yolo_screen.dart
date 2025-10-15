import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ultralytics_yolo/widgets/yolo_controller.dart';
import 'package:ultralytics_yolo/yolo.dart';

import 'package:ultralytics_yolo/yolo_view.dart';


import '../utils/permission_utils.dart';


class CaptureExample extends StatefulWidget {
  @override
  _CaptureExampleState createState() => _CaptureExampleState();
}

class _CaptureExampleState extends State<CaptureExample> {
  final controller = YOLOViewController();
  bool isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initPermissionsAndModel();
  }

  Future<void> _initPermissionsAndModel() async {
    final granted = await PermissionUtils.requestCameraPermission();
    if (granted) {
      setState(() => isPermissionGranted = true);
    } else {
      setState(() => isPermissionGranted = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (!isPermissionGranted)
            Center(child: CircularProgressIndicator())
          else
            YOLOView(
              modelPath: 'yolov8n_int8',
              task: YOLOTask.detect,
              controller: controller,
              onResult: (results) {
                // TODO: 處理結果
              },
            ),

          // Capture button
          if (isPermissionGranted)
            Positioned(
              bottom: 80,
              left: 20,
              child: FloatingActionButton(
                onPressed: captureAndShare,
                child: Icon(Icons.camera_alt),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> captureAndShare() async {
    final imageData = await controller.captureFrame();

    if (imageData != null) {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/yolo_capture_$timestamp.jpg');
      await file.writeAsBytes(imageData);

      final params = ShareParams(
        files: [XFile(file.path)],
        text: 'YOLO Detection Result',
      );
      await SharePlus.instance.share(params);
    }
  }
}