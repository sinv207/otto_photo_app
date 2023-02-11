import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import '../pages/pages.dart';
import 'photo_item.dart';

class PhotoGridViewItem extends StatelessWidget {
  const PhotoGridViewItem({
    Key? key,
    required this.photos,
    required this.index,
    required this.isFavorite,
  }) : super(key: key);

  final List<PhotoData> photos;
  final int index;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            // Open other page with the same bloc value (single instance of PhotosBloc)
            builder: (_) => BlocProvider<PhotosBloc>.value(
              value: BlocProvider.of<PhotosBloc>(context),
              child: PhotoViewPage(photos: photos, index: index),
            ),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PhotoItem(photo: photos[index].photoUrl, index: index),
            // TODO: test only
            // Text(
            //   '${index + 1}',
            //   style: const TextStyle(color: Colors.white),
            // ),

            // Check and display favorite icon of current photo
            if (isFavorite)
              const Positioned(
                bottom: 0,
                // left: 0,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 18.0,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
