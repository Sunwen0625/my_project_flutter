import 'package:flutter/material.dart';
import '../utils/flashlight_util.dart';

class FlashlightButton extends StatefulWidget {
  const FlashlightButton({super.key});

  @override
  State<FlashlightButton> createState() => _FlashlightButtonState();
}

class _FlashlightButtonState extends State<FlashlightButton> {
  bool isOn = FlashlightUtil.isOn;

  Future<void> _toggleFlashlight() async {
    await FlashlightUtil.toggle();
    setState(() {
      isOn = FlashlightUtil.isOn;
    });
  }


  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        print("flashlight");
        _toggleFlashlight();
      },
      icon: isOn
          ? Icon(Icons.flashlight_off_rounded, color: Colors.white, size: 40)
          : Icon(Icons.flashlight_on_rounded, color: Colors.white, size: 40),
    );
  }
}
