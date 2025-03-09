import 'dart:developer';

import 'package:flow1000_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlbumIndexPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AlbumIndexState();
  }

  
}

class AlbumIndexState extends State<AlbumIndexPage> {
  Future<String> fetchAlbumIndex() async {
    final response = await http.get(Uri.parse(albumIndexUrl()));
    if (response.statusCode == 200) {
      log(response.body);
      return response.body;
    } else {
      throw Exception("Failed to load album");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAlbumIndex();

  }

  @override
  Widget build(BuildContext context) {
    return Text("AlbumIndexPage");
  }
  
}