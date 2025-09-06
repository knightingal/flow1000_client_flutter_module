import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';
import 'scroll.dart';
import 'section_content.dart';
import 'struct/album_info.dart';
import 'struct/slot.dart';

class AlbumIndexPage extends StatefulWidget {
  const AlbumIndexPage({super.key, required this.album});

  final String album;

  @override
  State<StatefulWidget> createState() {
    return AlbumIndexState();
  }
}

class AlbumIndexState extends State<AlbumIndexPage> {
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
  // late List<Slot> slot;

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

  Widget _generateImageContainer(int index) {
    var url = albumInfoList[index].toCoverUrl();
    if (url.endsWith(".avif")) {
      return AvifImage.file(
        width: albumInfoList[index].realWidth,
        height: albumInfoList[index].realHeight,
        key: Key("image-$index"),
        File(url),
      );
    } else {
      return Image.file(
        width: albumInfoList[index].realWidth,
        height: albumInfoList[index].realHeight,
        key: Key("image-$index"),
        File(albumInfoList[index].toCoverUrl()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    Widget body;
    if (albumInfoList.isEmpty) {
      body = Text("AlbumIndexPage");
    } else {
      body = CustomScrollViewWrap(
        slots: slotGroup,
        builder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SectionContentPage(
                    albumIndex: albumInfoList[index].index,
                  ),
                ),
              );
            },
            child: SizedBox(
              height: albumInfoList[index].frameHeight,
              width: albumInfoList[index].frameWidth,
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: albumInfoList[index].cardWidth,
                    height: albumInfoList[index].cardHeight,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: _generateImageContainer(index),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: titleHeight.toDouble(),
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                albumInfoList[index].title,
                                style: TextStyle(
                                  fontSize: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.fontSize,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        totalLength: albumInfoList.length,
      );
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
