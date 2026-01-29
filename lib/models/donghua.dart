class Donghua {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final String videoUrl;
  final String status;
  final List<String> genres;
  final double rating;
  final int episodes;
  final String releaseTime; // e.g. "2 hours ago" or ISO date

  Donghua({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    this.videoUrl = '',
    required this.status,
    required this.genres,
    required this.rating,
    required this.episodes,
    required this.releaseTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverUrl': coverUrl,
      'videoUrl': videoUrl,
      'status': status,
      'genres': genres,
      'rating': rating,
      'episodes': episodes,
      'releaseTime': releaseTime,
    };
  }

  factory Donghua.fromJson(Map<String, dynamic> json) {
    return Donghua(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      coverUrl: json['coverUrl'],
      videoUrl: json['videoUrl'] ?? '',
      status: json['status'],
      genres: List<String>.from(json['genres'] ?? []),
      rating: (json['rating'] as num).toDouble(),
      episodes: json['episodes'],
      releaseTime: json['releaseTime'],
    );
  }

  Donghua copyWith({
    String? title,
    String? description,
    String? coverUrl,
    String? videoUrl,
    String? status,
    List<String>? genres,
    double? rating,
    int? episodes,
    String? releaseTime,
  }) {
    return Donghua(
      id: this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      status: status ?? this.status,
      genres: genres ?? this.genres,
      rating: rating ?? this.rating,
      episodes: episodes ?? this.episodes,
      releaseTime: releaseTime ?? this.releaseTime,
    );
  }
}
