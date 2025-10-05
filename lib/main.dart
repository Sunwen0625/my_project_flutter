import 'package:flutter/material.dart';
import 'package:my_project/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'package:my_project/providers/detect_provider.dart';
import 'package:my_project/screens/detect_screen.dart';
import 'package:my_project/screens/home.dart';
import 'package:my_project/screens/info_screen.dart';



void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => DetectProvider()),
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