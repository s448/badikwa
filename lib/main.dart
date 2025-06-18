import 'package:prufcoach/blocs/authBloc/auth_bloc.dart';
import 'package:prufcoach/blocs/authBloc/auth_event.dart';
import 'package:prufcoach/blocs/homeBloc/home_bloc.dart';
import 'package:prufcoach/blocs/resetPasswordBloc/reset_password_bloc.dart';
import 'package:prufcoach/core/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/createAccountBloc/create_acc_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  AuthBloc().add(AppStarted());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AppStarted()),
        ),
        BlocProvider<CreateAccBloc>(create: (context) => CreateAccBloc()),
        BlocProvider<ResetPasswordBloc>(
          create: (context) => ResetPasswordBloc(),
        ),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pruf Coach',
      // initialRoute: AppRoutes.land,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
