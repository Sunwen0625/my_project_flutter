import 'package:flutter/material.dart';
import '../models/photo_model.dart';

class PhotoCard extends StatelessWidget {
  final PhotoModel photo;
  final VoidCallback onTap;

  const PhotoCard({super.key, required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.purple.shade100,
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashFactory: InkRipple.splashFactory,
        splashColor: Colors.purple,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 違規汽車圖片
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.file(
                photo.cutCarImagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            // 文字區域
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.date,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    photo.address,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "車牌號碼：${photo.licensePlate}",
                    style: const TextStyle(color: Colors.black87),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
