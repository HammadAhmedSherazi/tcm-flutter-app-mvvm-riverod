import 'dart:math';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../export_all.dart';

class AuthRepoProvider extends ChangeNotifier {
  ApiResponse _apiGoogleSignInResponse = ApiResponse.undertermined();
  ApiResponse _updateApiResponse = ApiResponse.undertermined();
  ApiResponse _logoutApiResponse = ApiResponse.undertermined();
  ApiResponse _bannerApiResponse = ApiResponse.undertermined();

  ApiResponse _apiAppleSignInResponse = ApiResponse.undertermined();

  AuthRemoteRepo authRemoteRepo = AuthRemoteRepo.authRemoteInstance;
  String? userEmail;
  UserDataModel? userData;
  ContactInfoDataModel? contactInfo;
  bool isNotification = false;
  bool isStaging =
      BaseApiServices.baseURL == "https://api-tcm.mmcgbl.dev/graphql";
  List<BannerDataModel> banners = [];
//   Future<void> signInWithApple() async {
  
//     final credential = await SignInWithApple.getAppleIDCredential(
//       scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ],
//     );

//     print('User ID: ${credential.userIdentifier}');
//     print('Email: ${credential.email}');
//     print('Name: ${credential.givenName} ${credential.familyName}');
//     print('Authorization Code: ${credential.authorizationCode}');
//     print('Identity Token: ${credential.identityToken}');

//     // Send this token to your server for further processing

// }

  Future signInWithGoogle() async {
    _apiGoogleSignInResponse = ApiResponse.loading();
    notifyListeners();
    await GoogleSignIn().signOut();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // if (tag == "Sign up") {

        final result = await authRemoteRepo.signinRepo(
          input: {
            "access_key": googleAuth.idToken ?? "",
            "account_type": "Google",
            "access_type": "App",
            "fcm_token": FirebaseService.fcmToken ?? ""
          },
          query: GraphQLQueries.signinQuery,
        );
        if (result != null) {
          Helper.showMessage("Sign in successfully");
          SharedPreferenceManager.sharedInstance
              .storeToken(result['data']['signIn']['access_token'] ?? "");
          SharedPreferenceManager.sharedInstance.storeRefreshToken(
              result['data']['signIn']['refresh_token'] ?? "");
          savedUserData(result['data']['signIn']['data']);

          AppRouter.pushAndRemoveUntil(const NavigationView());
          _apiGoogleSignInResponse = ApiResponse.completed(result);
        } else {
          _apiGoogleSignInResponse = ApiResponse.error();
        }
        notifyListeners();
      } else {
        _apiGoogleSignInResponse = ApiResponse.error();
        notifyListeners();
      }

      notifyListeners();
    } catch (e) {
      _apiGoogleSignInResponse = ApiResponse.error();
      notifyListeners();
    }
    // Trigger the authentication flow
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future appleSignIn() async {
    _apiAppleSignInResponse = ApiResponse.loading();
    notifyListeners();

    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      // final oauthCredential = OAuthProvider("apple.com").credential(
      //   idToken: appleCredential.identityToken,
      //   rawNonce: rawNonce,
      // );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final result = await authRemoteRepo.signinRepo(
        input: {
          "access_key": appleCredential.identityToken ?? "",
          "account_type": "Apple",
          "access_type": "App",
          "fcm_token": FirebaseService.fcmToken ?? ""
        },
        query: GraphQLQueries.signinQuery,
      );
      if (result != null) {
        Helper.showMessage("Sign in successfully");
        SharedPreferenceManager.sharedInstance
            .storeToken(result['data']['signIn']['access_token'] ?? "");
        SharedPreferenceManager.sharedInstance
            .storeRefreshToken(result['data']['signIn']['refresh_token'] ?? "");
        savedUserData(result['data']['signIn']['data']);

        AppRouter.pushAndRemoveUntil(const NavigationView());
        _apiAppleSignInResponse = ApiResponse.completed(result);
      } else {
        _apiAppleSignInResponse = ApiResponse.error();
      }
      notifyListeners();

      notifyListeners();
    } catch (e) {
      _apiAppleSignInResponse = ApiResponse.error();

      notifyListeners();
      Helper.showMessage("Something went wrong!");
    }
  }

  Future updateProfile(Map<String, dynamic> input, File? image) async {
    try {
      _updateApiResponse = ApiResponse.loading();
      notifyListeners();
      final result = await authRemoteRepo.updateProfileRepo(
          input: input, query: GraphQLQueries.updateProfileQuery, file: image);
      if (result != null) {
        Helper.showMessage(result['data']['updateProfile']['message'] ?? "");
        savedUserData(result['data']['updateProfile']['data']);

        _updateApiResponse = ApiResponse.completed(result);
      } else {
        isNotification = userData!.isNotification;
        _updateApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      isNotification = userData!.isNotification;
      _updateApiResponse = ApiResponse.error();
      notifyListeners();
    }
  }

  Future logout() async {
    try {
      _logoutApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await authRemoteRepo.logout(
          input: {"fcm_token": FirebaseService.fcmToken ?? ""},
          query: GraphQLQueries.logoutQuery);
      if (response != null) {
        SharedPreferenceManager.sharedInstance.clearAll();
        _logoutApiResponse = ApiResponse.completed(response);
        AppRouter.pushAndRemoveUntil(const LoginView());
      } else {
        _logoutApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _logoutApiResponse = ApiResponse.error();
      notifyListeners();
      throw Exception(e);
    }
  }

  Future getBanner() async {
    try {
      _bannerApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await authRemoteRepo.getBannerRepo(
          query: GraphQLQueries.allBannerQuery);
      if (response != null) {
        _bannerApiResponse = ApiResponse.completed(response);
        List temp = response['data']['getAllConfigurations']['banner'];
        banners = List.from(temp.map((e) => BannerDataModel.fromJson(e)));
      } else {
        _bannerApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      _bannerApiResponse = ApiResponse.error();
      notifyListeners();
      throw Exception(e);
    }
  }

  // Future signInWithFacebook(BuildContext context, String type) async {
  //   // Trigger the sign-in flow

  //   await FacebookAuth.instance.logOut();
  //   await FirebaseAuth.instance.signOut();
  //   try {
  //     // ignore: unnecessary_nullable_for_final_variable_declarations
  //     final LoginResult loginResult = await FacebookAuth.instance.login();

  //     // Create a credential from the access token

  //     if (loginResult.accessToken != null) {
  //       final OAuthCredential facebookAuthCredential =
  //           FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

  //       final UserCredential user = await FirebaseAuth.instance
  //           .signInWithCredential(facebookAuthCredential);

  //       appLog(user.toString());

  //       final String? token =
  //           await FirebaseAuth.instance.currentUser?.getIdToken();
  //       if (context.mounted) {
  //         appLog("$token");
  //         context.read<SocialSignInBloc>().add(
  //               SocialSignButtonPressed(
  //                   accessToken: token!,
  //                   type: type,
  //                   fcmToken: context.read<FCMTokenCubit>().state),
  //             );
  //       }
  //     } else {
  //       if (context.mounted) {
  //         context.read<SocialSignInBloc>().add(SocialSignRemoveLoading());
  //       }
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       context.read<SocialSignInBloc>().add(SocialSignRemoveLoading());
  //     }
  //     throw Exception(e);
  //   }
  // }

  void savedUserData(Map<String, dynamic> userMap) {
    String user = jsonEncode(userMap);
    SharedPreferenceManager.sharedInstance.storeUser(user);
    userSet();
  }

  void userSet() {
    Map<String, dynamic> userJson =
        jsonDecode(SharedPreferenceManager.sharedInstance.getUserData()!);

    userData = UserDataModel.fromJson(userJson);
    isNotification = userData?.isNotification ?? false;
    appLog("user data $userData");
  }

  void toggleNotification(bool isCheck) {
    isNotification = isCheck;
    notifyListeners();
  }

  void toggleStaging(bool isCheck) {
    SharedPreferenceManager.instance.clear();
    isStaging = !isStaging;
    if (isStaging) {
      BaseApiServices.baseURL = "https://api-tcm.mmcgbl.dev/graphql";
      BaseApiServices.imageURL = "https://api-tcm.mmcgbl.dev";
    } else {
      BaseApiServices.baseURL = "http://192.168.200.2:4001/graphql";
      BaseApiServices.imageURL = "http://192.168.200.2:4001";
    }

    notifyListeners();
  }

  void responseSet() {
    _apiGoogleSignInResponse = ApiResponse.undertermined();
    _apiAppleSignInResponse = ApiResponse.undertermined();
    _updateApiResponse = ApiResponse.undertermined();
    _logoutApiResponse = ApiResponse.undertermined();
    // _apiPrivacyPolicyResponse = ApiResponse.undertermined();
    notifyListeners();
  }

  void setContactInfo(String name, String phone){
    contactInfo = ContactInfoDataModel(username: name, phoneNo: phone);
    notifyListeners();
  }

  void unSetContactInfo(){
    contactInfo = null;
    notifyListeners();
  }

  ApiResponse get apiGoogleSignInResponse => _apiGoogleSignInResponse;
  ApiResponse get updateApiResponse => _updateApiResponse;
  ApiResponse get apiAppleSignInResponse => _apiAppleSignInResponse;
  ApiResponse get logoutApiResponse => _logoutApiResponse;
  ApiResponse get bannerApiResponse => _bannerApiResponse;
  // ApiResponse get apiPrivacyPolicyResponse => _apiPrivacyPolicyResponse;
}

final authRepoProvider =
    ChangeNotifierProvider.autoDispose<AuthRepoProvider>((ref) {
      ref.keepAlive();
      return AuthRepoProvider();
    });


