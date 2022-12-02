class CaffDetailsDto {
  final int id;
  String? title;
  String? createdDate;
  String? ownerName;
  String? imgURL;
  List? comments;
  int? numberOfPurchases;

  CaffDetailsDto({required this.id, this.title, this.createdDate, this.ownerName, this.imgURL, this.comments, this.numberOfPurchases});

  factory CaffDetailsDto.fromJson(Map<String, dynamic> json) => CaffDetailsDto(
      id: json['id'],
      title: json['title'],
      createdDate: json['createdDate'].toString(),
      ownerName: json['ownerName'],
      imgURL: json['imgURL'],
      comments: json['comments'],
      numberOfPurchases: json['numberOfPurchases'],);
}
