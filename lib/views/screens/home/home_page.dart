import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prufcoach/blocs/homeBloc/home_bloc.dart';
import 'package:prufcoach/blocs/homeBloc/home_event.dart';
import 'package:prufcoach/blocs/homeBloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadBannersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              children: [
                if (state.loading)
                  const CircularProgressIndicator()
                else if (state.banners.isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 180.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items:
                        state.banners.map((banner) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  // optionally open RedirectUrl
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    banner.url,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                  )
                else if (state.error != null)
                  Text(state.error!)
                else
                  const Text("No banners found."),
                const Expanded(child: Center(child: Text("Main Content Here"))),
              ],
            );
          },
        ),
      ),
    );
  }
}
