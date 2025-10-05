import 'package:flutter/material.dart';
import '../screens/detect_screen.dart';
import '../screens/home.dart';
import '../screens/info_screen.dart';


class AppRoutes {
  // 統一管理路由名稱
  static const String detect = '/';
  static const String home = '/home';
  static const String info = '/info';

  // 路由表
  static Map<String, WidgetBuilder> routes = {
    detect: (context) => DetectScreen(),
    home: (context) => HomePage(),
    info: (context) => InfoScreen(),
  };
}
