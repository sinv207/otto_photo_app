import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otto_photo_app/blocs/photos/photos.dart';
import 'package:otto_photo_app/configs/enums.dart';
import 'package:otto_photo_app/models/photo_data.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../widgets/widgets.dart';

class PhotoViewPage extends StatefulWidget {
  final List<PhotoData> photos;
  final int index;

  const PhotoViewPage({
    Key? key,
    required this.photos,
    required this.index,
  }) : super(key: key);

  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  late bool isFavorite;
  late PhotosBloc _photosBloc;
  late int currentIndex;

  /// On page changed: Update current photo's index and favorite icon (on/off) base on current photo
  _onPageChanged(idx) {
    print('_onPageChanged');
    setState(() {
      currentIndex = idx;
      isFavorite = _photosBloc.state.favorites[widget.photos[idx].id] ?? false;
    });
  }

  @override
  void initState() {
    // init time: get photoBloc in current context
    _photosBloc = BlocProvider.of<PhotosBloc>(context);

    // assign props to state
    currentIndex = widget.index;

    // Check current photo is contained in favorites list
    isFavorite =
        _photosBloc.state.favorites[widget.photos[currentIndex].id] ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhotosBloc, PhotosState>(
      listener: (context, state) {
        // Update favorite icon (on/off) after user bookmark favorite (event FavoriteUpdated)
        if (state.status == BlocStatus.success) {
          setState(() {
            isFavorite =
                state.favorites[widget.photos[currentIndex].id] ?? false;
          });
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('${currentIndex + 1} / ${widget.photos.length}'),
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  // User tap on icon to toggle "favorite status" on current photo
                  _photosBloc.add(FavoriteUpdated(
                      widget.photos[currentIndex].id, !isFavorite));
                },
                icon: Icon(
                  // display favorite icon base on "favorite status"
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                tooltip: "Add Favorite",
              ),
            ),
          ],
        ),
        body: PhotoViewGallery.builder(
          enableRotation: true,
          pageController: PageController(initialPage: widget.index),
          itemCount: widget.photos.length,
          onPageChanged: _onPageChanged,
          builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
            child: CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: widget.photos[index].photoUrl,
              placeholder: (context, url) => const PhotoPlaceholder(),
              errorWidget: (context, url, error) => const PhotoNotFound(),
            ),
            heroAttributes: PhotoViewHeroAttributes(
              tag: widget.photos[index],
            ),
            minScale: PhotoViewComputedScale.covered,
          ),
        ),
      ),
    );
  }
}
