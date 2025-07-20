import 'package:flutter/material.dart';
import 'package:prufcoach/core/utils/colors.dart';
import 'package:prufcoach/models/exam_model.dart';

class SelectableChipsQuestion extends StatefulWidget {
  final Question question;
  final int selectedIndex;
  final void Function(int) onSelect;

  const SelectableChipsQuestion({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<SelectableChipsQuestion> createState() =>
      _SelectableChipsQuestionState();
}

class _SelectableChipsQuestionState extends State<SelectableChipsQuestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.question.choices.length, (qIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${qIndex + 1}. ", style: const TextStyle(fontSize: 16)),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: List.generate(widget.question.choices.length, (
                    optIndex,
                  ) {
                    bool isSelected = widget.selectedIndex == optIndex;

                    return ChoiceChip(
                      label: Text(
                        widget.question.choices[optIndex].text,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) => widget.onSelect(optIndex),

                      selectedColor: AppColors.primaryGreen,
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
    );
  }
}
