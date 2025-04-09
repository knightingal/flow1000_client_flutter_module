import 'dart:convert';

import 'package:flow1000_admin/scroll.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'struct/album_info.dart';
import 'struct/slot.dart';

class AlbumContentPage extends StatefulWidget {
  const AlbumContentPage({super.key, required this.albumIndex});

  final int albumIndex;

  @override
  State<StatefulWidget> createState() {
    return AlbumContentPageState();
  }

}

class AlbumContentPageState extends State<AlbumContentPage> {

  late double width;
  Future<List<AlbumInfo>> fetchAlbumIndex() async {
    final response = await http.get(Uri.parse(albumContentUrl(widget.albumIndex)));
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = jsonDecode(response.body);
      List<AlbumInfo> albumInfoList = jsonArray.map((e) => AlbumInfo.fromJson(e)).toList();
      return albumInfoList;
    } else {
      throw Exception("Failed to load album");
    }
  }

  late Future<List<AlbumInfo>> futureAblumList;

  List<AlbumInfo> albumInfoList = [];
  List<Slot> slot = [Slot()];

  @override
  void initState() {
    super.initState();
    fetchAlbumIndex().then((albumInfoList) {
      for (int i = 0; i < albumInfoList.length; i++) {
        AlbumInfo albumInfo = albumInfoList[i];
        double coverWidth = width / slot.length;
        double coverHeight = albumInfo.coverHeight * (coverWidth / albumInfo.coverWidth);
        // log("coverHeight:$coverHeight, coverWidth:$coverWidth");
        albumInfo.realHeight = coverHeight;
        albumInfo.realWidth = coverWidth;

        int slotIndex = minSlot(slot);
        Slot slotOne = slot[slotIndex];
        slotOne.slotItemList
            .add(SlotItem(i, slotOne.totalHeight, coverHeight, slotIndex));
        slotOne.totalHeight = slotOne.totalHeight + coverHeight;
      }
      setState(() {
        this.albumInfoList = albumInfoList;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    Widget body;
    if (albumInfoList.isEmpty) {
      body = Text("AlbumIndexPage");
    } else {
      body = CustomScrollViewExample(
        slots: slot, 
        builder: (BuildContext context, int index) {
          return Image.network(
            key: Key("content-$index"),
            albumInfoList[index].toCoverUrl(), 
            width: albumInfoList[index].realWidth, 
            height: albumInfoList[index].realHeight,
          );
        }, 
        totalLength: albumInfoList.length
      );
    }
    return body;
  }
  
}