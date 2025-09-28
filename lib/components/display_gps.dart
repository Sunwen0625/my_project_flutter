import 'package:flutter/material.dart';

import '../providers/detect_provider.dart';
import 'package:provider/provider.dart';


class DisplayGps extends StatelessWidget {
  const DisplayGps({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetectProvider>(
      builder: (context, detect, child) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Text("📍 GPS Info:"),
                Text("lat: ${detect.lat ?? "??"} -- long: ${detect.long ?? "??"}"),
                const SizedBox(height: 20),
                const Text("📷 Last Capture:"),
                if (detect.lastCapture != null)
                  Image.file(detect.lastCapture!, height: 300)
                else
                  const Text("No picture yet"),
              ]
            ),
          ),
        );
      }

    );
  }
}

