import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';
import 'pages/pages.dart';
import 'repositories/repositories.dart';
import 'services/api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otto Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => PhotosBloc(
          repository: PhotosRepository(
            apiClient: ApiService(),
          ),
        )..add(PhotosFetched()),
        child: const HomePage(title: 'Otto Photo App'),
      ),
    );
  }
}
