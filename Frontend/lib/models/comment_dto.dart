class CommentDto {
  final int id;
  final String createdDate;
  final String content;
  final String userName;
  final bool isOwner;

  CommentDto(
      {required this.id,
      required this.createdDate,
      required this.content,
      required this.userName,
      required this.isOwner});

  factory CommentDto.fromJson(Map<String, dynamic> json) => CommentDto(
      id: json['id'],
      createdDate: json['createdDate'],
      content: json['content'],
      userName: json['userName'],
      isOwner: json['isOwner']);
}
