import 'dart:io';

import 'package:flutter/cupertino.dart';
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

      // 清理文字
      String rawText = _cleanedText(result.text);
      return rawText;
    } catch (e) {
      debugPrint("⚠️ OCR 辨識錯誤: $e");
      return "OCR 辨識失敗";
    }
  }

  static String _cleanedText(String ocrText) {
    // 🔹 清理步驟：
    // 移除所有空白與換行
    // 全部轉成大寫
    // 將所有特殊符號（-_.~）轉換成 -
    debugPrint("🧾 OCR 原始: $ocrText");
    String cleanedText = ocrText
      .toUpperCase() // 全部大寫
      .replaceAll(RegExp(r'[-_.~]'), '-') //將所有特殊符號（-_.~）轉換成 -
      .replaceAll(RegExp(r'\s+'), ''); // 移除空白與換行


    debugPrint("🧾 OCR 清理: $cleanedText");
    return cleanedText;
  }

  static bool isOcrTextValid(String ocrText) {
    final len = ocrText.length;
    return ocrText.contains('-')
        ? (len == 7 || len == 8)
        : (len == 6 || len == 7);
  }
}

