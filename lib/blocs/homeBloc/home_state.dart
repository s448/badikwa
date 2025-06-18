import 'package:prufcoach/models/banner_model.dart';

class HomeState {
  final List<BannerModel> banners;
  final bool loading;
  final String? error;

  HomeState({this.banners = const [], this.loading = false, this.error});

  HomeState copyWith({
    List<BannerModel>? banners,
    bool? loading,
    String? error,
  }) {
    return HomeState(
      banners: banners ?? this.banners,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
