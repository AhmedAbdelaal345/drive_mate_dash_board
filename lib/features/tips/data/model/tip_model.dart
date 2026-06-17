class TipModel {
  const TipModel({
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    required this.views,
    required this.likes,
    required this.difficulty,
    required this.duration,
  });

  final String title;
  final String category;
  final String status;
  final String date;
  final int views;
  final int likes;
  final String difficulty;
  final String duration;
}
