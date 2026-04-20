enum SarkariType { job, result, admitCard, answerKey }
enum SarkariStatus { active, closed, upcoming }

class SarkariEntity {
  final String        id;
  final SarkariType   type;
  final String        examName;
  final String        organization;
  final String        title;
  final String?       description;
  final int?          totalPosts;
  final DateTime?     lastDate;
  final DateTime?     examDate;
  final String?       officialLink;
  final String?       applyLink;
  final SarkariStatus status;
  final DateTime      postedAt;

  const SarkariEntity({
    required this.id,
    required this.type,
    required this.examName,
    required this.organization,
    required this.title,
    this.description,
    this.totalPosts,
    this.lastDate,
    this.examDate,
    this.officialLink,
    this.applyLink,
    required this.status,
    required this.postedAt,
  });
}