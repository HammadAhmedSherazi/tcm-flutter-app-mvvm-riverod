import 'package:intl/intl.dart';

import '../export_all.dart';

class PostDataModel {
  final int id;
  final UserDataModel? user;
  final String? postText;

  final List<String>? postImages;
  final num reactionCount;
  final String? myReaction;
  // final num? likedCount;
  final num? commentCount;
  final bool? isMyPost;
  final DateTime? createdAt;
  final Map<String, dynamic>? reactions;
  // final List<String>? topReactions;
  // final List<UserComments>? comments;

  // Constructor with required parameters and optional parameters
  PostDataModel(
      {required this.id,
      required this.user,
      required this.postText,


      // required this.comments,
      required this.postImages,
      required this.reactionCount,
      this.commentCount = 0,
      this.myReaction,
      this.reactions,
      this.createdAt,
      this.isMyPost,
      // this.likedCount = 0,


      // this.topReactions,
      });
      PostDataModel copyWith({
  int? id,
  UserDataModel? user,
  String? postText,
  List<String>? postImages,
  num? reactionCount,
  String? myReaction,
  num? commentCount,
  bool? isMyPost,
  DateTime? createdAt,
  Map<String, dynamic>? reactions,
}) {
  return PostDataModel(
    id: id ?? this.id,
    user: user ?? this.user,
    postText: postText ?? this.postText,
    postImages: postImages ?? this.postImages,
    reactionCount: reactionCount ?? this.reactionCount,
    myReaction: myReaction ,
    commentCount: commentCount ?? this.commentCount,
    isMyPost: isMyPost ?? this.isMyPost,
    createdAt: createdAt ?? this.createdAt,
    reactions: reactions ?? this.reactions,
  );
}
  // Factory method to create an instance from JSON
  factory PostDataModel.fromJson(
      Map<String, dynamic> json, int userId, bool isUpdate) {
        final reactionMap = json['reactions'] as Map<String, dynamic>?;
        final int reactionCount = reactionMap != null
    ? reactionMap.values.fold(0, (sum, value) => sum + (value as int))
    : 0;
    return PostDataModel(
        id: json['id'],
        user:
            json['user'] != null ? UserDataModel.fromJson(json['user']) : null,
        postText: json['content'] as String?,
        reactions: reactionMap,
        myReaction: json['my_reaction'],
        postImages: (json['images'] as List?)
            ?.map((e) => (e as String).contains(BaseApiServices.imageURL)? e:  "${BaseApiServices.imageURL}$e")
            .toList(),
        createdAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            .parseUtc(isUpdate ? json['updated_at'] : json['created_at'])
            .toLocal(),
        reactionCount: reactionCount,
        
        // likedCount: json['love_count'] as num? ?? 0,
        commentCount: json['comments_count'] as num? ?? 0,
        isMyPost: json['user']['id'] == userId

        // topReactions: (json['topReactions'] as List?)?.map((e) => e as String).toList(),
        // comments: null
        // comments: (json['comments'] as List?)
        //     ?.map((e) => UserComments.fromJson(e as Map<String, dynamic>))
        //     .toList(),
        );
  }
}

class CommentModel {
  final int id;
  final int postId;
  final int? userId;
  final String comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserDataModel? user;

  CommentModel({
    required this.id,
    required this.postId,
    this.userId,
    required this.comment,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  /// Factory method to parse JSON into a CommentModel object
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      comment: json['comment'],
      createdAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(json['created_at'])
          .toLocal(),
      updatedAt: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(json['updated_at'])
          .toLocal(),
      user: UserDataModel.fromJson(json['user']),
    );
  }

  /// Converts CommentModel object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'comment': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
    };
  }
}


// class ReactionDataModel {
//   late final String emoji;
//   late final int count;

//   ReactionDataModel.from(Map<String, dynamic> json){
//     emoji = json[''];
//     count = json[''];
//   }
  
// }