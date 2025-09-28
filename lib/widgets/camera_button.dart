
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/detect_provider.dart';


class CameraButton extends StatelessWidget {

  const CameraButton({super.key, });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<DetectProvider>().captureImage();
        context.read<DetectProvider>().fetchLocation();
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.camera_alt, size: 40),
    );
  }
}
