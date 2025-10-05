import 'package:flutter/material.dart';

import '../components/detect_bottom_bar.dart';
import '../components/display_info.dart';


class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body:SingleChildScrollView(
        child:Column(
          children: [
            DisplayInfo(),
          ],
        ),
      ),
      bottomNavigationBar: DetectBottomBar(),

    );
  }
}
