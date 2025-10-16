import 'package:flutter/material.dart';
import 'package:my_project/models/photo_model.dart';

class PhotoProvider with ChangeNotifier {
  final List<PhotoModel> _photos = [];

  List<PhotoModel> get photos => _photos;

  void addPhoto(PhotoModel photo) {
    _photos.add(photo);
    notifyListeners();
  }
}