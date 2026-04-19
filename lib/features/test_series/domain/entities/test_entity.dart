enum AnswerStatus { correct, wrong, skipped }
enum Difficulty   { easy, medium, hard }

class QuestionEntity {
  final String  text;
  final List<String> options;
  final int     correctOption;
  final String? explanation;
  final String? subject;
  final Difficulty difficulty;

  const QuestionEntity({
    required this.text,
    required this.options,
    required this.correctOption,
    this.explanation,
    this.subject,
    this.difficulty = Difficulty.medium,
  });
}

class TestEntity {
  final String  id;
  final String  title;
  final String? examName;
  final String? subject;
  final String? description;
  final int     durationMins;
  final List<QuestionEntity> questions;
  final double  correctMarks;
  final double  negativeMarks;
  final bool    isPremium;
  final int     totalAttempts;

  const TestEntity({
    required this.id,
    required this.title,
    this.examName,
    this.subject,
    this.description,
    required this.durationMins,
    required this.questions,
    this.correctMarks  = 1.0,
    this.negativeMarks = -0.25,
    this.isPremium     = false,
    this.totalAttempts = 0,
  });
}

class TestResultEntity {
  final String testId;
  final double score;
  final double totalMarks;
  final int    correct;
  final int    wrong;
  final int    skipped;
  final int    timeTaken;
  final double accuracy;
  final List<QuestionResultEntity> details;

  const TestResultEntity({
    required this.testId,
    required this.score,
    required this.totalMarks,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.timeTaken,
    required this.accuracy,
    required this.details,
  });
}

class QuestionResultEntity {
  final int    questionIndex;
  final AnswerStatus status;
  final int?   selectedOption;

  const QuestionResultEntity({
    required this.questionIndex,
    required this.status,
    this.selectedOption,
  });
}