class AppUser {
  final String? id;
  final String username;
  final String? email;
  final String? bio;
  final String? avatarUrl;
  final DateTime? createdAt;

  AppUser({
    this.id,
    required this.username,
    this.email,
    this.bio,
    this.avatarUrl,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? json['userId']?.toString(),
      username: json['username'] ?? '',
      email: json['email'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'] ?? json['profilePicture'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'bio': bio,
    'avatarUrl': avatarUrl,
  };
}
