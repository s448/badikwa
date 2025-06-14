import 'package:prufcoach/data/location_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocationService locationService;

  HomeBloc(this.locationService) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadUserLocationEvent) {
      yield HomeLoading();
      try {
        final location = await locationService.getCurrentLocation();
        yield HomeLoaded(
          latitude: location.latitude,
          longitude: location.longitude,
        );
      } catch (e) {
        yield HomeError("Failed to load location");
      }
    }

    if (event is UpdateUserLocationEvent) {
      yield HomeLoading();
      try {
        final updatedLocation = await locationService.updateLocation(
          event.latitude,
          event.longitude,
        );
        yield HomeLoaded(
          latitude: updatedLocation.latitude,
          longitude: updatedLocation.longitude,
        );
      } catch (e) {
        yield HomeError("Failed to update location");
      }
    }
  }
}
