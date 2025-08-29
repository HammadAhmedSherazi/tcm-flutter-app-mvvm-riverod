// import '../data/enums/api_path.dart';
// import '../data/network/api_endpoints.dart';
// import '../data/network/http_client.dart';
// import '../utils/app_logger.dart';

// class NotificationRemoteSource {
//   Future getNotification(int limit, int nextOffset) async {}
// }

// class NotificationRemoteRepo extends NotificationRemoteSource {
//   @override
//   Future getNotification(int limit, int nextOffset) async {
//     try {
//       final response = await HttpClient.instance.get(
//           "${ApiEndpoints.getValue(APIPath.notifications)}?limit=$limit&offset=$nextOffset",
//           isToken: true);
//       appLog("Response - $response");
//       return response;
//     } catch (e) {
//       return null;
//     }
//   }
// }
