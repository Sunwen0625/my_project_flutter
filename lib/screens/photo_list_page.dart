import 'package:flutter/material.dart';
import 'package:my_project/screens/photo_detail_page.dart';
import 'package:provider/provider.dart';

import '../providers/photo_provider.dart';
import '../widgets/photo_card.dart';


class PhotoListPage extends StatelessWidget {
  const PhotoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final photoProvider = Provider.of<PhotoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('照片清單')),
      body: ListView.builder(
        itemCount: photoProvider.photos.length,
        itemBuilder: (context, index) {
          final photo = photoProvider.photos[index];
          return PhotoCard(
            photo: photo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PhotoDetailPage(photo: photo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}