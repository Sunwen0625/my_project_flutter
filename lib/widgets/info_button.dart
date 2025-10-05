import 'package:flutter/material.dart';


class InfoButton extends StatefulWidget {
  const InfoButton({super.key});

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        print("info");
        String? currentRoute = ModalRoute.of(context)?.settings.name;
        print("目前頁面: $currentRoute");
        if (currentRoute =="/"||currentRoute == '/detect') {
          Navigator.pushNamed(context, '/info');
        }else{
          Navigator.pop(context);
        }

      },
      icon: const Icon(Icons.info_outline, color: Colors.white, size: 40)

    );
  }
}
