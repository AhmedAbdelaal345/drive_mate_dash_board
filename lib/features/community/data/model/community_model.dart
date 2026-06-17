enum PostStatus { active, flagged, deleted }

enum PostCategory { question, marketplace, tip, discussion, report, other }

extension PostCategoryLabel on PostCategory {
  String get label => switch (this) {
        PostCategory.question => 'Question',
        PostCategory.marketplace => 'Marketplace',
        PostCategory.tip => 'Tip',
        PostCategory.discussion => 'Discussion',
        PostCategory.report => 'Report',
        PostCategory.other => 'Other',
      };

  static PostCategory fromString(String value) {
    return PostCategory.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => PostCategory.other,
    );
  }
}

enum CommunityFilter { all, reported, flagged, deleted }

extension CommunityFilterLabel on CommunityFilter {
  String get label => switch (this) {
        CommunityFilter.all => 'All',
        CommunityFilter.reported => 'Reported',
        CommunityFilter.flagged => 'Flagged',
        CommunityFilter.deleted => 'Deleted',
      };
}

class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.author,
    required this.timeAgo,
    required this.category,
    required this.content,
    required this.status,
  });

  final String id;
  final String author;
  final String timeAgo;
  final PostCategory category;
  final String content;
  final PostStatus status;

  CommunityPost copyWith({PostStatus? status}) {
    return CommunityPost(
      id: id,
      author: author,
      timeAgo: timeAgo,
      category: category,
      content: content,
      status: status ?? this.status,
    );
  }

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      author: json['author'] as String,
      timeAgo: json['time_ago'] as String,
      category: PostCategoryLabel.fromString(json['category'] as String),
      content: json['content'] as String,
      status: PostStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String).toLowerCase(),
        orElse: () => PostStatus.active,
      ),
    );
  }
}