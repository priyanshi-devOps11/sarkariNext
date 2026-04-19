import '../../domain/entities/test_entity.dart';

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.text,
    required super.options,
    required super.correctOption,
    super.explanation,
    super.subject,
    super.difficulty,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> j) => QuestionModel(
    text:          j['text']          as String,
    options:       List<String>.from(j['options'] as List),
    correctOption: j['correctOption'] as int,
    explanation:   j['explanation']   as String?,
    subject:       j['subject']       as String?,
    difficulty: _parseDiff(j['difficulty'] as String? ?? 'medium'),
  );

  static Difficulty _parseDiff(String s) =>
      s == 'easy' ? Difficulty.easy : s == 'hard' ? Difficulty.hard : Difficulty.medium;
}

class TestModel extends TestEntity {
  const TestModel({
    required super.id,
    required super.title,
    super.examName,
    super.subject,
    super.description,
    required super.durationMins,
    required super.questions,
    super.correctMarks,
    super.negativeMarks,
    super.isPremium,
    super.totalAttempts,
  });

  factory TestModel.fromJson(Map<String, dynamic> j) => TestModel(
    id:            j['_id']           as String,
    title:         j['title']         as String,
    examName:      j['examName']      as String?,
    subject:       j['subject']       as String?,
    description:   j['description']   as String?,
    durationMins:  j['durationMins']  as int,
    correctMarks:  (j['correctMarks']  as num).toDouble(),
    negativeMarks: (j['negativeMarks'] as num).toDouble(),
    isPremium:     j['isPremium']     as bool? ?? false,
    totalAttempts: j['totalAttempts'] as int? ?? 0,
    questions: (j['questions'] as List? ?? [])
        .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
        .toList(),
  );
}