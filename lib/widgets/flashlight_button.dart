import 'package:flutter/material.dart';

class FlashlightButton extends StatefulWidget {
  const FlashlightButton({super.key});

  @override
  State<FlashlightButton> createState() => _FlashlightButtonState();
}

class _FlashlightButtonState extends State<FlashlightButton> {
  bool isOn = false;

  void toggleFlashlight() {
    setState(() {
      isOn = !isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        print("flashlight");
        toggleFlashlight();
      },
      icon: isOn
          ? Icon(Icons.flashlight_off_rounded, color: Colors.white, size: 40)
          : Icon(Icons.flashlight_on_rounded, color: Colors.white, size: 40),
    );
  }
}
