class CaffDto {
  final int id;
  final String title;
  String imgURL;

  CaffDto({required this.id, required this.title, required this.imgURL});

  factory CaffDto.fromJson(Map<String, dynamic> json) => CaffDto(
        id: json['id'],
        title: json['title'],
        imgURL: json['imgURL'],
      );
}
