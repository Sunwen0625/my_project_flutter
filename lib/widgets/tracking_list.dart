import 'package:flutter/material.dart';
import '../trackers/centroid_tracker.dart';


class TrackingList extends StatelessWidget {
  final List<Track> tracks;

  const TrackingList({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const Center(
        child: Text(
          "沒有偵測到物件",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final t = tracks[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(t.id.toString()),
          ),
          title: Text(t.label),
          subtitle: Text("信心值 ${(t.score * 100).toStringAsFixed(1)}%"),
        );
      },
    );
  }
}
