import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:provider/provider.dart';

import '../providers/detect_provider.dart';
import '../utils/permission_utils.dart';

class CameraYoloDetect extends StatefulWidget {
  const CameraYoloDetect({super.key});

  @override
  State<CameraYoloDetect> createState() => _CameraYoloDetectState();
}

class _CameraYoloDetectState extends State<CameraYoloDetect> {
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
    final detect = context.read<DetectProvider>();
    return Stack(
      children: [
        if (!isPermissionGranted)
          Center(child: CircularProgressIndicator())
        else
            YOLOView(
            modelPath: 'yolo11n_int8',
              //modelPath: 'redline_int8',
            task: YOLOTask.detect,
            controller: detect.controller,
            onResult: (results) {
              print('Found ${results.length} objects!');
              final detectedClassList = <String>[];
              for (final result in results) {
                print('${result.className}: ${result.confidence}');
                detectedClassList.add(result.className);
              }
              detect.updateResults(detectedClassList);
            },
            )
      ]);


  }
}



