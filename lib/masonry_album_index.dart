import 'package:flutter/material.dart';

class MasonryAlbumIndex extends StatefulWidget {
  const MasonryAlbumIndex({super.key, required this.album});

  final String album;

  @override
  State<StatefulWidget> createState() {
    return AnimatedGridState();
  }
}

class MasonryAlbumIndexState extends State<MasonryAlbumIndex> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
