import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/info_provider.dart';

class InfoButton extends StatefulWidget {
  const InfoButton({super.key});

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoPageProvider>(
        builder: (context, info, child) {
          return IconButton(
            onPressed: () {
              print("info");

              info.toggleInfo();
            },
            icon: info.showInfo
                ? const Icon(Icons.info_outline, color: Colors.white, size: 40)
                : const Icon(Icons.info, color: Colors.white, size: 40),
          );
        }

    );
  }
}
