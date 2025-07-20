import 'package:flutter/material.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';

class MultiChoiceWidget extends StatelessWidget {
  final Question question;
  final List<int> selectedIndexes;
  final void Function(int) onToggle;

  const MultiChoiceWidget({
    super.key,
    required this.question,
    required this.selectedIndexes,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          question.choices.asMap().entries.map((entry) {
            int index = entry.key;
            var choice = entry.value;
            bool selected = selectedIndexes.contains(index);

            return GestureDetector(
              onTap: () => onToggle(index),
              child: IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              selectedIndexes.contains(index)
                                  ? Colors.white
                                  : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                        child: VerticalDivider(
                          color:
                              selectedIndexes.contains(index)
                                  ? Colors.white
                                  : Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          choice.text,
                          style: TextStyle(
                            color:
                                selectedIndexes.contains(index)
                                    ? Colors.white
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
