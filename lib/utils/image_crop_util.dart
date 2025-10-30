import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class ImageCropUtil {
  static Future<File> cropByNormalizedBox({
    required File imageFile,
    required Rect normalizedBox,
    int? index,
    double expandRatio = 0.1, // 預設擴張 10%
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception("無法讀取圖片");

    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();

    // ✳️ 擴張 normalized box（中心不變，寬高放大）
    double width = normalizedBox.width;
    double height = normalizedBox.height;
    double centerX = normalizedBox.left + width / 2;
    double centerY = normalizedBox.top + height / 2;

    width *= (1 + expandRatio);
    height *= (1 + expandRatio);

    // ✳️ 把比例轉成實際像素
    double left = (centerX - width / 2).clamp(0.0, 1.0);
    double top = (centerY - height / 2).clamp(0.0, 1.0);
    double right = (centerX + width / 2).clamp(0.0, 1.0);
    double bottom = (centerY + height / 2).clamp(0.0, 1.0);

    // ✳️ 把比例轉成實際像素
    final leftPx = (left * imgW).clamp(0, imgW - 1);
    final topPx = (top * imgH).clamp(0, imgH - 1);
    final rightPx = (right * imgW).clamp(0, imgW);
    final bottomPx = (bottom * imgH).clamp(0, imgH);

    final cropW = (rightPx - leftPx).round();
    final cropH = (bottomPx - topPx).round();

    // 🔹 開始裁切
    final cropped = img.copyCrop(
      image,
      x: leftPx.round(),
      y: topPx.round(),
      width: cropW,
      height: cropH,
    );

    // 🔹 儲存
    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/crop_${index! + DateTime.now().millisecondsSinceEpoch}.png";
    final croppedFile = File(path);
    await croppedFile.writeAsBytes(img.encodePng(cropped));

    debugPrint("📏 原圖大小: ${imgW.toInt()}x${imgH.toInt()}");
    debugPrint("🔹 原 normalizedBox: $normalizedBox");
    debugPrint("🔹 擴張後: L=$left, T=$top, R=$right, B=$bottom");
    debugPrint("🎯 實際裁切: (${leftPx.round()}, ${topPx.round()}) → ${cropW}x$cropH");

    return croppedFile;
  }


}
