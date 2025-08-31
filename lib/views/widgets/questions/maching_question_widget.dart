import 'package:flutter/material.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';

class MatchingChoicesPage extends StatefulWidget {
  final Question question;
  final List<int> selectedIndexes;
  final void Function(int qIndex, int selectedIndex) onSelected;

  const MatchingChoicesPage({
    super.key,
    required this.question,
    required this.selectedIndexes,
    required this.onSelected,
  });

  @override
  State<MatchingChoicesPage> createState() => _MatchingChoicesPageState();
}

class _MatchingChoicesPageState extends State<MatchingChoicesPage> {
  late List<String> allOptions;

  @override
  void initState() {
    super.initState();
    allOptions = widget.question.answers.map((c) => c.text).toList();

    // Ensure selectedIndexes has exactly 3 items
    while (widget.selectedIndexes.length < 3) {
      widget.selectedIndexes.add(-1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: List.generate(3, (qIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${qIndex + 1}:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: List.generate(allOptions.length, (optIndex) {
                      final option = allOptions[optIndex];
                      final isSelected =
                          widget.selectedIndexes[qIndex] == optIndex;

                      // Disable if used in another question
                      final isUsedInOther = widget.selectedIndexes
                          .asMap()
                          .entries
                          .any(
                            (entry) =>
                                entry.key != qIndex && entry.value == optIndex,
                          );

                      return ChoiceChip(
                        label: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: isSelected,
                        onSelected:
                            isUsedInOther
                                ? null
                                : (_) {
                                  setState(() {
                                    // If already selected, deselect it
                                    if (widget.selectedIndexes[qIndex] ==
                                        optIndex) {
                                      widget.selectedIndexes[qIndex] = -1;
                                      widget.onSelected(
                                        qIndex,
                                        -1,
                                      ); // pass -1 to indicate deselection
                                    } else {
                                      widget.selectedIndexes[qIndex] = optIndex;
                                      widget.onSelected(qIndex, optIndex);
                                    }
                                  });
                                },

                        selectedColor: AppColors.primaryGreen,
                        disabledColor: Colors.grey.shade300,
                        backgroundColor: Colors.grey.shade100,
                        showCheckmark: false,
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
