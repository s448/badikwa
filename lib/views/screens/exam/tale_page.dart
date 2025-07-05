import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';

class TaleWidget extends StatefulWidget {
  final Story tale;

  const TaleWidget({super.key, required this.tale});

  @override
  State<TaleWidget> createState() => _TaleWidgetState();
}

class _TaleWidgetState extends State<TaleWidget> {
  late List<int> _selectedIndexes;

  List<int> get selectedIndexes => _selectedIndexes;

  @override
  void initState() {
    super.initState();
    _selectedIndexes = List.filled(widget.tale.questions.length, -1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.tale.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(widget.tale.description, style: const TextStyle(fontSize: 17)),
          const SizedBox(height: 12),
          for (int i = 0; i < widget.tale.questions.length; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${i + 1}: ${widget.tale.questions[i].text}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                ...widget.tale.questions[i].choices.asMap().entries.map((
                  entry,
                ) {
                  int optionIndex = entry.key;
                  final option = entry.value;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndexes[i] = optionIndex;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndexes[i] == optionIndex
                                ? AppColors.primaryGreen
                                : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Text(
                            String.fromCharCode(65 + optionIndex),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  _selectedIndexes[i] == optionIndex
                                      ? Colors.white
                                      : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              option.text,
                              style: TextStyle(
                                color:
                                    _selectedIndexes[i] == optionIndex
                                        ? Colors.white
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }
}

class SkillTalesPage extends StatefulWidget {
  final List<Story> tales;

  const SkillTalesPage({super.key, required this.tales});

  @override
  State<SkillTalesPage> createState() => _SkillTalesPageState();
}

class _SkillTalesPageState extends State<SkillTalesPage> {
  int currentIndex = 0;
  final Map<int, List<int>> allAnswers = {};

  late GlobalKey<_TaleWidgetState> taleWidgetKey;

  @override
  void initState() {
    super.initState();
    taleWidgetKey = GlobalKey<_TaleWidgetState>();
  }

  void goToNextTale() {
    final selected = taleWidgetKey.currentState?.selectedIndexes;
    if (selected != null) {
      allAnswers[currentIndex] = List.from(selected);
    }

    if (currentIndex < widget.tales.length - 1) {
      setState(() {
        currentIndex++;
        taleWidgetKey =
            GlobalKey<
              _TaleWidgetState
            >(); // 👈 Force new state for the next tale
      });
    } else {
      debugPrint("All answers: $allAnswers");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You’ve completed all tales!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tale = widget.tales[currentIndex];

    return Scaffold(
      body: SingleChildScrollView(
        child: TaleWidget(
          key: taleWidgetKey, // 👈 Give each tale its own widget state
          tale: tale,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          onPressed: goToNextTale,
          child: Text(
            currentIndex < widget.tales.length - 1
                ? "Weiter zum Hörteil ${currentIndex + 2}"
                : "Zur nächsten Lektion gehen",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
