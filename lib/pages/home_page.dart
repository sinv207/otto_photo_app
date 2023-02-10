import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otto_photo_app/blocs/photos/photos_bloc.dart';
import 'package:otto_photo_app/repositories/photos_repository.dart';
import 'package:otto_photo_app/services/api.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../configs/enums.dart';
import '../widgets/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () async {},
              icon: const Icon(Icons.favorite),
              tooltip: "Favorites"),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle),
              tooltip: "Sign In"),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: replace by bloc
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
