import 'package:flutter/material.dart';

import '../pages/photo_view_page.dart';
import 'photo_item.dart';

class PhotoGridView extends StatelessWidget {
  const PhotoGridView({
    Key? key,
    required this.photos,
  }) : super(key: key);

  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // or 5 items
      ),
      shrinkWrap: true,
      itemCount: photos.length,
      itemBuilder: ((context, index) {
        return Container(
          padding: const EdgeInsets.all(1),
          child: InkWell(
            // onTap: () => {},
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PhotoViewPage(photos: photos, index: index),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                PhotoItem(photo: photos[index], index: index),
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
                    ))
              ],
            ),
          ),
        );
      }),
    );
  }
}
