import 'package:flutter/material.dart';
import '../widgets/flashlight_button.dart';
import '../widgets/setting_button.dart';


class DetectBottomBar extends StatelessWidget {
  const DetectBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.deepPurple,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const[
          Expanded(child: Align(alignment: Alignment.center, child: FlashlightButton(),)),
          Expanded(child: Align(alignment: Alignment.center, child: SettingButton(),))


        ]
      )
    );
  }
}
