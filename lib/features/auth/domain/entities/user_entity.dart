class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final String? targetExam;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.targetExam,
  });
}