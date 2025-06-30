import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';

// The widget that displays each tale
class TaleWidget extends StatefulWidget {
  final Story tale;

  const TaleWidget({super.key, required this.tale});

  @override
  State<TaleWidget> createState() => _TaleWidgetState();
}

class _TaleWidgetState extends State<TaleWidget> {
  // Store selected index for each question
  late List<int> selectedIndexes = [-1];

  @override
  void initState() {
    super.initState();
    // Initialize all selections to -1 (none selected)
    selectedIndexes = List.filled(widget.tale.questions.length, -1);
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
          Text(
            widget.tale.description,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < widget.tale.questions.length; i++)
            ListTile(
              title: Text(
                "${i + 1}: ${widget.tale.questions[i].text}",
                style: const TextStyle(fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    widget.tale.questions[i].choices.map((option) {
                      int optionIndex = widget.tale.questions[i].choices
                          .indexOf(option);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndexes[i] = optionIndex;
                              log(selectedIndexes[i].toString());
                            });
                          },

                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  selectedIndexes[i] == optionIndex
                                      ? AppColors.primaryGreen
                                      : Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Text(
                                    String.fromCharCode(65 + optionIndex),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color:
                                          selectedIndexes[i] == optionIndex
                                              ? Colors.white
                                              : Colors.grey,
                                    ),
                                  ),
                                  VerticalDivider(
                                    width: 16,
                                    thickness: 1,
                                    color:
                                        selectedIndexes[i] == optionIndex
                                            ? Colors.white
                                            : Colors.grey,
                                  ),
                                  Expanded(
                                    child: Text(
                                      option.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            selectedIndexes[i] == optionIndex
                                                ? Colors.white
                                                : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// Skill page with tale navigation
class SkillTalesPage extends StatefulWidget {
  final List<Story> tales;

  const SkillTalesPage({super.key, required this.tales});

  @override
  State<SkillTalesPage> createState() => _SkillTalesPageState();
}

class _SkillTalesPageState extends State<SkillTalesPage> {
  int currentIndex = 0;

  void goToNextTale() {
    if (currentIndex < widget.tales.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Reached last tale — show message or finish
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have completed all tales in this skill!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tale = widget.tales[currentIndex];

    return Scaffold(
      // width: MediaQuery.of(context).size.width,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Show current tale
            TaleWidget(tale: tale),

            // Navigation
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: goToNextTale,
        child: const Text("Next Tale"),
      ),
    );
  }
}
