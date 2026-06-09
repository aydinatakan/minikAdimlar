class Question {
  final String id;
  final String sentence;
  final List<String> options;
  final String correctAnswer;
  final int correctIndex;
  final bool isActive;

  const Question({
    required this.id,
    required this.sentence,
    required this.options,
    required this.correctAnswer,
    required this.correctIndex,
    required this.isActive,
  });

  factory Question.fromFirestore(Map<String, dynamic> data, String id) {
    return Question(
      id: id,
      sentence: data['sentence'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
      correctIndex: data['correctIndex'] ?? 0,
      isActive: data['isActive'] ?? false,
    );
  }
}

class VisualMatch {
  final String id;
  final String imagePath;
  final String audioPath;
  final List<String> options;
  final String correctAnswer;
  final int correctIndex;

  const VisualMatch({
    required this.id,
    required this.imagePath,
    required this.audioPath,
    required this.options,
    required this.correctAnswer,
    required this.correctIndex,
  });

  factory VisualMatch.fromJson(Map<String, dynamic> json) {
    return VisualMatch(
      id: json['id'],
      imagePath: json['imagePath'],
      audioPath: json['audioPath'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      correctIndex: json['correctIndex'],
    );
  }
}

class Story {
  final String id;
  final String title;
  final String imagePath;
  final String audioPath;
  final String text;

  const Story({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.audioPath,
    required this.text,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      imagePath: json['imagePath'],
      audioPath: json['audioPath'],
      text: json['text'],
    );
  }
}

class RoutineTask {
  final String id;
  final String title;
  final String icon;
  final String category;
  final int order;

  const RoutineTask({
    required this.id,
    required this.title,
    required this.icon,
    required this.category,
    required this.order,
  });

  factory RoutineTask.fromFirestore(Map<String, dynamic> data, String id) {
    return RoutineTask(
      id: id,
      title: data['title'] ?? '',
      icon: data['icon'] ?? '',
      category: data['category'] ?? '',
      order: data['order'] ?? 0,
    );
  }
}

class PecsCard {
  final String id;
  final String title;
  final String icon;
  final String category;

  const PecsCard({
    required this.id,
    required this.title,
    required this.icon,
    required this.category,
  });

  factory PecsCard.fromFirestore(Map<String, dynamic> data, String id) {
    return PecsCard(
      id: id,
      title: data['title'] ?? '',
      icon: data['icon'] ?? '',
      category: data['category'] ?? '',
    );
  }
}

class ColorShapeQuestion {
  final String id;
  final String question;
  final String type; // 'color' or 'shape'
  final List<String> options;
  final String correctAnswer;

  const ColorShapeQuestion({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswer,
  });

  factory ColorShapeQuestion.fromFirestore(Map<String, dynamic> data, String id) {
    return ColorShapeQuestion(
      id: id,
      question: data['question'] ?? '',
      type: data['type'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
    );
  }
}

class SequenceScenario {
  final String id;
  final String title;
  final List<String> steps;
  final List<String> icons;

  const SequenceScenario({
    required this.id,
    required this.title,
    required this.steps,
    required this.icons,
  });

  factory SequenceScenario.fromFirestore(Map<String, dynamic> data, String id) {
    return SequenceScenario(
      id: id,
      title: data['title'] ?? '',
      steps: List<String>.from(data['steps'] ?? []),
      icons: List<String>.from(data['icons'] ?? []),
    );
  }
}

class Reminder {
  final String id;
  final String title;
  final String content;
  final DateTime dateTime;
  final bool isActive;

  Reminder({
    required this.id,
    required this.title,
    required this.content,
    required this.dateTime,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateTime': dateTime.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      dateTime: DateTime.parse(map['dateTime']),
      isActive: map['isActive'] ?? true,
    );
  }
}

class CalmDownActivity {
  final String id;
  final String title;
  final String instruction;
  final String lottiePath; // Path for lottie animation
  final String? audioPath;

  const CalmDownActivity({
    required this.id,
    required this.title,
    required this.instruction,
    required this.lottiePath,
    this.audioPath,
  });
}

class EmotionQuestion {
  final String id;
  final String question;
  final String emoji;
  final List<String> options;
  final String correctAnswer;
  final int correctIndex;
  final String? imagePath;

  EmotionQuestion({
    required this.id,
    required this.question,
    required this.emoji,
    required this.options,
    required this.correctAnswer,
    required this.correctIndex,
    this.imagePath,
  });
}

class Animal {
  final String id;
  final String name;
  final String emoji;
  final String soundText;
  final String? audioPath;

  Animal({
    required this.id,
    required this.name,
    required this.emoji,
    required this.soundText,
    this.audioPath,
  });
}
