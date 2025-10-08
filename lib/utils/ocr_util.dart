import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrUtil {
  /// 辨識圖片文字
  /// [imageFile] 是要辨識的圖片
  /// 回傳辨識出的文字（全部文字）
  static Future<String> recognizeText(File imageFile) async {
    try {
      // 建立輸入圖片
      final inputImage = InputImage.fromFile(imageFile);

      // 建立文字辨識器 (latin 通用語系, 若要中文請改成 TextRecognitionScript.chinese)
      final textRecognizer = TextRecognizer(
          script: TextRecognitionScript.latin);

      // 執行辨識
      final RecognizedText result = await textRecognizer.processImage(
          inputImage);

      // 關閉辨識器
      await textRecognizer.close();

      return result.text;
    } catch (e) {
      print("⚠️ OCR 辨識錯誤: $e");
      return "OCR 辨識失敗";
    }
  }

  /// 辨識後回傳每個文字區塊資訊（含框框）
  static Future<List<Map<String, dynamic>>> recognizeBlocks(File imageFile) async {
    final List<Map<String, dynamic>> blocks = [];
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText result = await textRecognizer.processImage(inputImage);

      for (var block in result.blocks) {
        blocks.add({
          'text': block.text,
          'boundingBox': block.boundingBox.toString(),
        });
      }

      await textRecognizer.close();
      return blocks;
    } catch (e) {
      print("⚠️ OCR 區塊辨識錯誤: $e");
      return [];
    }
  }
}