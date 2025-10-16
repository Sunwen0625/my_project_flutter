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
    final photos = photoProvider.photos.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('照片清單')),
      body: photos.isEmpty
          ? const Center(child: Text("目前沒有任何照片"))
          : ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
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