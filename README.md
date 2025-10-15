# 專案名稱：myproject


### 📖 專案簡介

`myproject` 是一個使用 **Flutter + YOLO 物件偵測模型** 的 Android 專案。
主要功能為：

* 即時物件偵測與追蹤
* 自動截圖與圖片裁切
* 圖片與 GPS、地址資訊綁定
* 多頁面顯示（例如偵測頁面、圖片展示頁面）
* 使用 Provider 管理狀態
* 支援手電筒、通知提示、Overlay UI 動畫顯示

---

## 📂 專案結構

```
lib/
├── main.dart                   # 程式入口
├── providers/
│   ├── detect_provider.dart    # 負責 YOLO 偵測、圖片截圖與裁切
│   ├── track_provider.dart     # 負責追蹤狀態與連動偵測資料
│   ├── picture_provider.dart   # 拍照與圖片存取
│
├── pages/
│   ├── detect_page.dart        # YOLO 偵測頁面
│   ├── display_gps_page.dart   # 顯示截圖與 GPS、地址資訊
│   └── gallery_page.dart       # 顯示裁切圖片的卡片列表
│
├── utils/
│   ├── capture_util.dart       # 控制拍照與儲存圖片
│   ├── location_utils.dart     # 取得 GPS 與地址
│   ├── permission_utils.dart   # 權限處理（儲存空間、GPS）
│   ├── flashlight_util.dart    # 控制手電筒開關
│
├── widgets/
│   ├── camera_button.dart      # 拍照按鈕元件
│   ├── flashlight_button.dart  # 手電筒控制按鈕
│   ├── overlay_alert.dart      # 自定義通知（含進出動畫）
│
└── models/
    └── photo_model.dart        # 儲存圖片、座標、時間等資料結構
```

---

## 🧠 主要功能說明

### 🔍 YOLO 物件偵測

* 使用 `ultralytics_yolo` 套件。
* 偵測畫面中物件，回傳：

  ```dart
  YOLOResult{ classIndex, className, confidence, boundingBox }
  ```
* 每次結果更新時觸發 `DetectProvider.getResult()`。
* 自動擷取圖片（`captureImage()`）後依據 YOLO 結果裁切目標。

---

### 🧩 DetectProvider

負責主要邏輯處理：

```dart
class DetectProvider with ChangeNotifier {
  final controller = YOLOViewController();
  File? lastCapture;
  List<File> croppedList = [];

  Future<void> captureImage() async { ... }
  Future<void> getResult(List<YOLOResult> results) async { ... }
  Future<void> fetchLocation() async { ... }
}
```

✅ 功能包含：

* 觸發拍照
* 根據 YOLO bounding box 自動裁切圖片
* 取得 GPS 與地址資訊
* 儲存裁切後圖片進 `croppedList`

---

### 🧭 GPS 定位功能

由 `LocationUtils` 管理：

* 使用 `geolocator` 套件取得當前座標
* 使用 `geocoding` 查詢實際地址
* 權限控管已抽離至 `PermissionUtils`

---

### 💡 手電筒功能

由 `FlashlightUtil` 管理：

```dart
class FlashlightUtil {
  static bool _isOn = false;
  static Future<void> toggle() async {
    if (_isOn) await TorchLight.disableTorch();
    else await TorchLight.enableTorch();
    _isOn = !_isOn;
  }
}
```

在 UI 端可直接使用：

```dart
controller.toggleFlashlight();
```

---

### 🖼️ 圖片展示（Gallery / 卡片頁面）

* 從上到下排列多個圖片卡片（顯示圖片、日期、位置等資訊）
* 可點擊進入詳細資料頁
* 使用 `ListView.builder` 動態生成



### 🧱 狀態管理架構

使用 `Provider` + `ChangeNotifier` 模式：

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => DetectProvider()),
    ChangeNotifierProxyProvider<DetectProvider, TrackProvider>(
      create: (_) => TrackProvider(),
      update: (_, detect, track) => track!..setDetect(detect),
    ),
  ],
  child: MyApp(),
);
```

---

## 🚀 當前開發進度

| 模組                    | 狀態      | 備註                |
| --------------------- | ------- | ----------------- |
| YOLO 偵測               | ✅ 已完成   | 可正常取得結果與座標        |
| 圖片裁切                  | ⚠️ 修正中  | 第一張圖片會重複顯示，需要刷新邏輯 |
| GPS 定位                | ✅ 已完成   | 可正確取得經緯度與地址       |
| 權限控管                  | ✅ 已完成   | 已抽離封裝             |
| 手電筒控制                 | ✅ 已完成   | 可直接控制開關           |
| 通知提示 Overlay          | ✅ 已完成   | 動畫正常顯示            |
| 圖片卡片頁面                | 🛠️ 開發中 | 預計顯示裁切結果與資訊       |
| 狀態同步 (Detect ↔ Track) | ✅ 已串接   | 使用 ProxyProvider  |

---



## 🧩 啟動方式

```bash
flutter pub get
flutter run
```


