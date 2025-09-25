import 'package:flutter/material.dart';
import 'package:my_project/components/display_gps.dart';
import '../widgets/camera_button.dart';


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
      appBar: AppBar(
        title: Text("Project"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
          child: DisplayGps()
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
