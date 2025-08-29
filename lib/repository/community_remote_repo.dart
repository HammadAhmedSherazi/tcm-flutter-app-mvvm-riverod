import 'package:http/http.dart' as http;
import '../export_all.dart';
import '../data/network/http_client.dart';


abstract class CommunityRemoteRepoSource {
  createPostRepo(
      {required String content, required List<File>? images}) async {}
  getPostsRepo(
      {required String? cursor,
      required int limit,
      required bool myPost}) async {}
  deletePostRepo({required int id}) async {}
  updatePostRepo(
      {required String content,
      required List<File>? newImages,
      required int id,
      required List<String>? oldImages}) async {}
  createCommentRepo({required String content, required int id}) async {}
  deletePostCommentRepo({required int id}) async {}
  reportPostCommentRepo({required int id}) async {}
  likePostRepo({required int id, required String? react}) async {}
  getPostCommentRepo(
      {required int id, required String? cursor, required int limit}) {}
}

class CommunityRemoteRepo extends CommunityRemoteRepoSource {
  @override
  createPostRepo({required String content, required List<File>? images}) async {
    try {
      final result = images != null
          ? createPost({
              "input": {"content": content},
              "images": List.filled(images.length, null),
            }, images, GraphQLQueries.createPostQuery, "variables.images")
          // HttpClient.instance.post({
          //     'query': GraphQLQueries.createPostQuery,
          //     'variables': {
          //       "input": {"content": content},
          //     },
          //     'files': images
          //   }, isMultipartRequest: true, variableName: "variables.input.images")
          : await HttpClient.instance.post(
              {
                'query': GraphQLQueries.createPostQuery,
                'variables': {
                  "input": {"content": content},
                  "images": null
                },
              },
            );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  getPostsRepo(
      {required String? cursor,
      required int limit,
      required bool myPost}) async {
    try {
      final result = await HttpClient.instance.post({
        'query': GraphQLQueries.allPostQuery,
        'variables': {
          "input": {"cursor": cursor, "limit": limit, "my_post": myPost},
        },
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  deletePostRepo({required int id}) {
    try {
      final result = HttpClient.instance.post({
        'query': GraphQLQueries.deletePostQuery,
        'variables': {"deletePostId": id},
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  updatePostRepo(
      {required String content,
      required List<File>? newImages,
      required int id,
      required List<String>? oldImages}) async {
    try {
      final result = newImages != null
          ? await createPost({
              "input": {"content": content, "id": id, "images": oldImages},
              "newImages": List.filled(newImages.length, null),
            }, newImages, GraphQLQueries.updatePostQuery,
              "variables.newImages")
          : await HttpClient.instance.post(
              {
                'query': GraphQLQueries.updatePostQuery,
                'variables': {
                  "input": {"content": content, "id": id, "images": oldImages},
                  "new_images": null
                },
              },
            );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  createCommentRepo({required String content, required int id}) {
    try {
      final result = HttpClient.instance.post({
        'query': GraphQLQueries.createCommentQuery,
        'variables': {
          "input": {"comment": content, "post_id": id}
        },
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  deletePostCommentRepo({required int id}) {
    try {
      final result = HttpClient.instance.post({
        'query': GraphQLQueries.deleteCommentQuery,
        'variables': {"deletePostCommentId": id},
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  reportPostCommentRepo({required int id}) {
    try {
      final result = HttpClient.instance.post({
        'query': GraphQLQueries.reportPostQuery,
        'variables': {"reportPostId": id},
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  likePostRepo({required int id, required String? react}) {
    try {
      final result = HttpClient.instance.post({
        'query': GraphQLQueries.likePostQuery,
        'variables': {
          "input": {"post_id": id, "reaction": react}
        },
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  getPostCommentRepo(
      {required int id, required String? cursor, required int limit}) {
    try {
      final result = HttpClient.instance.post({
        'query': GraphQLQueries.postCommentQuery,
        'variables': {
          "input": {"cursor": cursor, "limit": limit, "post_id": id}
        },
      });
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}

// Future<dynamic> updatePost(
//   Map<String, dynamic> input,
//   List<File>? images,
//   String query,
// ) async {
//   final url = Uri.parse(BaseApiServices.baseURL);

//   // Correct variable initialization for file uploads
//   final variables = {
//     "input": input,
//     "new_images": images != null ? List.filled(images.length, null) : null,
//   };

//   final operations = jsonEncode({
//     "query": query,
//     "variables": variables,
//   });

//   final Map<String, dynamic> fileMap = {};

//   // Correct file mapping using image indices
//   if (images != null) {
//     for (int i = 0; i < images.length; i++) {
//       fileMap[i.toString()] = ["variables.new_images.$i"];
//     }
//   }

//   final request = http.MultipartRequest('POST', url)
//     ..headers['Authorization'] =
//         "${SharedPreferenceManager.sharedInstance.getToken()}"
//     ..fields['operations'] = operations
//     ..fields['map'] = jsonEncode(fileMap);

//   // Correct file attachment with proper indices and filenames
//   if (images != null) {
//     for (int i = 0; i < images.length; i++) {
//       final file = images[i];
//       final filePart = await http.MultipartFile.fromPath(
//         i.toString(), // Match the part index with map key
//         file.path,
//         filename:
//             file.path.split('/').last, // Get actual filename with extension
//       );
//       request.files.add(filePart);
//     }
//   }

//   try {
//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);
//     return HttpClient.instance.returnResponse(response);
//   } catch (e) {
//     throw Exception('Failed to create ad: $e');
//   }
// }

Future<dynamic> createPost(Map<String, dynamic> input, List<File>? images,
    String query, String variableName) async {
  final url = Uri.parse(BaseApiServices.baseURL);

  // Correct variable initialization for file uploads
  // final variables = {
  //   "input": input,
  //   "images": images != null ? List.filled(images.length, null) : null,
  // };

  final operations = jsonEncode({
    "query": query,
    "variables": input,
  });

  final Map<String, dynamic> fileMap = {};

  // Correct file mapping using image indices
  if (images != null) {
    for (int i = 0; i < images.length; i++) {
      fileMap[i.toString()] = ["$variableName.$i"];
    }
  }

  final request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] =
        "${SharedPreferenceManager.sharedInstance.getToken()}"
    ..fields['operations'] = operations
    ..fields['map'] = jsonEncode(fileMap);

  // Correct file attachment with proper indices and filenames
  if (images != null) {
    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      final filePart = await http.MultipartFile.fromPath(
        i.toString(), // Match the part index with map key
        file.path,
        filename:
            file.path.split('/').last, // Get actual filename with extension
      );
      request.files.add(filePart);
    }
  }

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return HttpClient.instance.returnResponse(response);
  } catch (e) {
    throw Exception('Failed to create ad: $e');
  }
}
