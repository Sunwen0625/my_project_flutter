import 'package:flutter/material.dart';

import '../widgets/camera_yolo_detect.dart';

class DisplayDetect extends StatefulWidget {
  const DisplayDetect({super.key});

  @override
  State<DisplayDetect> createState() => _DisplayDetectState();
}

class _DisplayDetectState extends State<DisplayDetect> {
  @override
  Widget build(BuildContext context) {
    return CameraYoloDetect();
  }
}
