
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gps_provider.dart';

class CameraButton extends StatelessWidget {
  const CameraButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<GpsProvider>().fetchLocation();
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.camera_alt, size: 40),
    );
  }
}
