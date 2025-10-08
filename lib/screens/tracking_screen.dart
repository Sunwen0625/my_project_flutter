import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/track_provider.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("目前偵測到的物件")),
      body: Consumer<TrackProvider>(
        builder: (context, detect, _) {
          final tracks = detect.tracks;

          if (tracks.isEmpty) {
            return const Center(
              child: Text("目前沒有偵測到任何物件"),
            );
          }

          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final t = tracks[index];
              return ListTile(
                leading: CircleAvatar(child: Text(t.id.toString())),
                title: Text(t.label),
                subtitle:
                Text("信心值 ${(t.score * 100).toStringAsFixed(1)}%"),
              );
            },
          );
        },
      ),
    );
  }
}

