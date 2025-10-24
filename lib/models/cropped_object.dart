import 'dart:io';

class CroppedObject {
  final File file;
  final String label;
  final double confidence;

  CroppedObject({
    required this.file,
    required this.label,
    required this.confidence,
  });
}