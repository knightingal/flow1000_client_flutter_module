import 'dart:convert';
import 'dart:developer';

import 'package:flow1000_admin/model.dart';
import 'package:flow1000_admin/scroll.dart';
import 'package:flow1000_admin/struct/album_info.dart';
import 'package:flow1000_admin/widget/encript_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'config.dart';
import 'struct/slot.dart';

class AlbumIndexPage extends StatefulWidget{
  const AlbumIndexPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return AlbumIndexState();
  }
}

class AlbumIndexState extends State<AlbumIndexPage> {
  late double width;
  Future<List<AlbumInfo>> fetchAlbumIndex() async {
    final response = await http.get(Uri.parse(albumIndexUrl()));
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = jsonDecode(response.body);
      List<AlbumInfo> albumInfoList = jsonArray.map((e) => AlbumInfo.fromJson(e)).toList();
      return albumInfoList;
    } else {
      throw Exception("Failed to load album");
    }
  }

  List<AlbumInfo> albumInfoList = [];
  List<Slot> slot = [Slot(), Slot(), Slot(), Slot()];

  @override
  void initState() {
    super.initState();
    fetchAlbumIndex().then((albumInfoList) {
      for (int i = 0; i < albumInfoList.length; i++) {
        AlbumInfo albumInfo = albumInfoList[i];
        double coverWidth = width / 4;
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
      body = NotificationListener(
        onNotification: (n) {
          if (n is ScrollEndNotification) {
            // ScrollModel scrollModel = Provider.of(context, listen: false);
            // scrollModel.stopScrolling();
          } else if (n is ScrollStartNotification) {
            // ScrollModel scrollModel = Provider.of(context, listen: false);
            // scrollModel.startScrolling();
          }
          return true;
        },
        child: CustomScrollViewExample(
        slots: slot, 
        builder: (BuildContext context, int index) {
          // return Container(
          //   alignment: Alignment.center,
          //   color: colorPiker[index % 4],
          //   height: albumInfoList[index].realHeight,
          //   // height: 100 ,
          //   width: 0,
          //   child: Text('Item: $index'),
          // );
          return Image.network(albumInfoList[index].toCoverUrl(), width: albumInfoList[index].realWidth, height: albumInfoList[index].realHeight,);
          // return EncriptImageWidget(
          //   src: albumInfoList[index].toCoverUrl(), 
          //   width: albumInfoList[index].realWidth, 
          //   height: albumInfoList[index].realHeight,
          // );
        }, 
        totalLength: albumInfoList.length
      )      
      )
      
      
      ;
    }
    return body;
  }
  
}

class DirItem extends StatelessWidget {
  final String title;

  final int index;
  final void Function(int index, String title) tapCallback;

  const DirItem({
    super.key,
    required this.index,
    required this.title,
    required this.tapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        log("click $title");
        tapCallback(index, title);
      },
      title: Text(title),
    );
  }
}