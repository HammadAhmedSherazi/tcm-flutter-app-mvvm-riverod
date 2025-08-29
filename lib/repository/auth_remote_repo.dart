import '../data/network/http_client.dart';
import '../export_all.dart';

abstract class AuthRemoteRepoSource {
  Future signinRepo(
      {required Map<String, String> input, required String query}) async {}
  Future deleteProfileRepo() async {}
  Future contactSupport(String message) async {}
  Future getBannerRepo({required String query}) async {}
  Future updateProfileRepo(
      {required Map<String, dynamic> input,
      required String query,
      File? file}) async {}
  Future logout(
      {required Map<String, String> input, required String query}) async {}
  Future updateToken(
      {required Map<String, String> input, required String query}) async {
    return null;
  }
}

class AuthRemoteRepo extends AuthRemoteRepoSource {
  AuthRemoteRepo._();

  static final AuthRemoteRepo _singleton = AuthRemoteRepo._();

  static AuthRemoteRepo get authRemoteInstance => _singleton;

  @override
  Future signinRepo(
      {required Map<String, String> input, required String query}) {
    try {
      final response = HttpClient.instance.post(
        {
          'query': query,
          'variables': {
            'input': input,
          },
        },
        isToken: false,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future updateProfileRepo(
      {required Map<String, dynamic> input,
      required String query,
      File? file}) {
    try {
      final response = file != null
          ? HttpClient.instance.post({
              'query': query,
              'variables': {
                'input': input,
              },
              'files': file
            }, isMultipartRequest: true,variableName: "variables.input.picture")
          : HttpClient.instance.post(
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
  Future logout({required Map<String, dynamic> input, required String query}) {
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
  Future updateToken(
      {required Map<String, String> input, required String query}) async {
    try {
      final response = await HttpClient.instance.post(
        {
          'query': query,
          'variables': input,
        },
      );
      if (response['data']['refresh'] != null &&
          response['data']['refresh']['statusCode'] == 200) {
        SharedPreferenceManager.sharedInstance
            .storeToken(response['data']['refresh']['access_token'] ?? "");
        SharedPreferenceManager.sharedInstance.storeRefreshToken(
            response['data']['refresh']!['refresh_token'] ?? "");
      }
    } catch (e) {
      SharedPreferenceManager.sharedInstance.clearAll();
      AppRouter.pushAndRemoveUntil(const LoginView());
      throw Exception(e);
    }
  }

  @override
  Future getBannerRepo({required String query}) async {
    try {
      final response = HttpClient.instance.post(
        {
          'query': query,
          'variables': {
            "type": ["banner"]
          },
        },
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
