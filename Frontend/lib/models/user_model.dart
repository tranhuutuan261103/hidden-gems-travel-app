class User {
  final String email;
  final String token;
  final String role;
  final String id;
  final String name;
  final List<String> postsFound;
  final List<String> postsUnlocked;
  final double point;

  User({
    required this.email,
    required this.token,
    required this.role,
    required this.id,
    required this.name,
    required this.postsFound,
    required this.postsUnlocked,
    required this.point,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      token: json['token'],
      role: json['role'],
      id: json['_id'],
      name: json['name'],
      postsFound: List<String>.from(json['postsFound']),
      postsUnlocked: List<String>.from(json['postsUnlocked']),
      point: json['points'].toDouble(),
    );
  }
}
