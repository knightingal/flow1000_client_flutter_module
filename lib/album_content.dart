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
  Future<SectionDetail> fetchAlbumIndex() async {
    final response = await http.get(Uri.parse(albumContentUrl(widget.albumIndex)));
    if (response.statusCode == 200) {
      dynamic jsonArray = jsonDecode(response.body);
      SectionDetail albumInfoList = SectionDetail.fromJson(jsonArray);
      return albumInfoList;
    } else {
      throw Exception("Failed to load album");
    }
  }


  SectionDetail? albumInfoList;
  List<Slot> slot = [Slot()];

  @override
  void initState() {
    super.initState();
    fetchAlbumIndex().then((albumInfoList) {
      for (int i = 0; i < albumInfoList.pics.length; i++) {
        ImgDetail albumInfo = albumInfoList.pics[i];
        double coverHeight;
        double coverWidth;
        if (slot.length == 1 && width > albumInfo.width) {
          coverWidth = albumInfo.width.toDouble();
          coverHeight = albumInfo.height.toDouble();
        } else {
          coverWidth = width / slot.length;
          coverHeight = albumInfo.height * (coverWidth / albumInfo.width);
        }

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
    if (albumInfoList == null || albumInfoList!.pics.isEmpty) {
      body = Text("AlbumIndexPage");
    } else {
      body = CustomScrollViewExample(
        slots: slot, 
        builder: (BuildContext context, int index) {
          return Image.network(
            key: Key("content-$index"),
            albumInfoList!.pics[index].toUrl(albumInfoList!), 
            width: albumInfoList!.pics[index].realWidth, 
            height: albumInfoList!.pics[index].realHeight,
          );
        }, 
        totalLength: albumInfoList!.pics.length
      );
    }
    return body;
  }
  
}