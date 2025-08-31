class Exam {
  final int id;
  final String title;
  final String level;
  final String? description;
  final DateTime createdAt;
  final List<Skill> skills;

  Exam({
    required this.id,
    required this.title,
    required this.level,
    this.description,
    required this.createdAt,
    required this.skills,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      title: json['title'],
      level: json['level'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      skills:
          (json['skills'] as List)
              .map((skill) => Skill.fromJson(skill))
              .toList(),
    );
  }
}

class Skill {
  final int id;
  final String name;
  final String? description;
  final String? audioUrl;
  final List<Story> stories;

  Skill({
    required this.id,
    required this.name,
    this.description,
    this.audioUrl,
    required this.stories,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      audioUrl: json['audioUrl'],
      stories:
          (json['stories'] as List)
              .map((story) => Story.fromJson(story))
              .toList(),
    );
  }

  get tales => null;
}

class Story {
  final int id;
  final String title;
  final String description;
  final String? audioUrl;
  final List<Question> questions;

  Story({
    required this.id,
    required this.title,
    required this.description,
    this.audioUrl,
    required this.questions,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      audioUrl: json['audioUrl'],
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }
}

class Question {
  final int id;
  final String type;
  final String questionText;
  final String? explanation;
  final int score;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.type,
    required this.questionText,
    this.explanation,
    required this.score,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      type: json['type'],
      questionText: json['questionText'] ?? json['text'],
      explanation: json['explanation'],
      score: json['score'],
      answers:
          (json['answers'] as List)
              .map((answer) => Answer.fromJson(answer))
              .toList(),
    );
  }
}

class Answer {
  final int id;
  final String text;
  final bool isCorrect;

  Answer({required this.id, required this.text, required this.isCorrect});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      text: json['questionText'] ?? json['text'],
      isCorrect: json['isCorrect'],
    );
  }
}
