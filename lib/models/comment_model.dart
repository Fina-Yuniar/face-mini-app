class Comment {
  final int? id;
  final int postId;
  final String user;
  final String content;

  Comment({
    this.id,
    required this.postId,
    required this.user,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'postId': postId,
      'user': user,
      'content': content,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      user: json['user'],
      content: json['content'],
    );
  }
}
