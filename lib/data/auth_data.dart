import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:prufcoach/core/localStorage/auth_storage.dart';
import 'package:prufcoach/core/localStorage/user_storage.dart';
import 'package:prufcoach/core/utils/api_endpoint.dart' show endpoint;
import 'package:prufcoach/models/Dto/api_response.dart';
import 'package:prufcoach/models/user_model.dart';

class AuthData {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '$endpoint/api/',
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<ApiResponse<LoginResponse>> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data;

      if (response.statusCode == 200) {
        await AuthStorage.saveTokens(data['accessToken'], data['refreshToken']);
        final loginResponse = LoginResponse.fromJson(data);
        return ApiResponse(
          success: true,
          response: loginResponse,
          message: 'User logged in successfully',
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'Login failed',
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'Unknown error';
      log('Login failed: $errorMessage');
      return ApiResponse(success: false, message: errorMessage);
    }
  }

  Future<ApiResponse<LoginResponse>> registerAndLoginUser(User user) async {
    try {
      final response = await _dio.post(
        'auth/register',
        data: {
          'fullName': user.name,
          'email': user.email,
          'password': user.password,
        },
      );

      var loginResponse = await loginWithEmailAndPassword(
        user.email,
        user.password,
      );

      final data = response.data;

      await UserStorage.saveUserData(data['id'], data['fullName'] ?? user.name);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          loginResponse.success) {
        return ApiResponse(
          success: true,
          response: loginResponse.response,
          message: 'User registered successfully',
        );
      } else if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          !loginResponse.success) {
        return ApiResponse(
          success: false,
          message:
              data['message'] ??
              'User Registered successfully , but login failed',
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'Registration failed',
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'Unknown error';
      log('Registration failed: $errorMessage');
      return ApiResponse(success: false, message: errorMessage);
    }
  }

  Future<ApiResponse<dynamic>> sendOTPViaEmail(String email) async {
    try {
      var userExists = await checkUserExists(email);
      if (!userExists) {
        return ApiResponse(
          success: false,
          message: 'User with this email does not exist',
        );
      }
      final response = await _dio.post('otp/send-otp', data: {'email': email});

      final data = response.data;
      log(response.statusCode.toString());
      log(data.toString());
      if (response.statusCode == 200) {
        return ApiResponse(success: true, message: data['message']);
      } else {
        return ApiResponse(success: false, message: data['message']);
      }
    } on DioException catch (e) {
      log('Send OTP failed: ${e.response?.data ?? e.message}');
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to send OTP',
      );
    }
  }

  Future<bool> validateToken() async {
    final accessToken = await AuthStorage.getAccessToken();
    if (accessToken == null) return false;

    try {
      final response = await _dio.get(
        'auth/validate-token',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        log("authenticated");
        return true; // token is valid
      }
      return false;
    } on DioException catch (e) {
      log(e.toString());
      // You can check if status code is 401 for expired token
      if (e.response?.statusCode == 401) {
        log("Token expired.");
      }
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final response = await _dio.post(
        'otp/verify-otp',
        data: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      log('Verify OTP failed: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await AuthStorage.clearTokens();
      await UserStorage.clearUserData();
      return true;
    } catch (e) {
      log('Sign out failed: $e');
      return false;
    }
  }

  Future<bool> checkUserExists(String email) async {
    try {
      final response = await _dio.get(
        'auth/check-exist',
        queryParameters: {'email': email},
      );

      if (response.statusCode == 200) {
        return response.data as bool;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log('Check user exists failed: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  // Method to reset password
  Future<ApiResponse<dynamic>> resetPassword(
    String email,
    String newPassword,
  ) async {
    try {
      final response = await _dio.post(
        'auth/user-reset-password',
        data: {'email': email, 'newPassword': newPassword},
      );

      final data = response.data;

      if (response.statusCode == 200) {
        return ApiResponse(success: true, message: data['message']);
      } else {
        return ApiResponse(success: false, message: data);
      }
    } on DioException catch (e) {
      log('Reset password failed: ${e.response?.data ?? e.message}');
      return ApiResponse(
        success: false,
        message: e.response?.data ?? 'Failed to reset password',
      );
    }
  }
}
