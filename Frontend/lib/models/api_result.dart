class ApiResult {
  final dynamic data;
  final bool isSuccess;
  final String? errorMessage;

  ApiResult({this.data, this.isSuccess = true, this.errorMessage});
}
