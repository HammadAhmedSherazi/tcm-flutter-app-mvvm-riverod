import '../export_all.dart';

class CommunityNotifier extends Notifier<CommunityState> {
  late final CommunityRemoteRepo remoteRepo;

  @override
  CommunityState build() {
    remoteRepo = CommunityRemoteRepo();
    return CommunityState();
  }

  void addImage(List<String> paths) {
    state = state.copyWith(selectImages: [...state.selectImages, ...paths]);
  }

  void removeImage(int index) {
    final updated = [...state.selectImages]..removeAt(index);
    state = state.copyWith(selectImages: updated);
  }

  void clearImage() {
    if (state.selectImages.isNotEmpty) {
      state = state.copyWith(selectImages: []);
    }
  }

  void resetUserData() {
    state = state.copyWith(userData: null);
  }

  Future<void> getPost({
    required String? cursor,
    required int limit,
    required bool myPost,
  }) async {
    try {
      final userJson =
          jsonDecode(SharedPreferenceManager.sharedInstance.getUserData()!);
      final user = UserDataModel.fromJson(userJson);

      state = state.copyWith(
        userData: state.userData?.id == user.id ? state.userData : user,
        getPostApiResponse:
            cursor == null ? ApiResponse.loading() : ApiResponse.loadingMore(),
        postCursor: cursor == null ? null : state.postCursor,
        posts: cursor == null ? [] : state.posts,
      );

      final response = await remoteRepo.getPostsRepo(
          cursor: cursor, limit: limit, myPost: myPost);

      if (response != null) {
        final data = response['data']['allPosts'];
        final List<PostDataModel> newPosts = List.from(
          data['data'].map((e) => PostDataModel.fromJson(e, user.id, false)),
        );

        state = state.copyWith(
          getPostApiResponse: ApiResponse.completed(data),
          postCursor: data['nextCursor'],
          posts: cursor == null ? newPosts : [...state.posts, ...newPosts],
        );
      } else {
        state = state.copyWith(
          getPostApiResponse: cursor == null
              ? ApiResponse.error()
              : ApiResponse.undertermined(),
        );
      }
    } catch (e) {
      state = state.copyWith(
        getPostApiResponse:
            cursor == null ? ApiResponse.error() : ApiResponse.undertermined(),
      );
    }
  }

  Future<void> createPost({
    required String content,
    required List<File>? images,
  }) async {
    try {
      // Set loading state
      state = state.copyWith(createPostApiResponse: ApiResponse.loading());

      final response =
          await remoteRepo.createPostRepo(content: content, images: images);

      if (response != null) {
        final data = response['data']['createPost'];
        final postData =
            PostDataModel.fromJson(data['data'], state.userData!.id, false);

        // Show success message
        Helper.showMessage(data['message']);

        // Insert new post at the top
        final updatedPosts = [postData, ...state.posts];

        // Update state with completed response and new post list
        state = state.copyWith(
          createPostApiResponse: ApiResponse.completed(data),
          posts: updatedPosts,
        );

        // Navigate back
        AppRouter.back();
      } else {
        state = state.copyWith(createPostApiResponse: ApiResponse.error());
      }
    } catch (e) {
      state = state.copyWith(createPostApiResponse: ApiResponse.error());
    }
  }

  Future<void> createPostComment({
    required String content,
    required int id,
  }) async {
    try {
      // Set loading state
      state = state.copyWith(createPostApiResponse: ApiResponse.loading());

      final response =
          await remoteRepo.createCommentRepo(content: content, id: id);

      if (response != null) {
        final data = response['data']['createPostComment'];

        // Show success message
        Helper.showMessage(data['message']);

        // Update API response state
        state =
            state.copyWith(createPostApiResponse: ApiResponse.completed(data));
      } else {
        state = state.copyWith(createPostApiResponse: ApiResponse.error());
      }
    } catch (e) {
      state = state.copyWith(createPostApiResponse: ApiResponse.error());
    }
  }

  Future<void> updatePost({
    required String content,
    required int id,
    required List<File>? newImages,
    required List<String>? oldImages,
    required int index,
  }) async {
    try {
      // Set loading state
      state = state.copyWith(createPostApiResponse: ApiResponse.loading());

      final response = await remoteRepo.updatePostRepo(
        content: content,
        newImages: newImages,
        id: id,
        oldImages: oldImages,
      );

      if (response != null) {
        final data = response['data']['updatePost'];

        // Parse updated post
        final updatedPost =
            PostDataModel.fromJson(data['data'], state.userData!.id, true);

        // Replace the post at the specified index
        final updatedPosts = [...state.posts];
        updatedPosts[index] = updatedPost;

        // Update state
        state = state.copyWith(
          createPostApiResponse: ApiResponse.completed(data),
          posts: updatedPosts,
        );

        // Show success and navigate back
        Helper.showMessage(data['message']);
        AppRouter.back();
      } else {
        state = state.copyWith(createPostApiResponse: ApiResponse.error());
      }
    } catch (e) {
      state = state.copyWith(createPostApiResponse: ApiResponse.error());
    }
  }

  Future<void> reportPost({required int id}) async {
    state = state.copyWith(createPostApiResponse: ApiResponse.loading());
    final response = await remoteRepo.reportPostCommentRepo(id: id);
    if (response != null) {
      final data = response['data']['reportPost'];
      state =
          state.copyWith(createPostApiResponse: ApiResponse.completed(data));
      Helper.showMessage(data['message']);
    } else {
      state = state.copyWith(createPostApiResponse: ApiResponse.error());
    }
  }

  Future<void> deletePost({required int id, required int index}) async {
    state = state.copyWith(createPostApiResponse: ApiResponse.loading());
    final response = await remoteRepo.deletePostRepo(id: id);
    if (response != null) {
      final data = response['data']['deletePost'];
      final updatedPosts = [...state.posts]..removeAt(index);
      state = state.copyWith(
        createPostApiResponse: ApiResponse.completed(data),
        posts: updatedPosts,
      );
      Helper.showMessage(data['message']);
    } else {
      state = state.copyWith(createPostApiResponse: ApiResponse.error());
    }
    AppRouter.back();
  }

  Future<void> deletePostComment({
    required int id,
    required int index,
    required int postIndex,
  }) async {
    final post = state.posts[postIndex];
    state = state.copyWith(createPostApiResponse: ApiResponse.loading());
    final response = await remoteRepo.deletePostCommentRepo(id: id);
    if (response != null) {
      final data = response['data']['deletePostComment'];
      final updatedComments = [...state.comments]..removeAt(index);
      final updatedPost =
          post.copyWith(commentCount: (post.commentCount ?? 1) - 1);
      final updatedPosts = [...state.posts];
      updatedPosts[postIndex] = updatedPost;

      state = state.copyWith(
        createPostApiResponse: ApiResponse.completed(data),
        comments: updatedComments,
        posts: updatedPosts,
      );
      Helper.showMessage(data['message']);
      AppRouter.back();
    } else {
      state = state.copyWith(createPostApiResponse: ApiResponse.error());
    }
  }

  Future<void> likePost({required String? react, required int index}) async {
    final originalPost = state.posts[index];
    final newReactions = Map<String, int>.from(originalPost.reactions ?? {});
    String? currentReaction = originalPost.myReaction;
    num newReactionCount = originalPost.reactionCount;

    if (react == null) {
      if (currentReaction != null &&
          newReactions.containsKey(currentReaction)) {
        final count = newReactions[currentReaction]!;
        if (count > 1) {
          newReactions[currentReaction] = count - 1;
        } else {
          newReactions.remove(currentReaction);
        }
        newReactionCount = newReactionCount > 0 ? newReactionCount - 1 : 0;
      }
      state.posts[index] = originalPost.copyWith(
        myReaction: null,
        reactions: newReactions,
        reactionCount: newReactionCount,
      );
    } else {
      bool isFirstTimeReacting = currentReaction == null;
      if (currentReaction != null && currentReaction != react) {
        final oldCount = newReactions[currentReaction] ?? 0;
        if (oldCount > 1) {
          newReactions[currentReaction] = oldCount - 1;
        } else {
          newReactions.remove(currentReaction);
        }
        newReactions[react] = (newReactions[react] ?? 0) + 1;
      } else if (isFirstTimeReacting) {
        newReactions[react] = (newReactions[react] ?? 0) + 1;
      } else {
        return;
      }

      if (isFirstTimeReacting) newReactionCount += 1;

      final updatedPost = originalPost.copyWith(
        myReaction: react,
        reactions: newReactions,
        reactionCount: newReactionCount,
      );

      final updatedPosts = [...state.posts];
      updatedPosts[index] = updatedPost;

      state = state.copyWith(posts: updatedPosts);
    }

    final response =
        await remoteRepo.likePostRepo(id: originalPost.id, react: react);
    if (response == null) {
      final rolledBackPosts = [...state.posts];
      rolledBackPosts[index] = originalPost;
      state = state.copyWith(posts: rolledBackPosts);
    }
  }

  Future<void> getComments({
    required int limit,
    required String? cursor,
    required int postId,
  }) async {
    try {
      // Load userData once
      if (state.userData == null) {
        final userJson = jsonDecode(
          SharedPreferenceManager.sharedInstance.getUserData()!,
        );
        state = state.copyWith(
          userData: UserDataModel.fromJson(userJson),
        );
      }

      // Set loading state
      final loadingState =
          cursor == null ? ApiResponse.loading() : ApiResponse.loadingMore();
      state = state.copyWith(getPostCommentApiResponse: loadingState);

      // Reset comments if fresh load
      final shouldReset = cursor == null;
      final currentComments =
          shouldReset ? <CommentModel>[] : [...state.comments];

      // Fetch response
      final response = await remoteRepo.getPostCommentRepo(
        id: postId,
        cursor: cursor,
        limit: limit,
      );

      if (response != null) {
        final data = response['data']['getAllPostComments'];
        final commentList = List<CommentModel>.from(
          data['data'].map((e) => CommentModel.fromJson(e)),
        );
        final updatedComments = [...currentComments, ...commentList];

        state = state.copyWith(
          getPostCommentApiResponse: ApiResponse.completed(data),
          comments: updatedComments,
          commentCursor: data['nextCursor'],
        );
      } else {
        state = state.copyWith(
          getPostCommentApiResponse:
              shouldReset ? ApiResponse.error() : ApiResponse.undertermined(),
        );
      }
    } catch (e) {
      state = state.copyWith(
        getPostCommentApiResponse:
            cursor == null ? ApiResponse.error() : ApiResponse.undertermined(),
      );
    }
  }

  Future<void> createComment({
    required int postId,
    required String comment,
    required int index,
  }) async {
    try {
      final response = await remoteRepo.createCommentRepo(
        id: postId,
        content: comment,
      );

      if (response != null) {
        final data = response['data']['createPostComment'];
        final newComment = CommentModel.fromJson(data['data']);

        // Update comments
        final updatedComments = [...state.comments, newComment];

        // Update corresponding post's commentCount
        final post = state.posts[index];
        final updatedPost = post.copyWith(commentCount: post.commentCount! + 1);
        final updatedPosts = [...state.posts]..[index] = updatedPost;

        state = state.copyWith(
          comments: updatedComments,
          posts: updatedPosts,
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void userDataReset() {
    state = state.copyWith(userData: null);
  }

  // You would continue refactoring all your async methods
  // like getPost(), createPost(), etc., using:
  // state = state.copyWith(...updated fields...)
}

// final communityRepoProvider = ChangeNotifierProvider<CommunityProvider>(
//   (ref) {
//     // ref.keepAlive();
//     return CommunityProvider(remoteRepo: CommunityRemoteRepo());
//   },
// );
final communityProvider =
    NotifierProvider<CommunityNotifier, CommunityState>(() {
  return CommunityNotifier();
});

class CommunityState {
  final ApiResponse createPostApiResponse;
  final ApiResponse getPostApiResponse;
  final ApiResponse getPostCommentApiResponse;
  final List<PostDataModel> posts;
  final List<String> selectImages;
  final List<CommentModel> comments;
  final String? postCursor;
  final String? commentCursor;
  final UserDataModel? userData;

  CommunityState({ 
    this.createPostApiResponse =  ApiResponse.undertermined(),
    this.getPostApiResponse = ApiResponse.undertermined(),
    this.getPostCommentApiResponse = ApiResponse.undertermined(),
    this.posts = const [],
    this.selectImages = const [],
    this.comments = const [],
    this.postCursor,
    this.commentCursor,
    this.userData,
  });

  CommunityState copyWith({
    ApiResponse? createPostApiResponse,
    ApiResponse? getPostApiResponse,
    ApiResponse? getPostCommentApiResponse,
    List<PostDataModel>? posts,
    List<String>? selectImages,
    List<CommentModel>? comments,
    String? postCursor,
    String? commentCursor,
    UserDataModel? userData,
  }) {
    return CommunityState(
      createPostApiResponse:
          createPostApiResponse ?? this.createPostApiResponse,
      getPostApiResponse: getPostApiResponse ?? this.getPostApiResponse,
      getPostCommentApiResponse:
          getPostCommentApiResponse ?? this.getPostCommentApiResponse,
      posts: posts ?? this.posts,
      selectImages: selectImages ?? this.selectImages,
      comments: comments ?? this.comments,
      postCursor: postCursor ?? this.postCursor,
      commentCursor: commentCursor ?? this.commentCursor,
      userData: userData ?? this.userData,
    );
  }
}
