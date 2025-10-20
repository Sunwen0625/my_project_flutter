import 'package:flutter/material.dart';

import '../providers/detect_provider.dart';
import 'package:provider/provider.dart';


class DisplayInfo extends StatelessWidget {
  const DisplayInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetectProvider>(
      builder: (context, detect, child) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('使用者名稱 : xxx', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              const Text('身分證 : xxxxxxxx', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              const Text('電話 : 09xxxxxxx', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/historyList');
                },
                child: const Text("歷史紀錄"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/tracking');
                },
                child: const Text("目前檢測追蹤數量"),
              ),
              const SizedBox(height: 10),
              ElevatedButton( onPressed: () {  }, child: Text("修改設定")),
              const Spacer(), // 👈 登出永遠在最下方
              ElevatedButton(
                onPressed: () {
                  // 登出邏輯
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.red), 
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  ),
                ),
                child: const Text("登出", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

