import 'package:flutter/material.dart';

import '../components/project_appbar.dart';



class Detect extends StatefulWidget {
  const Detect({super.key});

  @override
  State<Detect> createState() =>
      _DetectState();
}

class _DetectState extends State<Detect> {
  bool _isCamera = true; // 初始狀態是相機

  void _toggleIcon() {
    setState(() {
      _isCamera = !_isCamera;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProjectAppbar(),
      body: const Center(
        child: Text("主要內容區域"),
      ),
      bottomNavigationBar: SafeArea(
          top: false,
        child: Padding(
          padding:EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child:  Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 90,
              height: 90,
              child: FloatingActionButton(
                onPressed: _toggleIcon,
                shape: const CircleBorder(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      RotationTransition(turns: animation, child: child),
                  child: _isCamera
                      ? const Icon(Icons.camera_alt, size: 40, key: ValueKey("camera"))
                      : const Icon(Icons.close, size: 40, key: ValueKey("close")),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}