class AppUser {
  final String id;
  final String userId;
  final String name;
  final String role;
  final String email;

  const AppUser({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    this.email = '',
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}
