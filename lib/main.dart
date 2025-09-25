import 'package:flutter/material.dart';
import 'package:my_project/providers/gps_provider.dart';
import 'package:my_project/providers/info_provider.dart';
import 'package:my_project/screens/detect_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => GpsProvider()),
        ChangeNotifierProvider(create: (_) => InfoPageProvider()),
      ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: Detect(),
    );
  }
}