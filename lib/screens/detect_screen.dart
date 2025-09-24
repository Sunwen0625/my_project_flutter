import 'package:flutter/material.dart';
import '../widgets/camera_button.dart';

import '../components/project_appbar.dart';
import '../components/detect_bottom_bar.dart';

class Detect extends StatefulWidget {
  const Detect({super.key});

  @override
  State<Detect> createState() => _DetectState();
}

class _DetectState extends State<Detect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProjectAppbar(),
      body: const Center(
          child: Text("主要內容區域")
      ),
      floatingActionButton: SizedBox(
        width: 90,
        height: 90,
        child: CameraButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: DetectBottomBar(),
    );
  }
}
