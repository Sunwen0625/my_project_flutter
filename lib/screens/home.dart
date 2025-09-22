import 'package:flutter/material.dart';

import '../components/project_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: ProjectAppbar() ,
      backgroundColor : Colors.grey,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                  width:150 ,
                  'assets/images/logo.jpg',
                  fit: BoxFit.cover
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(onPressed: () {  }, child:Text("登入")),
                SizedBox(width: 10),
                ElevatedButton(onPressed: () {  }, child:Text("註冊"),)
              ],
            )

        ],
        ),
      ),
    );
  }
}
