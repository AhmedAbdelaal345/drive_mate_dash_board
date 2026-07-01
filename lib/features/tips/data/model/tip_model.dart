class TipModel {
  const TipModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.authorName,
    required this.isPublished,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String? category;
  final String authorName;
  final bool isPublished;
  final DateTime createdAt;

  factory TipModel.fromJson(Map<String, dynamic> json) {
    return TipModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String?,
      authorName: json['authorName'] as String? ?? '',
      isPublished: json['isPublished'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
