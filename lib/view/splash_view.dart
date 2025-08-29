import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:tcm/data/network/base_api_services.dart';
import 'package:tcm/utils/app_router.dart';
import 'package:tcm/view/navigation_view.dart';
import 'package:tcm/view/onboarding_view.dart';
import '../providers/auth_repo_provider.dart';
import '../services/firebase_service.dart';
import '../services/shared_preferences.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewConsumerState();
}

class _SplashViewConsumerState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    initializeAppFlow();
  }
  Future<void> initializeAppFlow() async {
  await Future.delayed(const Duration(seconds: 3));

  await FirebaseService.firebaseTokenInitial();

  final url = SharedPreferenceManager.sharedInstance.getUrl();
  final token = SharedPreferenceManager.sharedInstance.getToken();
  final userData = SharedPreferenceManager.sharedInstance.getUserData();
  

  if (url != null) {
    BaseApiServices.baseURL = url;
    BaseApiServices.imageURL =  url.replaceAll('/graphql', '');
  }

  if (token != null && userData != null) {
    ref.read(authRepoProvider).userSet();
    AppRouter.pushAndRemoveUntil(const NavigationView());
  } else {
    if (token != null) {
      SharedPreferenceManager.sharedInstance.clearToken();
    }
    AppRouter.pushReplacement(const OnboardingView());
  }
}

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      "assets/lottie/splash_lottie_json.json",
      repeat: false,
    );
  }
}
