

import 'package:flutter/cupertino.dart';

class InfoPageProvider with ChangeNotifier{
  int _pageIndex = 0; // 0 = A頁, 1 = B頁

  int get pageIndex => _pageIndex;

  void togglePage() {
    _pageIndex = _pageIndex == 0 ? 1 : 0;
    notifyListeners();
  }
}