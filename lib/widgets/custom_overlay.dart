

import 'package:flutter/material.dart';

/// 可重用的頂部提示組件
class CustomOverlay extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final VoidCallback onClose;
  final Duration duration;

  const CustomOverlay({
    super.key,
    required this.message,
    this.backgroundColor = Colors.red,
    required this.onClose,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<CustomOverlay> createState() => CustomOverlayState();
}

class CustomOverlayState extends State<CustomOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  Future<void> dismiss() async {
    await _controller.reverse();
    if (mounted) {
      widget.onClose();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 12;
    return Positioned(
      top: top,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.white, size: 40),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: dismiss,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 工具函式：顯示 Overlay
void showCustomOverlay(
    BuildContext context, {
      required String message,
      Color backgroundColor = Colors.red,
      Duration displayDuration = const Duration(seconds: 3),
    }) {
  final overlay = Overlay.of(context, rootOverlay: true);
  OverlayEntry? entry;
  final key = GlobalKey<CustomOverlayState>();

  entry = OverlayEntry(
    builder: (ctx) => CustomOverlay(
      key: key,
      message: message,
      backgroundColor: backgroundColor,
      onClose: () {
        entry?.remove();
        entry = null;
      },
    ),
  );

  overlay.insert(entry!);

  // 自動消失（有動畫）
  Future.delayed(displayDuration, () async {
    if (key.currentState != null && entry?.mounted == true) {
      await key.currentState!.dismiss();
    }
  });
}
