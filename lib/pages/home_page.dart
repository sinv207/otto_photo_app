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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotosBloc(
        repository: PhotosRepository(
          apiClient: ApiService(),
        ),
      )..add(PhotosFetched()),
      child: Scaffold(
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
          child:
              BlocBuilder<PhotosBloc, PhotosState>(builder: (context, state) {
            if (state.status == BlocStatus.success) {
              return PhotoGridView(photos: state.photos);
            } else {
              // Waiting loading
              return const Center(child: LoadingView());
            }

            // TODO: UI when onError
          }),
        ),
      ),
    );
  }
}
