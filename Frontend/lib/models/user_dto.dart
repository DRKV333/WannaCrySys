class UserDto {
  final int id;
  String? name;
  String? username;
  List? caffs;

  UserDto({required this.id, this.name, this.username, this.caffs});

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
      id: json['id'],
      name: json['name'],
      username: json['userName'],
      caffs: json['caffs']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'username': username, 'caffs': caffs};
}
