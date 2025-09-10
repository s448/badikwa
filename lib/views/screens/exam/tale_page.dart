import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prufcoach/data/hive/controller.dart';
import 'package:prufcoach/models/enums/questions_types.dart';
import 'package:prufcoach/models/exam_model.dart';
import 'package:prufcoach/views/widgets/questions/maching_question_widget.dart';
import 'package:prufcoach/views/widgets/questions/mutli_choice_widget.dart';
import 'package:prufcoach/views/widgets/questions/single_choice_widget.dart';
import 'package:prufcoach/views/widgets/questions/true_false_question_widget.dart';
import 'package:prufcoach/views/widgets/questions/undescriptive_single_choice_question_widget.dart';

class TaleWidget extends StatefulWidget {
  final Story tale;
  const TaleWidget({super.key, required this.tale});

  @override
  State<TaleWidget> createState() => _TaleWidgetState();
}

class _TaleWidgetState extends State<TaleWidget> {
  late List<List<int>> selectedIndexes;

  List<List<int>> get getSelectedAnswers => selectedIndexes;

  @override
  void initState() {
    super.initState();
    selectedIndexes = List.generate(widget.tale.questions.length, (_) => []);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.tale.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        buildDescriptionAsHTML(context, widget.tale.description),
        const SizedBox(height: 12),
        for (int i = 0; i < widget.tale.questions.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${i + 1}. ${widget.tale.questions[i].questionText}'),
              const SizedBox(height: 4),
              _buildQuestionWidget(widget.tale.questions[i], i),
              const SizedBox(height: 12),
            ],
          ),
      ],
    );
  }

  Widget _buildQuestionWidget(Question question, int questionIndex) {
    final type = getQuestionType(question.type);

    switch (type) {
      case QuestionType.singleChoice:
        return SingleChoiceWidget(
          question: question,

          selectedIndex:
              selectedIndexes[questionIndex].isEmpty
                  ? -1
                  : selectedIndexes[questionIndex].first,
          onSelect: (index) {
            setState(() {
              selectedIndexes[questionIndex] = [index];
            });
          },
        );
      case QuestionType.multiChoice:
        return MultiChoiceWidget(
          question: question,
          selectedIndexes: selectedIndexes[questionIndex],
          onToggle: (index) {
            setState(() {
              if (selectedIndexes[questionIndex].contains(index)) {
                selectedIndexes[questionIndex].remove(index);
              } else {
                selectedIndexes[questionIndex].add(index);
              }
            });
          },
        );
      case QuestionType.trueFalse:
        return TrueFalseWidget(
          question: question,
          selectedIndex:
              selectedIndexes[questionIndex].isEmpty
                  ? -1
                  : selectedIndexes[questionIndex].first,
          onSelect: (index) {
            setState(() {
              selectedIndexes[questionIndex] = [index];
            });
          },
        );
      case QuestionType.matching:
        return MatchingChoicesPage(
          onSelected:
              (qIndex, selectedIndex) => setState(() {
                selectedIndexes[questionIndex][qIndex] = selectedIndex;
              }),
          question: question,
          selectedIndexes: selectedIndexes[questionIndex],
        );
      case QuestionType.nonDescriptiveSingleChoice:
        return SelectableChipsQuestion(
          question: question,
          selectedIndex:
              selectedIndexes[questionIndex].isEmpty
                  ? -1
                  : selectedIndexes[questionIndex].first,
          onSelect: (index) {
            setState(() {
              selectedIndexes[questionIndex] = [index];
              log(selectedIndexes[questionIndex].toString());
            });
          },
        );
    }
  }
}

class SkillTalesPage extends StatefulWidget {
  final Exam exam;
  final int skillIndex;
  final VoidCallback? onFinished;

  const SkillTalesPage({
    Key? key,
    required this.exam,
    required this.skillIndex,
    this.onFinished,
  }) : super(key: key);

  @override
  State<SkillTalesPage> createState() => _SkillTalesPageState();
}

class _SkillTalesPageState extends State<SkillTalesPage> {
  int currentIndex = 0;
  late GlobalKey<_TaleWidgetState> taleWidgetKey;
  final HiveAnswerController hiveAnswerController = HiveAnswerController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    taleWidgetKey = GlobalKey<_TaleWidgetState>();
  }

  Future<void> goToNextTale() async {
    final selected = taleWidgetKey.currentState?.getSelectedAnswers;

    if (selected != null) {
      await hiveAnswerController.saveAnswer(
        examId: widget.exam.id.toString(),
        skillId: widget.exam.skills[widget.skillIndex].id.toString(),
        taleId:
            widget.exam.skills[widget.skillIndex].stories[currentIndex].id
                .toString(),
        answers: selected,
      );

      await hiveAnswerController.printAnswers(widget.exam.id.toString());
    }

    if (currentIndex <
        widget.exam.skills[widget.skillIndex].stories.length - 1) {
      setState(() {
        currentIndex++;
        taleWidgetKey = GlobalKey<_TaleWidgetState>();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    } else {
      widget.onFinished?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tale = widget.exam.skills[widget.skillIndex].stories[currentIndex];

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,

        padding: const EdgeInsets.all(16),
        child: TaleWidget(key: taleWidgetKey, tale: tale),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(16),
          ),
          onPressed: goToNextTale,
          child: Text(
            currentIndex <
                    widget.exam.skills[widget.skillIndex].stories.length - 1
                ? 'Weiter zum Hörteil ${currentIndex + 2}'
                : 'Zur nächsten Lektion gehen',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildDescriptionAsHTML(BuildContext context, String description) {
  return SingleChildScrollView(
    child: Html(
      data: """
        $description
          """,
      extensions: [
        TagExtension(tagsToExtend: {"flutter"}, child: const FlutterLogo()),
      ],
      style: {
        "p.fancy": Style(
          textAlign: TextAlign.center,
          padding: HtmlPaddings.all(0),
          backgroundColor: Colors.grey,
          margin: Margins(left: Margin(10, Unit.px), right: Margin.auto()),

          fontWeight: FontWeight.bold,
        ),
      },
    ),
  );
}
