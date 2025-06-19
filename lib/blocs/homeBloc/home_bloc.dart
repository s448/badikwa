import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/homeBloc/home_event.dart';
import 'package:prufcoach/blocs/homeBloc/home_state.dart';
import 'package:prufcoach/data/home_page_data.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomePageData homePageData = HomePageData();

  HomeBloc() : super(HomeState()) {
    on<LoadHomePageEvent>((event, emit) async {
      emit(state.copyWith(loading: true, error: null));
      final banners = await homePageData.getAllBanners();
      final examsRes = await homePageData.getAllExams();
      if (examsRes.success) {
        emit(
          state.copyWith(
            banners: banners.response!,
            exams: examsRes.response,
            loading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            error: examsRes.message ?? 'Failed to load exams',
            loading: false,
          ),
        );
      }
    });
  }
}
