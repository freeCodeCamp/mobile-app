import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_viewmodel.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stacked/stacked.dart';

class NewsImageView extends StatelessWidget {
  const NewsImageView({
    Key? key,
    required this.imgUrl,
    required this.isDataUrl,
  }) : super(key: key);

  final String imgUrl;
  final bool isDataUrl;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => NewsImageModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: Tooltip(
                message: 'Back',
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
              ),
        ),
        body: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            backgroundBlendMode: BlendMode.color,
          ),
          imageProvider: isDataUrl
              ? MemoryImage(base64Decode(imgUrl.split(',').last))
              : NetworkImage(imgUrl) as ImageProvider,
        ),
      ),
    );
  }
}
