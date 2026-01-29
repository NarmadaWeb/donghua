class Comment {
  final String id;
  final String userId;
  final String username;
  final String donghuaId;
  final String content;
  final String timestamp;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.donghuaId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'donghuaId': donghuaId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      donghuaId: json['donghuaId'],
      content: json['content'],
      timestamp: json['timestamp'],
    );
  }
}
