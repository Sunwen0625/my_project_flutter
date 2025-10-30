import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrUtil {
  /// 辨識圖片文字
  /// [imageFile] 是要辨識的圖片
  /// 回傳辨識出的文字（全部文字）
  static Future<String> recognizeText(File imageFile) async {
    try {
      // 增強對比度
      final enhancedFile = await _enhanceImage(imageFile);
      // 建立輸入圖片
      final inputImage = InputImage.fromFile(enhancedFile);


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

  static Future<File> _enhanceImage(File imageFile) async {
    // 讀取圖片 bytes
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    // 銳化濾鏡 kernel
    final sharpenKernel = [
      0, -1,  0,
      -1,  5, -1,
      0, -1,  0,
    ];

    final cmd = img.Command()
      ..image(image!)
      ..grayscale()// 1️⃣ 轉灰階（去除顏色干擾）
      ..contrast(contrast: 40)// 2️⃣ 提升對比度
      ..convolution(filter: sharpenKernel, amount: 1)// 3️⃣ 銳化邊緣
     // ..sobel(amount: 0.3) // 邊緣增強（可調）
      ..encodeJpg();// 重新編碼


    // 進行圖片處理
    final processed = await cmd.getImageThread();
    // 重新編碼
    final enhancedBytes = img.encodeJpg(processed!, quality: 95);
    // 建立暫存輸出檔案
    final enhancedFile = File('${imageFile.path}_contrast.jpg');
    await enhancedFile.writeAsBytes(enhancedBytes);
    return enhancedFile;

  }



  //用來查看增強後的照片
  static Future<File> getEnhancedImage(File imageFile) async {
    return await _enhanceImage(imageFile);
  }


}

