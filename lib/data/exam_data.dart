import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:prufcoach/core/utils/api_endpoint.dart';
import 'package:prufcoach/models/Dto/api_response.dart';
import 'package:prufcoach/models/exam_model.dart';

class ExamData {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '$endpoint/api/',
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<ApiResponse<Exam>> getExamById(int id) async {
    try {
      final response = await _dio.get('Exam/$id');

      if (response.statusCode == 200) {
        final exam = Exam.fromJson(response.data);
        log("Exam fetched successfully for ID $id: ${exam.title}");
        return ApiResponse(success: true, response: exam);
      } else {
        log("Error: ${response.statusCode} - ${response.data}");
        return ApiResponse(
          success: false,
          message: "Failed to load exam for ID $id",
        );
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return ApiResponse(
        success: false,
        message: "Failed to load exam for ID $id",
      );
    }
  }
}
