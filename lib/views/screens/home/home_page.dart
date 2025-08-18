import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:prufcoach/blocs/homeBloc/home_bloc.dart';
import 'package:prufcoach/blocs/homeBloc/home_event.dart';
import 'package:prufcoach/blocs/homeBloc/home_state.dart';
import 'package:prufcoach/core/helpers/exam_prgress_helper.dart';
import 'package:prufcoach/core/routes.dart';
import 'package:prufcoach/core/utils/url_launcher_service.dart';
import 'package:prufcoach/data/hive/user_answer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomePageEvent());
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
                  const CupertinoActivityIndicator()
                else if (state.banners.isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.14,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.95,
                    ),
                    items:
                        state.banners.map((banner) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  openUrlInBrowser(banner.redirectUrl);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      banner.url,
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width,
                                    ),
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

                /// Displaying exams
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.exams?.length ?? 0,
                    itemBuilder: (context, index) {
                      final exam = state.exams![index];

                      final Box<UserAnswers> answersBox = Hive.box<UserAnswers>(
                        'userAnswers',
                      );

                      final percent = ExamProgressHelper.calculatePercentage(
                        answersBox,
                        exam,
                      );
                      final progress = ExamProgressHelper.calculateProgress(
                        answersBox,
                        exam,
                      );

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${index + 1}. ${exam.title}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "30 Minuten Hören | 45 Minuten Lesen | 30 Minuten Schreiben",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "$percent%",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            ExamProgressHelper.getProgressColor(
                                              progress,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: Colors.grey[300],
                                        color:
                                            ExamProgressHelper.getProgressColor(
                                              progress,
                                            ),
                                        minHeight: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.readyExam,
                                          arguments: exam.id,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              ExamProgressHelper.getProgressColor(
                                                progress,
                                              ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          "Weiter machen",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
