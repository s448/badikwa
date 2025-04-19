abstract class HomeEvent {}

class LoadUserLocationEvent extends HomeEvent {}

class UpdateUserLocationEvent extends HomeEvent {
  final double latitude;
  final double longitude;

  UpdateUserLocationEvent(this.latitude, this.longitude);
}
