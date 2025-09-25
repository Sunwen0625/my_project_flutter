import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/display_detect.dart';
import '../components/display_gps.dart';
import '../providers/info_provider.dart';
import '../widgets/camera_button.dart';
import '../components/detect_bottom_bar.dart';

class Detect extends StatefulWidget {
  const Detect({super.key});

  @override
  State<Detect> createState() => _DetectState();
}

class _DetectState extends State<Detect> {
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
      body: Consumer<InfoPageProvider>(
        builder: (context, info, child) {
          return Center(
            child: info.showInfo
                ? const DisplayDetect()
                : const DisplayGps(),
          );
        }
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
