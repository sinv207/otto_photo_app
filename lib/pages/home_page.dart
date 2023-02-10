import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otto_photo_app/blocs/photos/photos_bloc.dart';
import 'package:otto_photo_app/models/photo_data.dart';
import 'package:otto_photo_app/repositories/photos_repository.dart';
import 'package:otto_photo_app/services/api.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../configs/enums.dart';
import '../widgets/widgets.dart';
import 'photo_view_page.dart';

const snackBar = SnackBar(
  content: Text(
    'Favorite list are empty!',
    textAlign: TextAlign.center,
  ),
);

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO: test
  final apiClient = ApiService();

  @override
  void initState() {
    ApiService().logEnabled = false;
    super.initState();
  }

  _showAllFavorites(PhotosBloc bloc) {
    final List<PhotoData> photos = bloc.state.photos
        .where((e) => bloc.state.favorites[e.id] ?? false)
        .toList();

    if (photos.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider<PhotosBloc>.value(
            value: bloc,
            child: PhotoViewPage(photos: photos, index: 0),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PhotosBloc bloc = BlocProvider.of<PhotosBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () => _showAllFavorites(bloc),
              icon: const Icon(Icons.favorite),
              tooltip: "Filter Favorites"),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          bloc.add(PhotosRefreshed());
        },
        color: Colors.blue,
        backgroundColor: Colors.white,
        child: BlocBuilder<PhotosBloc, PhotosState>(
          builder: (context, state) {
            switch (state.status) {
              case BlocStatus.loading:
                // Waiting loading
                return const Center(child: LoadingView());
              case BlocStatus.success:
                return PhotoGridView(
                  photos: state.photos,
                  favorites: state.favorites,
                  hasReachedMax: state.hasReachedMax,
                );
              case BlocStatus.failure:
                return const Center(child: Text('Fail to load photos!'));
              case BlocStatus.initial:
                // TODO: Handle this case.
                break;
            }

            // TODO: UI when onError
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
