
import 'package:flutter/material.dart';
import '../models/detection.dart';

class Track {
  final int id;
  String label;
  double score;
  Offset centroid;
  int missedFrames;

  Track({
    required this.id,
    required this.label,
    required this.score,
    required this.centroid,
    this.missedFrames = 0,
  });
}

class CentroidTracker {
  final double distanceThreshold;
  final int maxMissedFrames;
  int _nextId = 1;
  final List<Track> _tracks = [];

  CentroidTracker({
    this.distanceThreshold = 0.1,
    this.maxMissedFrames = 5,
  });

  List<Track> get tracks => List.unmodifiable(_tracks);

  void update(List<Detection> detections) {
    final detCenters = detections.map((d) {
      final cx = (d.left + d.right) / 2;
      final cy = (d.top + d.bottom) / 2;
      return Offset(cx, cy);
    }).toList();

    if (detections.isEmpty) {
      for (var t in _tracks) {
        t.missedFrames++;
      }
      _tracks.removeWhere((t) => t.missedFrames > maxMissedFrames);
      return;
    }

    final unmatchedTracks = List.generate(_tracks.length, (i) => i);
    final matchedDetections = <int>{};

    for (int i = 0; i < detections.length; i++) {
      final c = detCenters[i];
      double minDist = double.infinity;
      int? bestIdx;

      for (var tIdx in unmatchedTracks) {
        final t = _tracks[tIdx];
        final dist = (t.centroid - c).distance;
        if (dist < minDist) {
          minDist = dist;
          bestIdx = tIdx;
        }
      }

      if (bestIdx != null && minDist < distanceThreshold) {
        final t = _tracks[bestIdx];
        final d = detections[i];
        t.label = d.label;
        t.score = d.score;
        t.centroid = c;
        t.missedFrames = 0;
        unmatchedTracks.remove(bestIdx);
        matchedDetections.add(i);
      }
    }

    for (int i = 0; i < detections.length; i++) {
      if (!matchedDetections.contains(i)) {
        final d = detections[i];
        final c = Offset((d.left + d.right) / 2, (d.top + d.bottom) / 2);
        _tracks.add(Track(
          id: _nextId++,
          label: d.label,
          score: d.score,
          centroid: c,
        ));
      }
    }

    for (var i in unmatchedTracks) {
      _tracks[i].missedFrames++;
    }

    _tracks.removeWhere((t) => t.missedFrames > maxMissedFrames);
  }

  void reset() {
    _tracks.clear();
    _nextId = 1;
  }
}
