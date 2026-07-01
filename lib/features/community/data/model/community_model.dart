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

  static PostCategory fromApi(String value) {
    return PostCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
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

  /// Value sent as `statusFilter` query parameter to the API.
  String get apiValue => switch (this) {
    CommunityFilter.all => '',
    CommunityFilter.reported => 'reported',
    CommunityFilter.flagged => 'flagged',
    CommunityFilter.deleted => 'deleted',
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

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String? ?? '',
      author: json['authorName'] as String? ?? json['author'] as String? ?? '',
      timeAgo: json['timeAgo'] as String? ?? json['createdAt'] as String? ?? '',
      category: PostCategoryLabel.fromApi(json['category'] as String? ?? ''),
      content: json['content'] as String? ?? '',
      status: PostStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'active').toLowerCase(),
        orElse: () => PostStatus.active,
      ),
    );
  }
}
