import 'package:flutter/material.dart';

import '../components/detect_bottom_bar.dart';
import '../components/display_info.dart';


class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("使用者個人資訊"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body:DisplayInfo(),

      bottomNavigationBar: DetectBottomBar(),

    );
  }
}
