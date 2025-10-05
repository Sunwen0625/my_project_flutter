import 'package:flutter/material.dart';

import '../providers/detect_provider.dart';
import 'package:provider/provider.dart';


class DisplayInfo extends StatelessWidget {
  const DisplayInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetectProvider>(
      builder: (context, detect, child) {
        return  Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text("📷 Last Capture:"),
                if (detect.lastCapture != null)
                  Image.file(detect.lastCapture!, height: 300)
                else
                  const Text("No picture yet"),

                const SizedBox(height: 20),
                const Text("📍 GPS:"),
                Text("lat: ${detect.latString ?? "??"} -- long: ${detect.lngString ?? "??"}"),
                const SizedBox(height: 20),
                const Text("📍 地址:"),
                Text(detect.address ?? "No address yet"),
                const SizedBox(height: 20),
                const Text("📅 日期時間:"),
                //TODO 這裡要改成日期時間
                Text("xxxx/xx/xx xx:xx"),
                const SizedBox(height: 20),
                const Text("🔍 車牌號碼 :"),
                Text("xxx-xxxx"),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: (){}, child: Text("history detects"))
              ]
            ),
          );
      }
    );
  }
}

