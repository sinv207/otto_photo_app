import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otto_photo_app/blocs/photos/photos.dart';

import '../models/photo_data.dart';
import 'infinite_loader.dart';
import 'photo_gridview_item.dart';

class PhotoGridView extends StatefulWidget {
  const PhotoGridView({
    Key? key,
    required this.photos,
    required this.favorites,
    this.hasReachedMax = true,
  }) : super(key: key);

  final List<PhotoData> photos;
  final Map<String, bool> favorites;
  final bool hasReachedMax;

  @override
  State<PhotoGridView> createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<PhotoGridView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(1),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // or 5 items
      ),
      shrinkWrap: true,
      itemCount: widget.hasReachedMax
          ? widget.photos.length
          : widget.photos.length + 1,
      itemBuilder: ((context, index) {
        return widget.photos.length > index
            ? PhotoGridViewItem(
                photos: widget.photos,
                index: index,
                isFavorite: widget.favorites[widget.photos[index].id] ?? false,
              )
            : const InfiniteLoader();
      }),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      print('load more');
      BlocProvider.of<PhotosBloc>(context).add(PhotosFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
