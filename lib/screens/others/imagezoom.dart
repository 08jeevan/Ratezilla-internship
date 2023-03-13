import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageZoom extends StatelessWidget {
  final String imgUrl;
  const ImageZoom({required this.imgUrl, super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkModeOn == false? Colors.white : const Color(0xff303030),
      ),
      body: Container(
        child: Hero(
          tag: 'fullscreen',
          child: Center(
              child: PhotoView(
            imageProvider: NetworkImage(imgUrl),
          ),),
        ),
      ),
    );
  }
}
