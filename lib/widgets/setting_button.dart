import 'package:flutter/material.dart';

class SettingButton extends StatefulWidget {
  const SettingButton({super.key});

  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {print("setting");},
      icon: const Icon(Icons.settings, color: Colors.white,size: 40,),
    );
  }
}
