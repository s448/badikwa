import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/homeBloc/home_event.dart';
import 'package:prufcoach/blocs/homeBloc/home_state.dart';
import 'package:prufcoach/data/home_page_data.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomePageData homePageData = HomePageData();

  HomeBloc() : super(HomeState()) {
    on<LoadBannersEvent>((event, emit) async {
      emit(state.copyWith(loading: true, error: null));
      final response = await homePageData.getAllBanners();

      if (response.success) {
        emit(state.copyWith(banners: response.response!, loading: false));
      } else {
        emit(
          state.copyWith(
            error: response.message ?? 'Failed to load banners',
            loading: false,
          ),
        );
      }
    });
  }
}
