abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final double latitude;
  final double longitude;

  HomeLoaded({required this.latitude, required this.longitude});
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
