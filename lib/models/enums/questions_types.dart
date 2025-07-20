enum QuestionType {
  singleChoice,
  multiChoice,
  trueFalse,
  matching,
  nonDescriptiveSingleChoice,
}

QuestionType getQuestionType(String type) {
  switch (type) {
    case 'multi_choice':
      return QuestionType.multiChoice;
    case 'true_false':
      return QuestionType.trueFalse;
    case 'matching':
      return QuestionType.matching;
    case 'non_descriptive_single_choice':
      return QuestionType.nonDescriptiveSingleChoice;
    default:
      return QuestionType.singleChoice;
  }
}
