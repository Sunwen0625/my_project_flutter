// lib/test_yolo.dart
import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:ultralytics_yolo/yolo_view.dart';

class TestYOLO extends StatelessWidget {
  const TestYOLO({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('YOLO Test')),
      body: Center(
        child: YOLOView(
          modelPath: 'yolov8n_int8',
          task: YOLOTask.detect,
          onResult: (results) {
            print('Found ${results.length} objects!');
            for (final result in results) {
              print('${result.className}: ${result.confidence}');
            }
          },

        ),)
    );
  }
}