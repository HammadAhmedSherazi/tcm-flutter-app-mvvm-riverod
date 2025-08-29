import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../export_all.dart';
class HttpClient extends BaseApiServices {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;
  @override
  Future delete(
    String url,
    body, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isToken = true,
    bool isBaseUrl = true,
    bool isJsonEncode = true,
  }) async {
    dynamic responseJson;

    var customUrl = isBaseUrl ? BaseApiServices.baseURL : "";
    var uri =
        customUrl + url + ((params != null) ? queryParameters(params) : "");
    var parsedUrl = Uri.parse(uri);
    if (kDebugMode) {
      print(parsedUrl);
    }

    try {
      final response = await http
          .delete(
            parsedUrl,
            body: isJsonEncode ? jsonEncode(body) : body,
            headers: this.headers(headers, isToken),
          )
          .timeout(
            const Duration(seconds: 35),
          );

      responseJson = returnResponse(response);
    } on SocketException {
      throw _socketError();
    }
    return responseJson;
  }

  @override
  Future get(
    String url, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isToken = true,
    bool isBaseUrl = true,
    bool isCustomUrl = false,
  }) async {
    dynamic responseJson;
    String uri;
    if (isCustomUrl) {
      uri = url + ((params != null) ? queryParameters(params) : "");
    } else {
      var customUrl = isBaseUrl ? BaseApiServices.baseURL : "";
      uri = customUrl + url + ((params != null) ? queryParameters(params) : "");
    }
    var parsedUrl = Uri.parse(uri);
    if (kDebugMode) {
      print(parsedUrl);
    }

    try {
      final response = await http
          .get(
            parsedUrl,
            headers: this.headers(headers, isToken),
          )
          .timeout(
            const Duration(seconds: 35),
            // onTimeout: (){
            //   responseJson = null;
            //   return  responseJson;
            // }
          );
      responseJson = returnResponse(response);
    } on SocketException {
      throw _socketError();
    }

    return responseJson;
  }

  @override
  Future post(body,
      {Map<String, dynamic>? params,
      Map<String, String>? headers,
      bool isToken = true,
      bool isBaseUrl = true,
      bool isJsonEncode = true,
      bool isMultipartRequest = false,
      String? variableName}) async {
    dynamic responseJson;

    var parsedUrl = Uri.parse(BaseApiServices.baseURL);
    if (kDebugMode) {
      print(parsedUrl);
    }

    try {
      if (isMultipartRequest) {
        final request = http.MultipartRequest('POST', parsedUrl);
        final headersMap = this.headers(headers, isToken);

        // Remove content-type header for multipart requests
        headersMap.remove('Content-Type');
        request.headers.addAll(headersMap);

        // Add files from body (assuming body contains Map with 'files' key)
        if (body['files'] != null) {
          if (body['files'] is File) {
            // Single file case
            final file = body['files'] as File;
            final filePart = await http.MultipartFile.fromPath(
              '0', // Use '0' as the key to match the map
              file.path,
              contentType: MediaType(
                  'image', file.path.split(".").last), // Adjust as needed
            );
            request.files.add(filePart);
          } else if (body['files'] is List<File>) {
            final List<File> fileList = body['files'];
            for (var file in fileList) {
              final filePart = await http.MultipartFile.fromPath(
                DateTime.now()
                    .millisecondsSinceEpoch
                    .toString(), // Use '0' as the key to match the map
                file.path,
                contentType: MediaType(
                    'image', file.path.split(".").last), // Adjust as needed
              );
              request.files.add(filePart);
            }
            // Multiple files case
            // for (var fileEntry
            //     in (body['files'] as Map<String, List<File>>).entries) {
            //   final List<File> fileList =
            //       fileEntry.value; // Get the list of files
            //   final String fieldName =
            //       fileEntry.key; // The field name for the files

            // }
          } else {
            throw ArgumentError(
                'Invalid type for files. Expected File or Map<String, File>.');
          }
        }

    
  
        // Add other fields
        final variables = body['variables'] ?? {};
        final operations = {'query': body['query'], 'variables': variables};
        if (variableName != null) {
          final map = jsonEncode({
            "0": [variableName]
          });
          request.fields['operations'] = jsonEncode(operations);
          request.fields['map'] = map;
        }

        // Create the file map

        // Add the form fields

        // Send request and handle response
        final response = await request.send();
        final responseString = await response.stream.bytesToString();
        responseJson =
            returnResponse(http.Response(responseString, response.statusCode));
      } else {
        final response = await http
            .post(
              parsedUrl,
              body: isJsonEncode ? jsonEncode(body) : body,
              headers: this.headers(headers, isToken),
            )
            .timeout(
              const Duration(seconds: 35),
            );

        responseJson = returnResponse(response);
        if (kDebugMode) {
          print(response);
        }
      }
    } on SocketException {
      throw _socketError();
    }

    return responseJson;
  }

  @override
  Future put(
    String url,
    body, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isToken = true,
    bool isBaseUrl = true,
    bool isJsonEncode = true,
  }) async {
    dynamic responseJson;

    var customUrl = isBaseUrl ? BaseApiServices.baseURL : "";
    var uri =
        customUrl + url + ((params != null) ? queryParameters(params) : "");
    var parsedUrl = Uri.parse(uri);
    if (kDebugMode) {
      print(parsedUrl);
    }

    try {
      final response = await http
          .put(
            parsedUrl,
            body: isJsonEncode ? jsonEncode(body) : body,
            headers: this.headers(headers, isToken),
          )
          .timeout(
            const Duration(seconds: 35),
          );

      responseJson = returnResponse(response);
    } on SocketException {
      throw _socketError();
    }
    return responseJson;
  }

  @override
  Future patch(
    String url,
    body, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isToken = true,
    bool isBaseUrl = true,
    bool isJsonEncode = true,
  }) async {
    dynamic responseJson;

    var customUrl = isBaseUrl ? BaseApiServices.baseURL : "";
    var uri =
        customUrl + url + ((params != null) ? queryParameters(params) : "");
    var parsedUrl = Uri.parse(uri);
    if (kDebugMode) {
      print(parsedUrl);
    }

    try {
      final response = await http
          .patch(
            parsedUrl,
            body: isJsonEncode ? jsonEncode(body) : body,
            headers: this.headers(headers, isToken),
          )
          .timeout(
            const Duration(seconds: 35),
          );

      responseJson = returnResponse(response);
    } on SocketException {
      throw _socketError();
    }
    return responseJson;
  }

  // Customs headers would append here or return the default values
  Map<String, String> headers(Map<String, String>? headers, bool isToken) {
    var header = {
      HttpHeaders.contentTypeHeader: 'application/json ',
      HttpHeaders.acceptHeader: 'application/json',
    };

    if (isToken) {
      if (SharedPreferenceManager.sharedInstance.hasToken()) {
        header.putIfAbsent(
          "Authorization",
          () => "${SharedPreferenceManager.sharedInstance.getToken()}",
        );
      }
    }

    if (headers != null) {
      header.addAll(headers);
    }
    return header;
  }

  // Query Parameters
  String queryParameters(Map<String, dynamic>? params) {
    if (params != null) {
      final jsonString = Uri(
          queryParameters:
              params.map((key, value) => MapEntry(key, value.toString())));
      return '?${jsonString.query}';
    }
    return '';
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 203:
        var utf8Format = utf8.decode(response.bodyBytes);
        var responseJson = jsonDecode(utf8Format);
        return responseJson;
      case 400:
        Helper.showMessage(json.decode(response.body.toString())['errors']?[0]
                ['message'] ??
            "Something went wrong!");
        throw BadRequestException(
            response.statusCode, response.body.toString());
      case 401:
        String msg = json.decode(response.body.toString())['errors']?[0]
                ['message'] ??
            "Something went wrong!";
        Helper.showMessage(msg);
        if (SharedPreferenceManager.sharedInstance.getRefreshToken() != null &&
            SharedPreferenceManager.sharedInstance.getRefreshToken() != "") {
          AuthRemoteRepo.authRemoteInstance.updateToken(input: {
            "refreshToken":
                SharedPreferenceManager.sharedInstance.getRefreshToken()!
          }, query: GraphQLQueries.refreshTokenQuery);
          SharedPreferenceManager.sharedInstance.clearRefreshToken();
          SharedPreferenceManager.sharedInstance.clearToken();
        } else {
          SharedPreferenceManager.sharedInstance.clearAll();

          AppRouter.pushAndRemoveUntil(const LoginView());
          Helper.showMessage("Please login again!");
        }
        throw BadRequestException(
            response.statusCode, response.body.toString());
      case 403:
        Helper.showMessage(json.decode(response.body.toString())['errors']?[0]
                ['message'] ??
            "Something went wrong!");
        throw UnauthorisedException(
            response.statusCode, response.body.toString());
      case 404:
        final res = json.decode(response.body.toString());

        Map<String, dynamic> jsonMap = res['data'];
        if (jsonMap.containsKey('getAdDetail')) {
          // AppRouter.back();
          AppRouter.pushReplacement(const NoRecordFoundScreen());
        } else {
          Helper.showMessage(
              res['errors']?[0]['message'] ?? "Something went wrong!");
        }

        throw NotFoundRequestException(
            response.statusCode, response.body.toString());
      case 408:
        Helper.showMessage(json.decode(response.body.toString())['errors']?[0]
                ['message'] ??
            "Something went wrong!");
        throw RequestTimeOutException(
            response.statusCode, response.body.toString());
      case 422:
        Helper.showMessage(json.decode(response.body.toString())['errors']?[0]
                ['message'] ??
            "Something went wrong!");
        throw UnprocessableContent(
            response.statusCode, response.body.toString());
      case 423:
        Helper.showMessage(json.decode(response.body.toString())['errors']?[0]
                ['message'] ??
            "Something went wrong!");
        throw UnauthorisedException(
            response.statusCode, response.body.toString());
      case 500:
        Helper.showMessage(json.decode(response.body.toString())['errors']?[0]
                ['message'] ??
            "Something went wrong!");
        throw ServerException(response.statusCode, "Server Error");
      default:
        Helper.showMessage("Something went wrong!");
        throw FetchDataException(response.statusCode, response.body.toString());
    }
  }

  SocketConnectionError _socketError() {
    Helper.showMessage("No Internet Connection");
    return SocketConnectionError(
      800,
      json.encode({
        "message": "No Internet Connection",
      }),
    );
  }
}
