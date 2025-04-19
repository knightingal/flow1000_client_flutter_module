Map<String, String> albumMap = {
  "1000": "source",
  "1803": "1803",
  "1804": "1804",
  "1805": "1805",
  "1806": "1806",
  "1807": "1807",
};

class SectionDetail {
  final String dirName;
  final int picPage;
  final List<ImgDetail> pics;
  final String album;

  SectionDetail({
    required this.dirName,
    required this.picPage,
    required this.pics,
    required this.album,
  });

  factory SectionDetail.fromJson(Map<String, dynamic> json) {
    return SectionDetail(
      dirName: json["dirName"],
      picPage: json["picPage"],
      pics:
          (json["pics"] as List<dynamic>)
              .map((e) => ImgDetail.fromJson(e))
              .toList(),
      album: json["album"],
    );
  }
}

class ImgDetail {
  final String name;
  final int width;
  final int height;
  double realHeight = 0;
  double realWidth = 0;

  String toUrl(SectionDetail sectionDetail) {
    return "http://192.168.2.12:3002/linux1000/${albumMap[sectionDetail.album]}/${sectionDetail.dirName}/${name.replaceAll(".bin", "")}";
  }

  ImgDetail({required this.name, required this.width, required this.height});

  factory ImgDetail.fromJson(Map<String, dynamic> json) {
    return ImgDetail(
      name: json["name"],
      width: json["width"],
      height: json["height"],
    );
  }
}

class AlbumInfo {
  final int index;
  final String name;
  final String cover;
  final int coverWidth;
  final int coverHeight;
  final String album;
  final String clientStatus;
  double realWidth = 0;
  double realHeight = 0;

  String toCoverUrl() {
    // return "http://192.168.2.12:3002/linux1000/encrypted/$name/$cover";
    return "http://192.168.2.12:3002/linux1000/${albumMap[album]}/$name/${cover.replaceAll(".bin", "")}";
  }

  AlbumInfo({
    required this.index,
    required this.name,
    required this.cover,
    required this.coverWidth,
    required this.coverHeight,
    required this.album,
    required this.clientStatus,
  });

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      index: json["index"],
      name: json["name"],
      cover: json["cover"],
      coverWidth: json["coverWidth"],
      coverHeight: json["coverHeight"],
      album: json["album"],
      clientStatus: json["clientStatus"],
    );
  }
}
