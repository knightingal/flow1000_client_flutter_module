class AlbumInfo {
  final int index;
  final String name;
  final String cover;
  final int coverWidth;
  final int coverHeight;
  final String album;
  final String clientStatus;

  AlbumInfo({required this.index, required this.name, required this.cover, required this.coverWidth, required this.coverHeight, required this.album, required this.clientStatus});

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      index: json["index"], 
      name: json["name"], 
      cover: json["cover"], 
      coverWidth: json["coverWidth"], 
      coverHeight: json["coverHeight"], 
      album: json["album"], 
      clientStatus: json["clientStatus"]);
  }
}