import 'package:flutter/material.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';

class TrueFalseWidget extends StatelessWidget {
  final Question question;
  final int selectedIndex; // 0 for True, 1 for False, -1 if nothing selected
  final void Function(int) onSelect;

  const TrueFalseWidget({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final options = ['richtig', 'falsch'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(options.length, (index) {
        final isSelected = selectedIndex == index;
        final isTrue = index == 0;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () => onSelect(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? (isTrue ? AppColors.primaryGreen : Colors.red)
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        isSelected
                            ? (isTrue
                                ? AppColors.primaryGreen
                                : Colors.red.shade700)
                            : Colors.grey.shade400,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  options[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
