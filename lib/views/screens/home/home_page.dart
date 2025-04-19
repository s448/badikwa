import 'package:badikwa/blocs/homeBloc/home_bloc.dart';
import 'package:badikwa/blocs/homeBloc/home_event.dart';
import 'package:badikwa/blocs/homeBloc/home_state.dart';
import 'package:badikwa/data/location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(LocationService())..add(LoadUserLocationEvent()),
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return Column(
                children: [
                  Text(
                    "Latitude: ${state.latitude}, Longitude: ${state.longitude}",
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // قم بإضافة الحدث لتحديث الموقع عند الضغط على الزر
                      BlocProvider.of<HomeBloc>(context).add(
                        UpdateUserLocationEvent(
                          30.0,
                          31.5,
                        ), // اذهب للموقع الجديد هنا
                      );
                    },
                    child: const Text('Update Location'),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey[200], // مساحة الخريطة
                      child: const Center(child: Text('Google Maps Here')),
                    ),
                  ),
                ],
              );
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
