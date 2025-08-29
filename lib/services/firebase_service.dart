import '../export_all.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService _singleton = FirebaseService._();

  static FirebaseService get firebaseInstance => _singleton;

  static late final String? fcmToken;

  //helper method to get token
  //CREATE AN INSTANCE OF FIREBASE MESSAGING
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static firebaseTokenInitial() async {
    fcmToken = await firebaseMessaging.getToken();
    appLog("Fcm Token - $fcmToken");
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    // fetch the FCM token for this device

    // firebaseMessaging.getInitialMessage();
    // firebaseMessaging.getNotificationSettings();
    // await FirebaseMessaging.instance.setAutoInitEnabled(true);

    //Message Listen from Firebase
    // FirebaseMessaging.onMessage.listen((noti) {
    //   handleBackgroundMessage(noti);

    //   // NotificationServices.showNotitfication(noti);
    // });
  }


   Future<void> handleBackgroundMessage(RemoteMessage message) async {
    NotificationService.handleBackgroundMessage(message);
  }
  Future<void> showNotificationWithImage(String imageUrl,RemoteMessage message) async {
    NotificationService.showNotificationWithImage(imageUrl, message);
  }
}
