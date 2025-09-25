import 'package:flutter/material.dart';

class InfoButton extends StatefulWidget {
  const InfoButton({super.key});

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
  bool isOpen = false;

  Future<void> _toggleInfo() async {
    setState(() {
      isOpen = !isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        print("info");
        _toggleInfo();
      },
      icon: isOpen
          ? const Icon(Icons.info_outline, color: Colors.white, size: 40)
          : const Icon(Icons.info, color: Colors.white, size: 40),
    );
  }
}
