import 'package:flutter/material.dart';

import '../components/display_detect.dart';
import '../widgets/camera_button.dart';
import '../components/detect_bottom_bar.dart';

class DetectScreen extends StatefulWidget {
  const DetectScreen({super.key});

  @override
  State<DetectScreen> createState() => _DetectScreenState();
}

class _DetectScreenState extends State<DetectScreen> {
  bool showInfo = false;

  void toggleInfo() {
    setState(() {
      showInfo = !showInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: DisplayDetect(),
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
