import 'package:flutter/material.dart';

import '../models/photo_model.dart';

class PhotoDetailPage extends StatelessWidget {
  final PhotoModel photo;

  const PhotoDetailPage({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('詳細資料')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 原始圖片
                Text("原始圖片", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Image.file(photo.imagePath, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 16),
        
                // 裁切圖片
                Text("裁切圖片", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Image.file(photo.cutImagePath, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 16),
        
                // 文字資訊
                Text("拍攝日期：${photo.date}", style: const TextStyle(fontSize: 16)),
                Text("地址：${photo.address}", style: const TextStyle(fontSize: 16)),
                Text("經度：${photo.longitude}", style: const TextStyle(fontSize: 16)),
                Text("緯度：${photo.latitude}", style: const TextStyle(fontSize: 16)),
                Text("車牌：${photo.licensePlate}", style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}