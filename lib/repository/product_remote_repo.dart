import 'package:http/http.dart' as http;
import '../data/network/http_client.dart';
import '../export_all.dart';

abstract class ProductRemoteRepoSource {
  Future sendRequest(
      {required Map<String, dynamic> input, required String query}) async {}
  Future createAdRepo(
      {required Map<String, dynamic> input,
      required String query,
      required List<File> buyingReceipts,
      required List<File> productImageFile}) async {}
  Future createProductReviewRepo(
      {required Map<String, dynamic> input,
      required String query,
      required List<File>? images,
      required String imageString}) async {}
  Future updateAdRepo(
      {required Map<String, dynamic> input,
      required String query,
      required List<File>? buyingReceipts,
      required List<File>? productImageFile}) async {}
  Future customRepo(
      {required Map<String, dynamic> input, required String query}) async {}
  
  Future createRefundRepo(
      {required Map<String, dynamic> input, required List<File> images ,required String query}) async {}
}

class ProductRemoteRepo extends ProductRemoteRepoSource {
  @override
  Future sendRequest(
      {required Map<String, dynamic> input, required String query}) {
    try {
      final response = HttpClient.instance.post(
        {
          'query': query,
          'variables': {
            'input': input,
          },
        },
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future createAdRepo(
      {required Map<String, dynamic> input,
      required String query,
      required List<File> buyingReceipts,
      required List<File> productImageFile,

      }) {
    try {
      final response = createAd(input, buyingReceipts, productImageFile, query, false);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future createRefundRepo({required Map<String, dynamic> input, required List<File> images, required String query}) {
     try {
      final response = reviewRepo(input, images, query, 'images');
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future updateAdRepo(
      {required Map<String, dynamic> input,
      required String query,
      required List<File>? buyingReceipts,
      required List<File>? productImageFile}) {
    try {
      final response = createAd(input, buyingReceipts, productImageFile, query, true);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future customRepo(
      {required Map<String, dynamic> input, required String query}) {
    try {
      final response = HttpClient.instance.post(
        {
          'query': query,
          'variables': input,
        },
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future createProductReviewRepo(
      {required Map<String, dynamic> input,
      required String query,
      required List<File>? images,
      required String imageString}) {
    try {
      final response = reviewRepo(input, images, query, imageString);
          
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

Future<dynamic> createAd(Map<String, dynamic> input, List<File>? buyingReceipts,
    List<File>? images, String query, bool isUpdate) async {
  // Replace with your GraphQL endpoint
  final url = Uri.parse(BaseApiServices.baseURL);

  // Construct GraphQL variables
  final variables = isUpdate ? {
    "input": input,
    "newReceipt": buyingReceipts != null
        ? List.filled(buyingReceipts.length, null)
        : [],
    "newImages": images != null ? List.filled(images.length, null) : [],
  }: {
    "input": input,
    "buying_receipt": buyingReceipts != null
        ? List.filled(buyingReceipts.length, null)
        : null,
    "images": images != null ? List.filled(images.length, null) : null,
  };

  // Prepare the 'operations' and 'map' fields
  final operations = jsonEncode({
    "query": query,
    "variables": variables,
  });

  final Map<String, dynamic> fileMap = {};
  int partIndex = 0;

  // Assign buying receipt files
  if (buyingReceipts != null) {
    for (int i = 0; i < buyingReceipts.length; i++) {
      fileMap[partIndex.toString()] =isUpdate ?["variables.newReceipt.$i"] : ["variables.buyingReceipt.$i"];
      partIndex++;
    }
  }

  // Assign image files
  if (images != null) {
    for (int i = 0; i < images.length; i++) {
      fileMap[partIndex.toString()] = isUpdate ?["variables.newImages.$i"] : ["variables.images.$i"];
      partIndex++;
    }
  }

  // Create multipart request
  final request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] =
        "${SharedPreferenceManager.sharedInstance.getToken()}"
    ..fields['operations'] = operations
    ..fields['map'] = jsonEncode(fileMap);

  // Attach buying receipt files
  partIndex = 0;
  if (buyingReceipts != null) {
    for (final file in buyingReceipts) {
      final filePart = await http.MultipartFile.fromPath(
        partIndex.toString(),
        file.path,
        filename: file.path.split('.').last,
      );
      request.files.add(filePart);
      partIndex++;
    }
  }

  // Attach image files
  if (images != null) {
    for (final file in images) {
      final filePart = await http.MultipartFile.fromPath(
        partIndex.toString(),
        file.path,
        filename: file.path.split('.').last,
      );
      request.files.add(filePart);
      partIndex++;
    }
  }

  // Send request
  try {
    final streamedResponse = await request.send();
    http.Response response = await http.Response.fromStream(streamedResponse);

    return HttpClient.instance.returnResponse(response);
  } catch (e) {
    throw Exception(e);
  }
}

// Future<dynamic> createRefund(Map<String, dynamic> input,
//     List<File> images, String query) async {
//   // Replace with your GraphQL endpoint
//   final url = Uri.parse(BaseApiServices.baseURL);

//   // Construct GraphQL variables
//   final variables = {
//     "input": input,
   
//   };

//   // Prepare the 'operations' and 'map' fields
//   final operations = jsonEncode({
//     "query": query,
//     "variables": variables,
//   });

//   final Map<String, dynamic> fileMap = {};
//   int partIndex = 0;

 

//   // Assign image files
 
//     for (int i = 0; i < images.length; i++) {
//       fileMap[partIndex.toString()] = "variables.input.images.$i";
//       partIndex++;
//     }
  

//   // Create multipart request
//   final request = http.MultipartRequest('POST', url)
//     ..headers['Authorization'] =
//         "${SharedPreferenceManager.sharedInstance.getToken()}"
//     ..fields['operations'] = operations
//     ..fields['map'] = jsonEncode(fileMap);

//   // Attach buying receipt files
//   partIndex = 0;


//   // Attach image files
//   // if (images != null) {
//     for (final file in images) {
//       final filePart = await http.MultipartFile.fromPath(
//         partIndex.toString(),
//         file.path,
//         filename: file.path.split('.').last,
//       );
//       request.files.add(filePart);
//       partIndex++;
//     }
//   // }

//   // Send request
//   try {
//     final streamedResponse = await request.send();
//     http.Response response = await http.Response.fromStream(streamedResponse);

//     return HttpClient.instance.returnResponse(response);
//   } catch (e) {
//     throw Exception(e);
//   }
// }

Future<dynamic> reviewRepo(
  Map<String, dynamic> input,
  List<File>? images,
  String query,
  String variableName,
) async {
  final url = Uri.parse(BaseApiServices.baseURL);

  // Replace images field with null or a list of nulls (Upload placeholders)
  if (images != null) {
    input[variableName] = List.generate(images.length, (_) => null);
  } else {
    input[variableName] = null;
  }

  final variables = {
    "input": input,
  };

  final operations = jsonEncode({
    "query": query,
    "variables": variables,
  });

  final Map<String, dynamic> fileMap = {};
  if (images != null) {
    for (int i = 0; i < images.length; i++) {
      fileMap["$i"] = ["variables.input.$variableName.$i"];
    }
  }

  final request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] =
        "${SharedPreferenceManager.sharedInstance.getToken()}"
    ..fields['operations'] = operations
    ..fields['map'] = jsonEncode(fileMap);

  // Add files
  if (images != null) {
    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      final filePart = await http.MultipartFile.fromPath(
        "$i", // key should match map key
        file.path,
        filename: file.path.split('/').last,
      );
      request.files.add(filePart);
    }
  }

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return HttpClient.instance.returnResponse(response);
  } catch (e) {
    throw Exception("Upload failed: $e");
  }
}
