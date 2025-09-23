
import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {  },
      shape: const CircleBorder(),
      child: const Icon(Icons.camera_alt, size: 40),
    );
  }
}
