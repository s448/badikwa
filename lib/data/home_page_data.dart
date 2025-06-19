import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:prufcoach/core/utils/api_endpoint.dart';
import 'package:prufcoach/models/banner_model.dart';
import 'package:prufcoach/models/Dto/api_response.dart';
import 'package:prufcoach/models/exam_model.dart';

class HomePageData {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '$endpoint/api/',
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<ApiResponse<List<BannerModel>>> getAllBanners() async {
    try {
      final response = await _dio.get('banner/get-all');
      if (response.statusCode == 200) {
        final data =
            response.data is String ? jsonDecode(response.data) : response.data;

        List bannersList = data;
        final banners =
            bannersList.map((e) => BannerModel.fromJson(e)).toList();
        log('Banners fetched successfully: ${banners.length} items');
        return ApiResponse(
          success: true,
          response: banners,
          message: 'Banners fetched successfully',
        );
      } else {
        return ApiResponse(success: false, message: response.data.toString());
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message ?? 'Unknown error';
      log('Fetch banners failed: $errorMsg');
      return ApiResponse(success: false, message: errorMsg);
    }
  }

  Future<ApiResponse<List<Exam>>> getAllExams() async {
    try {
      final response = await _dio.get('Exam');

      if (response.statusCode == 200) {
        final List data = response.data;
        final exams = data.map((e) => Exam.fromJson(e)).toList();
        log("Exams fetched successfully: ${exams.length}");
        return ApiResponse(success: true, response: exams);
      } else {
        log("Error: ${response.statusCode} - ${response.data}");
        return ApiResponse(success: false, message: "Failed to load exams");
      }
    } on DioException catch (e) {
      log("DioException: ${e.response?.data ?? e.message}");
      return ApiResponse(success: false, message: "Failed to load exams");
    }
  }
}
