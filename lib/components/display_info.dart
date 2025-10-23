import 'package:flutter/material.dart';
import 'package:my_project/providers/state_provider.dart';

import '../providers/detect_provider.dart';
import 'package:provider/provider.dart';

const menuItem = [
DropdownMenuItem(
value: '', child: Text('none')),
DropdownMenuItem(
value: 'yolo11n_int8', child: Text('yolo11n_int8')),
DropdownMenuItem(
value: 'redline_int8', child: Text('redline_int8')),
DropdownMenuItem(
value: 'redline_plus_int8', child: Text('redline_plus_int8')),
DropdownMenuItem(
value: 'redline_plus2_int8', child: Text('redline_plus2_int8')),
];

class DisplayInfo extends StatelessWidget {
  const DisplayInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // ✅ 包含監聽 DetectProvider 的區塊
          Consumer<DetectProvider>(
            builder: (context, detect, child) {
              return Column(
                children: [
                  Text('使用者名稱 : xxx',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text('身分證 : xxxxxxxx',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text('電話 : 09xxxxxxx',
                      style: const TextStyle(fontSize: 20)),
                ],
              );
            },
          ),
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
          ElevatedButton(
            onPressed: () {},
            child: const Text("修改設定"),
          ),
          const SizedBox(height: 10),
          Consumer<StateProvider>(builder:(context, state, child){
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    state.toggleDevMode();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      state.isDevMode ? Colors.green : Colors.red,
                    ),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  child: const Text("開發者模式"),
                ),
                // 🔽 YOLO 模型選擇（僅在開發者模式開啟時顯示）
                if (state.isDevMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: DropdownButtonFormField<String>(
                      initialValue: state.selectedYoloModel, // 預設選中的模型（你需要在 StateProvider 裡定義）
                      decoration: const InputDecoration(
                        labelText: "選擇 YOLO 模型",
                        border: OutlineInputBorder(),
                      ),
                      items: menuItem,
                      onChanged: (value) {
                        if (value != null) {
                          state.setYoloModel(value); // 這裡去更新選擇的模型
                        }
                      },
                    ),
                  ),

              ],
            );
          }),

          const Spacer(), //  登出永遠在最下方
          ElevatedButton(
            onPressed: () {
              // 登出邏輯
            },
            style: ButtonStyle(
              backgroundColor:
              WidgetStateProperty.all(Colors.red), 
              foregroundColor:
              WidgetStateProperty.all(Colors.white), 
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
  }
}

