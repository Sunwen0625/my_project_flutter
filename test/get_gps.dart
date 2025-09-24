import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  // 檢查定位服務是否開啟
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  // 檢查/要求權限
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  // 權限OK後取得位置（高精度）
  return Geolocator.getCurrentPosition();
}

class MyGetgps extends StatefulWidget {
  const MyGetgps({super.key});

  @override
  State<MyGetgps> createState() => _MyGetgpsState();
}

class _MyGetgpsState extends State<MyGetgps> {
  Position? _position;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  Future<void> _loadPosition() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final pos = await determinePosition();
      setState(() {
        _position = pos;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get GPS")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Get GPS", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 12),
              if (_loading) const CircularProgressIndicator(),
              if (!_loading && _error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              if (!_loading && _error == null && _position != null)
                Text(
                  'Lat: ${_position!.latitude}\n'
                      'Lng: ${_position!.longitude}\n'
                      'Acc: ${_position!.accuracy} m\n'
                      'Time: ${_position!.timestamp}',
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading ? null : _loadPosition,
                child: const Text('重新取得定位'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
