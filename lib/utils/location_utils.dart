import 'package:geolocator/geolocator.dart';

class LocationUtils{
  /// 取得當前位置（需要定位權限）
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. 檢查定位服務是否開啟
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('❌ GPS 定位服務未開啟');
    }

    // 2. 檢查權限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('❌ 定位權限被拒絕');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('❌ 定位權限被永久拒絕，請至設定開啟');
    }

    // 權限OK後取得位置（高精度）
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );
    // 3. 回傳目前位置
    return await Geolocator.getCurrentPosition(locationSettings:locationSettings);
  }

  /// 取得持續更新的位置（適合追蹤）
  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 每移動 10 公尺才更新
      ),
    );
  }
}
