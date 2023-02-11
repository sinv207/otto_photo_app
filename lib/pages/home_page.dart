import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otto_photo_app/blocs/photos/photos_bloc.dart';
import 'package:otto_photo_app/models/photo_data.dart';
import 'package:otto_photo_app/services/api.dart';

import '../configs/enums.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'photo_view_page.dart';

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

  /// Open photo viewer page with only favorite photos
  _showAllFavorites(PhotosBloc bloc) {
    // Filter favorite photos
    final List<PhotoData> photos = bloc.state.photos
        .where((e) => bloc.state.favorites[e.id] ?? false)
        .toList();

// Only open page when list is not empty
    if (photos.isNotEmpty) {
      // Open photo view page
      Navigator.push(
        context,
        MaterialPageRoute(
          // Open other page with the same bloc value (single instance of PhotosBloc)
          builder: (_) => BlocProvider<PhotosBloc>.value(
            value: bloc,
            child: PhotoViewPage(photos: photos, index: 0),
          ),
        ),
      );
    } else {
      // Dispay message to user on Snackbar (demo only)
      ScaffoldMessenger.of(context)
          .showSnackBar(getSnackBar('Favorite list are empty!'));
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
          // Clear page and refresh new photo list
          bloc.add(PhotosRefreshed());
        },
        color: Colors.blue,
        backgroundColor: Colors.white,
        child: BlocBuilder<PhotosBloc, PhotosState>(
          builder: (context, state) {
            try {
              switch (state.status) {
                // When api are processing
                case BlocStatus.loading:
                  // Waiting loading
                  return const Center(child: LoadingView());

// Photos are loaded successfully: display photos as gallery
                case BlocStatus.success:
                  return PhotoGridView(
                    photos: state.photos,
                    favorites: state.favorites,
                    hasReachedMax: state.hasReachedMax,
                  );

// Fetching failure: display error UI
                case BlocStatus.failure:
                  ScaffoldMessenger.of(context)
                      .showSnackBar(getSnackBar(state.error?.message));

                  return const SizedBox();
                case BlocStatus.initial:
                  // Display UI in-case initial time
                  break;
              }
            } catch (e) {
              // display error popup on UI
              if (e is AppException) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(getSnackBar(e.message));
              }
              // TODO: Call api to send error log to server side or integrate Sentry.io, FirebaseCrashlytic
              print(e);
            }
            // TODO: UI for empty page
            // For demo: defaut display blank container
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
