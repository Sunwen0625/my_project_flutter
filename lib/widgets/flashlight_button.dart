import 'package:flutter/material.dart';
import '../providers/detect_provider.dart';
import 'package:provider/provider.dart';

class FlashlightButton extends StatefulWidget {
  const FlashlightButton({super.key});

  @override
  State<FlashlightButton> createState() => _FlashlightButtonState();
}

class _FlashlightButtonState extends State<FlashlightButton> {


  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<DetectProvider>();
    return IconButton(
      onPressed: () {
        print("flashlight");
        cameraProvider.toggleFlashlight();
      },
      icon: cameraProvider.isFlashlightOn
          ? Icon(Icons.flashlight_off_rounded, color: Colors.white, size: 40)
          : Icon(Icons.flashlight_on_rounded, color: Colors.white, size: 40),
    );
  }
}
