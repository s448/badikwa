class ApiResponse<T> {
  final bool success;
  final T? response;
  final String? message;

  ApiResponse({required this.success, this.response, this.message});
}

class LoginResponse {
  final String accessToken;
  final String refereshToken;

  LoginResponse({required this.accessToken, required this.refereshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refereshToken: json['refreshToken'],
    );
  }
}
