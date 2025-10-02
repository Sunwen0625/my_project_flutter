import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/detect_provider.dart';
import 'custom_overlay.dart';



class CameraButton extends StatelessWidget {

  const CameraButton({super.key, });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<DetectProvider>().captureImage();
        context.read<DetectProvider>().fetchLocation();
        final detected = context.read<DetectProvider>().detectedClasses;

        if (detected.isNotEmpty) {
          final message = "檢測到: ${detected.join(', ')}";
          print(message);

        }
        if (!detected.contains('laptop')) {
          //if (!detected.contains('red')) {
          showCustomOverlay(
            context,
            message: "圖片需包含電腦，請重新拍照！",
            backgroundColor: Colors.redAccent  ,
          );
        }
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.camera_alt, size: 40),
    );
  }
}

