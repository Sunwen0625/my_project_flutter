import 'package:flutter/material.dart';
import 'package:my_project/providers/detect_provider.dart';
import '../models/detection.dart';
import '../trackers/centroid_tracker.dart';

class TrackProvider with ChangeNotifier {

  DetectProvider? _detectProvider;
  void setDetect(DetectProvider detectProvider) {
    _detectProvider = detectProvider;
  }



  final CentroidTracker _tracker = CentroidTracker();
  // 用來記錄目前畫面上的 Track IDs
  final Set<int> _currentTrackIds = {};
  List<Track> get tracks => _tracker.tracks;

  void updateDetections(List<Detection> detections) {
    _tracker.update(detections);
    // 取得目前存在的 IDs
    final newIds = _tracker.tracks.map((t) => t.id).toSet();
    // 檢查有沒有新出現的物件
    final newObjects = newIds.difference(_currentTrackIds);
    if (newObjects.isNotEmpty) {
      for (var id in newObjects) {
        final obj = _tracker.tracks.firstWhere((t) => t.id == id);
        _onNewObjectDetected(obj);
      }
    }
    _currentTrackIds
      ..clear()
      ..addAll(newIds);

    notifyListeners();
  }

  /// 當偵測到新物件出現時觸發
  void _onNewObjectDetected(Track track) async {
    debugPrint("🆕 新物件出現：#${track.id} ${track.label} (${track.score})");
    await _detectProvider?.fetchLocation();
    await _detectProvider?.captureImage();

  }

  void reset() {
    _tracker.reset();
    _currentTrackIds.clear();
    notifyListeners();
  }
}

