import 'package:drive_mate_dash_board/features/community/data/model/community_model.dart';

abstract class CommunityRepo {
  Future<List<CommunityPost>> fetchPosts({
    CommunityFilter filter,
    String? query,
  });
  Future<void> flagPost(String postId);
  Future<void> approvePost(String postId);
  Future<void> deletePost(String postId);
}

class CommunityRepoImpl implements CommunityRepo {
  // final Dio _dio;
  // CommunityRepoImpl(this._dio);

  @override
  Future<List<CommunityPost>> fetchPosts({
    CommunityFilter filter = CommunityFilter.all,
    String? query,
  }) async {
    // TODO: replace with real API call:
    // final res = await _dio.get('/community/posts', queryParameters: {
    //   'filter': filter.name,
    //   if (query != null && query.isNotEmpty) 'q': query,
    // });
    // return (res.data as List)
    //     .map((e) => CommunityPost.fromJson(e as Map<String, dynamic>))
    //     .toList();

    await Future.delayed(const Duration(milliseconds: 500));

    var posts = _mockPosts;

    // Apply filter
    posts = switch (filter) {
      CommunityFilter.all => posts,
      CommunityFilter.reported =>
        posts.where((p) => p.category == PostCategory.report).toList(),
      CommunityFilter.flagged =>
        posts.where((p) => p.status == PostStatus.flagged).toList(),
      CommunityFilter.deleted =>
        posts.where((p) => p.status == PostStatus.deleted).toList(),
    };

    // Apply search
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      posts = posts
          .where(
            (p) =>
                p.author.toLowerCase().contains(q) ||
                p.content.toLowerCase().contains(q) ||
                p.category.label.toLowerCase().contains(q),
          )
          .toList();
    }

    return posts;
  }

  @override
  Future<void> flagPost(String postId) async {
    // TODO: await _dio.patch('/community/posts/$postId/flag');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> approvePost(String postId) async {
    // TODO: await _dio.patch('/community/posts/$postId/approve');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> deletePost(String postId) async {
    // TODO: await _dio.delete('/community/posts/$postId');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // ── Mock data ──────────────────────────────────────────────────────────────

  static const List<CommunityPost> _mockPosts = [
    CommunityPost(
      id: '1',
      author: 'Sarah Jenkins',
      timeAgo: '2 hours ago',
      category: PostCategory.question,
      content:
          'Has anyone experienced a rattling noise when accelerating past 60mph in the new 2024 model? It sounds like it is coming from the passenger side.',
      status: PostStatus.active,
    ),
    CommunityPost(
      id: '2',
      author: 'Mike Chen',
      timeAgo: '5 hours ago',
      category: PostCategory.marketplace,
      content:
          'Selling my 2020 OEM rims. Great condition, no scratches. \$400 for the set. Pickup only in Downtown area.',
      status: PostStatus.flagged,
    ),
    CommunityPost(
      id: '3',
      author: 'DriveMate Bot',
      timeAgo: '1 day ago',
      category: PostCategory.tip,
      content:
          'Weekly Maintenance Tip: Check your tire pressure every Sunday night to ensure optimal fuel efficiency for the week ahead!',
      status: PostStatus.active,
    ),
    CommunityPost(
      id: '4',
      author: 'Omar Al Rashidi',
      timeAgo: '1 day ago',
      category: PostCategory.discussion,
      content:
          'Anyone know a good mechanic in Abu Dhabi for Tesla servicing? The official center has a 3 week wait.',
      status: PostStatus.active,
    ),
    CommunityPost(
      id: '5',
      author: 'Layla Hassan',
      timeAgo: '2 days ago',
      category: PostCategory.report,
      content:
          'This user is posting fake car listings with stolen photos. Third time this week.',
      status: PostStatus.flagged,
    ),
    CommunityPost(
      id: '6',
      author: 'Ahmed Karim',
      timeAgo: '3 days ago',
      category: PostCategory.marketplace,
      content: 'Removed — violated community selling guidelines.',
      status: PostStatus.deleted,
    ),
  ];
}