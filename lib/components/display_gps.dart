import 'package:flutter/material.dart';

import '../providers/gps_provider.dart';
import 'package:provider/provider.dart';


class DisplayGps extends StatelessWidget {
  const DisplayGps({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GpsProvider>(
      builder: (context, gps, child) {
        return Column(
          children: [
            const Text("Display GPS:"),
            Text("lat: ${gps.lat} -- long: ${gps.long}"),
          ]
        );
      }

    );
  }
}

