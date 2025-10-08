import 'package:flutter/material.dart';
import '../models/detection.dart';
import '../trackers/centroid_tracker.dart';

class TrackProvider with ChangeNotifier {
  final CentroidTracker _tracker = CentroidTracker();

  List<Track> get tracks => _tracker.tracks;

  void updateDetections(List<Detection> detections) {
    _tracker.update(detections);
    notifyListeners();
  }

  void reset() {
    _tracker.reset();
    notifyListeners();
  }
}
