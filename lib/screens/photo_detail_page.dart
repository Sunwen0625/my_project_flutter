import 'package:flutter/material.dart';

import '../models/photo_model.dart';

class PhotoDetailPage extends StatelessWidget {
  final PhotoModel photo;

  const PhotoDetailPage({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('詳細資訊')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(photo.imagePath, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(photo.date, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(photo.address, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Text(photo.licensePlate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}