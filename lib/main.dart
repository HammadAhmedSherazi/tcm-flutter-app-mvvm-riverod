import 'package:flutter_stripe/flutter_stripe.dart';

import 'export_all.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Stripe.publishableKey =
  //     '';
  await Future.wait([
    SharedPreferenceManager.init(),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    ScreenUtil.ensureScreenSize(),
    Stripe.instance.applySettings(),
  ]);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 947),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, _) {
        return Consumer(
          builder: (context, ref, _) {
            final languageNotifier = ref.watch(languageChangeNotifierProvider);
            final languageCode = languageNotifier.currentLanguage.code;
            final isRtl = languageCode == 'ar';

            return MaterialApp(
              title: 'TCM',
              debugShowCheckedModeBanner: false,
              navigatorKey: AppRouter.navKey,
              theme: AppTheme.lightTheme,
              
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: Directionality(
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    child: child!,
                  ),
                );
              },
              home: const SplashView(),
            );
          },
        );
      },
    );
  }
}
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
