import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> fetchPhotos() async {
    // TODO: common api service
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random/20'));
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    // print('Response data: ${data}');
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
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
          await fetchPhotos();
          // TODO: replace by bloc
          setState(() {});
        },
        color: Colors.blue,
        backgroundColor: Colors.white,
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: FutureBuilder<Map<String, dynamic>>(
              future: fetchPhotos(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                print('snapshot changed');
                if (snapshot.hasData) {
                  final List<String> photos =
                      ((snapshot.data as Map)['message'] as List)
                          .map<String>((m) => m.toString())
                          .toList();

                  // print('photos: ${photos}');

                  return PhotoGridView(photos: photos);
                } else {
                  // Waiting loading
                  return const LoadingView();
                }

                // TODO: UI when onError
              }),
        ),
      ),
    );
  }
}
