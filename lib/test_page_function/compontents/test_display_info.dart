import 'package:flutter/material.dart';

import '../../providers/detect_provider.dart';
import 'package:provider/provider.dart';


class TestDisplayInfo extends StatelessWidget {
  const TestDisplayInfo({super.key});

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
                const Text("📷 Last Capture cropped:"),
                if (detect.croppedList.isNotEmpty)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: detect.croppedList.map((obj) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.file(
                            obj.file,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            key: ValueKey(obj.file.path), // 🔑 防快取
                          ),
                          Text(
                            "${obj.label} (${(obj.confidence * 100).toStringAsFixed(1)}%)",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                else
                  const Text("尚未裁切圖片"),


                const SizedBox(height: 20),
                Text(detect.results.toString()),

                const SizedBox(height: 20),
                const Text("📍 GPS:"),
                Text("lat: ${detect.latString ?? "??"} -- long: ${detect.lngString ?? "??"}"),
                const SizedBox(height: 20),
                const Text("📍 地址:"),
                Text(detect.address ?? "No address yet"),
                const SizedBox(height: 20),
                const Text("📅 日期時間:"),
                Text(detect.dateTimeString ),
                const SizedBox(height: 20),
                const Text("🔍 車牌號碼 :"),
                Text("xxx-xxxx"),
                Text(detect.ocrText!),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: (){
                  Navigator.pushNamed(context, '/historyList');
                }, child: Text("history detects")),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: (){
                  Navigator.pushNamed(context, '/tracking');
                }, child: Text("detect_list"))
              ]
            ),
          );
      }
    );
  }
}

