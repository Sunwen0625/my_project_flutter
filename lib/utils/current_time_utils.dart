import 'package:intl/intl.dart';


class CurrentTimeUtils {
  String getCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy/MM/dd - HH:mm:ss');
    return formatter.format(now);
  }
}