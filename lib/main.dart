import 'package:flutter/material.dart';
import 'package:my_project/providers/photo_provider.dart';
import 'package:my_project/providers/state_provider.dart';
import 'package:my_project/providers/track_provider.dart';
import 'package:my_project/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'package:my_project/providers/detect_provider.dart';




void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProxyProvider<PhotoProvider, DetectProvider>(
          create: (_) => DetectProvider(),
          update: (_, photo, detect) {
            detect!.setPhotoProvider(photo);
            return detect;
          },
        ),
        ChangeNotifierProxyProvider<DetectProvider,StateProvider>(
          create: (_) => StateProvider(),
          update: (_, detect, state) {
            state!.setDetect(detect);
            return state;
          },
        ),
        ChangeNotifierProxyProvider<DetectProvider,TrackProvider>(
          create: (_) => TrackProvider(),
          update: (_, detect, track) {
            track!.setDetect(detect);
            return track;
            },
        ),
      ],
        child: const MyApp(),
      )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      initialRoute: AppRoutes.detect,
      routes: AppRoutes.routes,
    );
  }
}