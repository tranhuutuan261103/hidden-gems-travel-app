class Comment {
  final String avatarUrl;
  final String userName;
  final String date;
  final int stars;
  final String comment;

  Comment({
    required this.avatarUrl,
    required this.userName,
    required this.date,
    required this.stars,
    required this.comment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      avatarUrl: "https://i.pravatar.cc/150?img=2",
      userName: json['createdBy'],
      date: json['createdAt'],
      stars: json['star'],
      comment: json['content'],
    );
  }
}
