abstract class BaseApiServices {
  // //DEV URL
  static String baseURL = "https://api-tcm.mmcgbl.dev/graphql";
  // static String baseURL =   "http://192.168.18.182:4001/graphql";

  static String weatherAppId = "28a9b26783d5b53ed2f25d7dd7717889";
  //Staging URL
  // static String baseURL = "https://a4d0-115-42-66-72.ngrok-free.app//graphql";
  static String imageURL =  baseURL.replaceAll('/graphql', '');
  //LIVE URL
  // static String baseURL = "https://api-tcm.mmcgbl.dev/graphql";
  // static String socketURL = "https://test.captals.com:299/notificationHub";

  // static String imageURL = "https://api-tcm.mmcgbl.dev/";

  


  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isToken = true,
    bool isBaseUrl = true,
  });

  Future<dynamic> post(

    dynamic body, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isToken = true,
    bool isBaseUrl = true,
    bool isJsonEncode = true,
    bool isMultipartRequest = false,
    String? variableName
  });

  Future<dynamic> put(
    String url,
    dynamic body, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isToken = true,
    bool isBaseUrl = true,
    bool isJsonEncode = true,
  });

  Future<dynamic> patch(
    String url,
    dynamic body, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isToken = true,
    bool isBaseUrl = true,
    bool isJsonEncode = true,
  });

  Future<dynamic> delete(
    String url,
    dynamic body, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isToken = true,
    bool isBaseUrl = true,
    bool isJsonEncode = true,
  });
}
