import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_module/main.dart';
import 'package:flutter_module/struct/album_info.dart';
import 'package:flutter_module/struct/slot.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';

class MasonryAlbumIndex extends StatefulWidget {
  const MasonryAlbumIndex({super.key, required this.album});

  final String album;

  @override
  State<StatefulWidget> createState() {
    return AnimatedGridState();
  }
}

class MasonryAlbumIndexState extends State<MasonryAlbumIndex> {
  late double width;
  Future<List<AlbumInfo>> fetchAlbumIndex() async {
    List<Map<String, Object?>> imgRow = await db.querySectionInfoByAlbum(
      widget.album,
    );

    Directory? directory = await getExternalStorageDirectory();

    String rootPath = "${directory!.path}${Platform.pathSeparator}Download";

    List<AlbumInfo> albumInfoList = imgRow
        .map((e) => AlbumInfo.fromJson(e, rootPath))
        .toList();
    return albumInfoList;
  }

  List<AlbumInfo> albumInfoList = [];

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  final int coverPadding = 8;
  final int titleHeight = 56;
  late SlotGroup slotGroup;

  @override
  void initState() {
    super.initState();
    fetchAlbumIndex().then((albumInfoList) {
      var length = (width > 1500) ? 8 : 2;
      slotGroup = SlotGroup.fromCount(length);
      // slot = List.generate(length, (index) => Slot(), growable: false);
      for (int i = 0; i < albumInfoList.length; i++) {
        AlbumInfo albumInfo = albumInfoList[i];
        int originImgWidth = albumInfo.coverWidth;
        int originImgHeight = albumInfo.coverHeight;

        double frameWidth = width / length;

        double coverImgWidth = frameWidth - coverPadding;
        double coverImgHeight =
            coverImgWidth / originImgWidth * originImgHeight;

        double cardHeight = coverImgHeight + titleHeight;
        double cardWidth = coverImgWidth;

        double frameHeight = cardHeight + coverPadding;

        albumInfo.frameWidth = frameWidth;
        albumInfo.frameHeight = frameHeight;

        albumInfo.cardHeight = cardHeight;
        albumInfo.cardWidth = cardWidth;

        albumInfo.realHeight = coverImgHeight;
        albumInfo.realWidth = coverImgWidth;

        slotGroup.insertSlotItem(SlotItem(i, albumInfo.frameHeight));
      }
      setState(() {
        this.albumInfoList = albumInfoList;
      });
    });
  }
}
