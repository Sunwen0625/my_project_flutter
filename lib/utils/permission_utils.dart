import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  /// 檢查並請求相機權限
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // 永遠拒絕 → 只能去設定
      return false;
    }
    // 其他情況（單純拒絕）→ 下次再開啟還會再詢問
    return false;
  }


  /// 直接檢查相機權限（不會跳出請求）
  static Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  /// 請求儲存空間權限（主要針對 Android）
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// 檢查儲存空間權限
  static Future<bool> hasStoragePermission() async {
    return await Permission.storage.isGranted;
  }

  /// 開啟 App 設定頁面（當使用者永遠拒絕時可引導）
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}