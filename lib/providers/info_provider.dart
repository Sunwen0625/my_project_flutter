

import 'package:flutter/cupertino.dart';

class InfoPageProvider with ChangeNotifier{
  bool _showInfo = false;

  bool get showInfo => _showInfo;

  void toggleInfo(){
    _showInfo = !_showInfo;
    notifyListeners();
  }
}