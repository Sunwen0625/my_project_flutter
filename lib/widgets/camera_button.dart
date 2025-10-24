import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/detect_provider.dart';





class CameraButton extends StatelessWidget {

  const CameraButton({super.key, });

  @override
  Widget build(BuildContext context) {
    return Consumer<DetectProvider>(
      builder: (context, state, child) {
        return FloatingActionButton(
          onPressed: () {
            state.toggleCamera();
            /*
          final detected = context.read<DetectProvider>().detectedClasses;

          if (detected.isNotEmpty) {
            final message = "檢測到: ${detected.join(', ')}";
            print(message);

          }
          */

            /*
          // 通知
          if (!detected.contains('laptop')) {
            //if (!detected.contains('red')) {
            showCustomOverlay(
              context,
              message: "圖片需包含電腦，請重新拍照！",
              backgroundColor: Colors.redAccent  ,
            );
          }
          */
          },
          shape: const CircleBorder(),
          backgroundColor: state.isCameraActive ? Colors.red : Colors.blue,
          child: Icon(
            state.isCameraActive ? Icons.cancel : Icons.camera_alt,
            size: 40,
            color: Colors.white,
          ),
        );

      },


    );
  }
}

