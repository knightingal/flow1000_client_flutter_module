class AlbumInfo {
  final int index;
  final String name;
  final String cover;
  final int coverWidth;
  final int coverHeight;
  final String ablum;
  final String clientStatus;

  AlbumInfo({required this.index, required this.name, required this.cover, required this.coverWidth, required this.coverHeight, required this.ablum, required this.clientStatus});

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      index: json["id"], 
      name: json["name"], 
      cover: json["cover"], 
      coverWidth: json["coverWidth"], 
      coverHeight: json["coverHeight"], 
      ablum: json["ablum"], 
      clientStatus: json["clientStatus"]);
  }
}