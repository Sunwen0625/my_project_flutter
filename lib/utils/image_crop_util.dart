import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class ImageCropUtil {
  static Future<File> cropByNormalizedBox({
    required File imageFile,
    required Rect normalizedBox,
    int? index,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception("無法讀取圖片");

    final imgW = image.width;
    final imgH = image.height;

    // ✳️ 把比例轉成實際像素
    final left = (normalizedBox.left * imgW).clamp(0, imgW - 1);
    final top = (normalizedBox.top * imgH).clamp(0, imgH - 1);
    final right = (normalizedBox.right * imgW).clamp(0, imgW);
    final bottom = (normalizedBox.bottom * imgH).clamp(0, imgH);

    final cropW = (right - left).round();
    final cropH = (bottom - top).round();

    // 🔹 開始裁切
    final cropped = img.copyCrop(
      image,
      x: left.round(),
      y: top.round(),
      width: cropW,
      height: cropH,
    );

    // 🔹 儲存
    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/crop_${index! + DateTime.now().millisecondsSinceEpoch}.png";
    final croppedFile = File(path);
    await croppedFile.writeAsBytes(img.encodePng(cropped));

    print("📏 原圖大小: ${imgW}x${imgH}");
    print("🔹 normalizedBox: $normalizedBox");
    print("🎯 實際裁切座標: (${left.round()}, ${top.round()}) → ${cropW}x${cropH}");

    return croppedFile;
  }
}
