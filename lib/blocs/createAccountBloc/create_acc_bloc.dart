import 'package:badikwa/blocs/createAccountBloc/create_acc_event.dart';
import 'package:badikwa/blocs/createAccountBloc/create_acc_state.dart';
import 'package:badikwa/data/auth_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccBloc extends Bloc<CreateAccEventInit, CreateAccState> {
  final AuthData authData = AuthData();

  CreateAccBloc() : super(CreateAccInitialState()) {
    on<SignupRequested>((event, emit) async {
      emit(CreateAccLoadingState());
      try {
        final result = await authData.registerAndLoginUser(event.user!);
        if (result.success) {
          emit(CreateAccSuccessState());
        } else {
          emit(CreateAccFailedState(msg: result.message));
        }
      } catch (e) {
        emit(CreateAccFailedState(msg: e.toString()));
      }
    });
  }
}
