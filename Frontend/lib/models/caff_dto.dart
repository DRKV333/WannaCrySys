class CaffDto {
  final int id;
  String? title;
  String? imgURL;

  CaffDto({required this.id, this.title, this.imgURL});

  factory CaffDto.fromJson(Map<String, dynamic> json) => CaffDto(
    id: json['id'],
    title: json['title'],
    imgURL: json['imgURL'],);
}
