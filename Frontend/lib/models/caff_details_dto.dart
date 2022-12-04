class CaffDetailsDto {
  final int id;
  String? title;
  String? createdDate;
  String? ownerName;
  String? imgURL;
  List comments;
  int? numberOfPurchases;
  bool isPurchased;
  bool isOwner;

  CaffDetailsDto(
      {required this.id,
      this.title,
      this.createdDate,
      this.ownerName,
      this.imgURL,
      required this.comments,
      this.numberOfPurchases,
      required this.isPurchased,
      required this.isOwner});

  factory CaffDetailsDto.fromJson(Map<String, dynamic> json) => CaffDetailsDto(
      id: json['id'],
      title: json['title'],
      createdDate: json['createdDate'].toString(),
      ownerName: json['ownerName'],
      imgURL: json['imgURL'],
      comments: json['comments'],
      numberOfPurchases: json['numberOfPurchases'],
      isPurchased: json['isPurchased'],
      isOwner: json['isOwner']);
}
