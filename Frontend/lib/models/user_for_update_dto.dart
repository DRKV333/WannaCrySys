class UserForUpdateDto {
  String name;
  String password;
  String confirmPassword;

  UserForUpdateDto(
      {required this.name,
      required this.password,
      required this.confirmPassword});

  Map<String, String> toJson() => {
        'name': name,
        'password': password,
        'confirmPassword': confirmPassword,
      };
}
