class UserForUpdateDto {
  String name;
  String? password;
  String? confirmPassword;

  UserForUpdateDto({
    required this.name,
    this.password,
    this.confirmPassword,
  });

  Map<String, String> toJson() {
    Map<String, String> json = {'name': name};

    if (password != null && confirmPassword != null) {
      json['password'] = password!;
      json['confirmPassword'] = confirmPassword!;
    }

    return json;
  }
}
