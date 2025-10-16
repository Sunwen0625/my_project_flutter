import 'package:flutter/material.dart';
import 'package:my_project/models/photo_model.dart';

class PhotoProvider with ChangeNotifier {
  final List<PhotoModel> _photos = [
    PhotoModel(
        imagePath: 'android/app/src/main/assets/images/logo.jpg',
        cutImagePath: 'android/app/src/main/assets/images/logo.jpg',
        date: '2025/10/15 - 22:22:21',
        address: 'xxxx',
        longitude: 'xx.xxxx',
        latitude: 'xx.xxxx',
        licensePlate: 'xxx-xxxx'
    ),
  ];

  List<PhotoModel> get photos => _photos;

  void addPhoto(PhotoModel photo) {
    _photos.add(photo);
    notifyListeners();
  }
}