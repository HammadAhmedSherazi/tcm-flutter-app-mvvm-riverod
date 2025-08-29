
import 'dart:math';
import 'package:http/http.dart' as http;
import '../export_all.dart';

class NotificationService{
   NotificationService._();
  static final  NotificationService _singleton =  NotificationService._();
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static  NotificationService get notificationInstance => _singleton;
 static  Future<void> initLocalNotification(
       RemoteMessage message) async {
    AndroidInitializationSettings androidInitialization =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings darwinInitialization =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: darwinInitialization,
    );
   
    showNotitfication(message);

    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {},
    );
  }

 static Future<void> showNotitfication(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "High Importance Notification",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            importance: Importance.high,
            channelDescription: "My channel description",
            priority: Priority.high,
            ticker: "ticker");
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(
        iOS: darwinNotificationDetails, android: androidNotificationDetails);
    Future.delayed(
        Duration.zero,
        () => _flutterLocalNotificationsPlugin.show(
          
            0,
            message.notification?.title.toString(),
            message.notification?.body.toString(),
            notificationDetails));
  }
    //FUNCTION TO INITIALIZE NOTIFICATION
  static Future<void> initNotifications(WidgetRef ref) async {

    
    
    //reuest permission from user (will prompt user)
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
    FirebaseMessaging.onMessage.listen((noti) {
      if(noti.data['type'] != "chat_message"){
        handleBackgroundMessage(noti);
      }
      
      // ref.read(notificationAlertProvider.notifier).toggleNotification(true); 
    });

   
  }
  // ✅ Download and Save Image Locally
  static Future<String?> _downloadAndSaveImage(String url, String fileName) async {
    try {
      final Directory directory = await  getTemporaryDirectory();
      final String filePath = '${directory.path}/$fileName';

      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    NotificationService.initLocalNotification(message);
    }
    static Future<void> showNotificationWithImage(String imageUrl, RemoteMessage message) async {
    final String? filePath = await _downloadAndSaveImage(imageUrl, "notification_image.jpg");

    BigPictureStyleInformation? bigPictureStyle;
    AndroidNotificationDetails androidNotificationDetails;

    if (filePath != null) {
      bigPictureStyle = BigPictureStyleInformation(
        FilePathAndroidBitmap(filePath), // Large Image in Notification
        largeIcon: FilePathAndroidBitmap(filePath), // Small Thumbnail
      );
    }

    androidNotificationDetails = AndroidNotificationDetails(
      "high_importance_channel",
      "High Importance Notifications",
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyle, // Attach Image Style
      ticker: "New Photo Received",
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
            0,
            message.notification?.title.toString(),
             "Tap to view the image",
            notificationDetails);
  }


  
   
}