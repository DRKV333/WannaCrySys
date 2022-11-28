class UserForRegistrationDto {
  final String name;
  final String username;
  final String password;
  final String confirmPassword;

  UserForRegistrationDto(
      {required this.name,
      required this.username,
      required this.password,
      required this.confirmPassword});

  Map<String, String> toJson() => {
        'name': name,
        'username': username,
        'password': password,
        'confirmPassword': confirmPassword
      };
}
