import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoItem extends StatelessWidget {
  const PhotoItem({
    Key? key,
    required this.photo,
    required this.index,
  }) : super(key: key);

  final String photo;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${photo}_$index',
      // child: Image.network(photos[index]),
      child: CachedNetworkImage(
        imageUrl: photo,
        fit: BoxFit.cover,
        placeholder: (context, url) => const PhotoPlaceholder(),
        errorWidget: (context, url, error) => const PhotoNotFound(),
      ),
    );
  }
}

class PhotoNotFound extends StatelessWidget {
  const PhotoNotFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[400],
    );
  }
}

class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[400],
    );
  }
}
