import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    super.targetExam,
  });

  factory UserModel.fromSupabase(dynamic user) => UserModel(
    id:        user.id as String,
    email:     user.email as String? ?? '',
    name:      user.userMetadata?['name'] as String?,
    avatarUrl: user.userMetadata?['avatar_url'] as String?,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id:        json['id'] as String,
    email:     json['email'] as String? ?? '',
    name:      json['name'] as String?,
    avatarUrl: json['avatar_url'] as String?,
  );
}