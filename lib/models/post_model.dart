class Post {
  final int? id;
  final int userId; // Add userId
  final String user;
  final String content;
  final List<String> likedBy;
  int shares;

  Post({
    this.id,
    required this.userId, // Initialize userId
    required this.user,
    required this.content,
    this.likedBy = const [],
    this.shares = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId, // Convert userId to JSON
      'user': user,
      'content': content,
      'likedBy': likedBy.join(','),
      'shares': shares,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'], // Parse userId from JSON
      user: json['user'],
      content: json['content'],
      likedBy: json['likedBy'].toString().split(','),
      shares: json['shares'],
    );
  }
}
