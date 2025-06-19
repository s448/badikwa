import 'package:prufcoach/models/banner_model.dart';
import 'package:prufcoach/models/exam_model.dart';

class HomeState {
  final List<BannerModel> banners;
  final List<Exam>? exams;
  final bool loading;
  final String? error;

  HomeState({
    this.banners = const [],
    this.exams = const [],
    this.loading = false,
    this.error,
  });

  HomeState copyWith({
    List<BannerModel>? banners,
    List<Exam>? exams,
    bool? loading,
    String? error,
  }) {
    return HomeState(
      banners: banners ?? this.banners,
      exams: exams ?? this.exams,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
