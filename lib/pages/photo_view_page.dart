import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../widgets/widgets.dart';

class PhotoViewPage extends StatelessWidget {
  final List<String> photos;
  final int index;

  const PhotoViewPage({
    Key? key,
    required this.photos,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
              tooltip: "Add Favorite",
            ),
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        enableRotation: true,
        pageController: PageController(initialPage: index),
        itemCount: photos.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: photos[index],
            placeholder: (context, url) => const PhotoPlaceholder(),
            errorWidget: (context, url, error) => const PhotoNotFound(),
          ),
          heroAttributes: PhotoViewHeroAttributes(
            tag: photos[index],
          ),
          minScale: PhotoViewComputedScale.covered,
        ),
      ),
    );
  }
}
