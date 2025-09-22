import 'package:flutter/material.dart';

class ProjectAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ProjectAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      title: Text("Project"),
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
