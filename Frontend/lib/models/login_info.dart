class LoginInfo {
  final String username;
  final String password;

  LoginInfo({
    required this.username,
    required this.password,
  });

  Map<String, String> toJson() => {'username': username, 'password': password};
}
