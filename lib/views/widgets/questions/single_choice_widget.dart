import 'package:flutter/material.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';

class SingleChoiceWidget extends StatelessWidget {
  final Question question;
  final int selectedIndex;
  final void Function(int) onSelect;

  const SingleChoiceWidget({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          question.choices.asMap().entries.map((entry) {
            int index = entry.key;
            var choice = entry.value;

            return GestureDetector(
              onTap: () => onSelect(index),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color:
                      selectedIndex == index
                          ? AppColors.primaryGreen
                          : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              selectedIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                        child: VerticalDivider(
                          color:
                              selectedIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          choice.text,
                          style: TextStyle(
                            color:
                                selectedIndex == index
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
