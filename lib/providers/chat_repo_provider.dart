import 'dart:async';

import 'package:uuid/uuid.dart';

import '../export_all.dart';

class ChatRepoProvider extends ChangeNotifier {
  late final ChatRemoteRepo chatRepo;
  late final FirebaseService firebaseService;
  ChatRepoProvider({required this.chatRepo, required this.firebaseService});

  ApiResponse createChatApiResponse = ApiResponse.undertermined();
  ApiResponse deleteChatApiResponse = ApiResponse.undertermined();

  ApiResponse getChatApiResponse = ApiResponse.undertermined();
  ApiResponse getChatMessageApiResponse = ApiResponse.undertermined();
  ApiResponse getNotificationApiResponse = ApiResponse.undertermined();

  List<ChatListDataModel> chatList = [];
  List<MessageDataModel> messages = [];
  List<NotificationDataModel> notifications = [];

  StreamSubscription? _firebaseSubscription;
  UserDataModel? userData;
  // LinkedHashMap<String, MessageDataModel> messageMap = LinkedHashMap();

  String? chatListCursor, notificationCursor;
  String? messageListCursor;
  bool isChatOn = false;
  int chatCount = 0, notificationCount = 0;
  int? chatId;
  final uuid = const Uuid();

  Future createAdChat(
      {required String message,
      required int adId,
      required int? id,
      required File? file}) async {
    try {
      isChatOn = true;
      if (id != null) {
        chatId = id;
      }

      final messageId = uuid.v1();
      // messageMap.entries.elementAt(index)
      // messageMap[messageId] = MessageDataModel(
      //     id: -1,
      //     messageId: messageId,
      //     isSender: true,
      //     message: message,
      //     time: Helper.formatDateTime(DateTime.now()));

      // messages.insert(0, messageMap[messageId]!);
      final msg = MessageDataModel(
          id: -1,
          isSender: true,
          message: file == null ? message : file.path,
          messageId: messageId,
          isMedia: file != null,
          time: Helper.formatDateTime(DateTime.now().toUtc()));

      messages.insert(
        0,
        msg,
      );

      createChatApiResponse = ApiResponse.loading();
      notifyListeners();

      Map<String, dynamic> data = {
        "ads_id": adId,
        "chat_id": chatId,
        "message": message,
        "message_id": messageId
      };
      if (file != null) {
        data["media"] = null;
      }
      final response = await chatRepo.createChatRepo(input: data, file: file);
      if (response != null) {
        final data = response['data']['createAdsChat']['data'];
        chatId ??= data['chat_id'];
        createChatApiResponse = ApiResponse.completed(response);

        final index = messages.indexWhere(
          (element) => element.messageId == data['message_id'],
        );
        messages[index] = MessageDataModel.fromJson(data, userData!.id, true);
      } else {
        createChatApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      createChatApiResponse = ApiResponse.error();

      notifyListeners();
      throw Exception(e);
    }
  }

  void chatInit() {
    isChatOn = false;
    chatId = null;
    chatCount = 0;
    Map<String, dynamic> userJson =
        jsonDecode(SharedPreferenceManager.sharedInstance.getUserData()!);
    if (userData == null || userData!.id != userJson['id']) {
      userData = UserDataModel.fromJson(userJson);
    }
    // userData ??= UserDataModel.fromJson(userJson);
    appLog("Chat Intialized");

    _firebaseSubscription?.cancel();
    _firebaseSubscription = FirebaseMessaging.onMessage.listen((noti) {
      appLog("Message Listen");

      if (isChatOn) {
        chatCount = 0;
        if (noti.data['type'] == "chat_message") {
          final data = jsonDecode(noti.data['data']);
          if (chatId != null && chatId == data['chat_id']) {
            MessageDataModel msg =
                MessageDataModel.fromJson(data, userData!.id, true);
            // final int index =
            //     messages.indexWhere((e) => e.messageId == msg.messageId);
            // if (index < 0) {
            if(!msg.isSender){
              messages.insert(0, msg);
              notifyListeners();
            }
            
           
            // }
          }
        } else {
          notificationCount++;
          firebaseService.handleBackgroundMessage(noti);
        }
      } else {

           
        if (noti.data['type'] == "chat_message") {
          if(chatList.isNotEmpty){
            final data = jsonDecode(noti.data['data']);

            appLog("Chat Message ${data['message']}");
            MessageDataModel msg =
                MessageDataModel.fromJson(data, userData!.id, true);
            final int index = chatList.indexWhere((e) => e.id == data['chat_id']);
            
            if(index>-1){
              ChatListDataModel chat = chatList[index];
              chatList[index] = 
              ChatListDataModel(id: chat.id, lastmessagetext: msg.message,
              isRead: true,
              isMedia: msg.isMedia,isMyProduct: chat.isMyProduct, product: chat.product, user: chat.user
              );
              
              
              chatList.insert(0, chatList.removeAt(index));
              
            }
            if(msg.isMedia){
              firebaseService.showNotificationWithImage("${BaseApiServices.imageURL}${msg.message}", noti);
            }
            else{
              firebaseService.handleBackgroundMessage(noti);
            }
          }
          chatCount++;
        } else {
          firebaseService.handleBackgroundMessage(noti);
          notificationCount++;
        }
        notifyListeners();
      }
    });
  }

  Future getChatList(
      {required int limit,
      required String? cursor,
      required String? type}) async {
    try {
      chatId = null;
      chatCount = 0;
      isChatOn = false;
      if (cursor == null) {
        chatListCursor = cursor;
        getChatApiResponse = ApiResponse.loading();
        if (chatList.isNotEmpty) {
          chatList.clear();
        }
      } else {
        getChatApiResponse = ApiResponse.loadingMore();
      }
      notifyListeners();
      final response = await chatRepo.getChatListRepo(
          input: {"cursor": cursor, "limit": limit, "type": type ?? "All"});
      if (response != null) {
        List temp = response['data']['allAdsChats']['data'];
        chatListCursor = response['data']['allAdsChats']['nextCursor'];
        if (cursor == null) {
          chatList = List.from(
              temp.map((e) => ChatListDataModel.from(e, userData!.id)));
        } else {
          chatList.insertAll(
              0,
              List.from(
                  temp.map((e) => ChatListDataModel.from(e, userData!.id))));
        }
        getChatApiResponse = ApiResponse.completed(response);
        notifyListeners();
      } else {
        getChatApiResponse = ApiResponse.error();
        notifyListeners();
      }
    } catch (e) {
      getChatApiResponse = ApiResponse.error();
      notifyListeners();
      throw Exception(e);
    }
  }

  Future getMessageList(
      {required int limit, required String? cursor, required int id}) async {
    try {
      isChatOn = true;
      chatId = id;
      if (cursor == null) {
        messageListCursor = cursor;
        getChatMessageApiResponse = ApiResponse.loading();
        if (messages.isNotEmpty) {
          messages.clear();
        }
      } else {
        getChatMessageApiResponse = ApiResponse.loadingMore();
      }
      notifyListeners();
      final response = await chatRepo.getChatMessageListRepo(
          input: {"chat_id": id, "cursor": cursor, "limit": limit});
      if (response != null) {
        List temp = response['data']['allAdsMessages']['data'];
        Map<String, dynamic> userJson =
            jsonDecode(SharedPreferenceManager.sharedInstance.getUserData()!);

        final userData = UserDataModel.fromJson(userJson);
        chatListCursor = response['data']['allAdsMessages']['nextCursor'];
        if (cursor == null) {
          // temp.map((e)=>messageMap.addAll({e['message_id']:e}));
          // for (var e in temp) {
          //   messageMap["${e['id']}"] =
          //       MessageDataModel.fromJson(e, userData.id, true);
          // }

          messages = List.from(
              temp.map((e) => MessageDataModel.fromJson(e, userData.id, true)));
        } else {
          // for (var e in temp) {
          //   messageMap["${e['id']}"] =
          //       MessageDataModel.fromJson(e, userData.id, true);
          // }
          messages.addAll(List.from(temp
              .map((e) => MessageDataModel.fromJson(e, userData.id, true))));
        }
        getChatMessageApiResponse = ApiResponse.completed(response);
        notifyListeners();
      } else {
        getChatMessageApiResponse = ApiResponse.error();
        notifyListeners();
      }
    } catch (e) {
      getChatMessageApiResponse = ApiResponse.error();
      notifyListeners();
      throw Exception(e);
    }
  }

  Future deleteAdChatQuery({required int id}) async {
    try {
      deleteChatApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await chatRepo.deleteChatRepo(chatId: id);
      if (response != null) {
        AppRouter.back();
        AppRouter.back();

        deleteChatApiResponse = ApiResponse.completed(response);

        notifyListeners();
      } else {
        AppRouter.back();
        deleteChatApiResponse = ApiResponse.error();
        notifyListeners();
      }
    } catch (e) {
      AppRouter.back();
      deleteChatApiResponse = ApiResponse.error();
      notifyListeners();
      throw Exception(e);
    }
  }

  Future getNotifications({required int limit, required String? cursor}) async {
    try {
      notificationCount = 0;
      if (cursor == null) {
        notificationCursor = cursor;
        getNotificationApiResponse = ApiResponse.loading();
        if (messages.isNotEmpty) {
          messages.clear();
        }
      } else {
        getNotificationApiResponse = ApiResponse.loadingMore();
      }
      notifyListeners();
      final response = await chatRepo
          .getNotificaionsRepo(input: {"cursor": cursor, "limit": limit});
      if (response != null) {
        List temp = response['data']['allNotifications']['data'];

        notificationCursor = response['data']['allNotifications']['nextCursor'];
        if (cursor == null) {
          notifications =
              List.from(temp.map((e) => NotificationDataModel.fromJson(e)));
        } else {
          notifications.addAll(
              List.from(temp.map((e) => NotificationDataModel.fromJson(e))));
        }
        getNotificationApiResponse = ApiResponse.completed(response);
        notifyListeners();
      } else {
        getNotificationApiResponse = ApiResponse.error();
        notifyListeners();
      }
    } catch (e) {
      getNotificationApiResponse = ApiResponse.error();
      notifyListeners();
      throw Exception(e);
    }
  }

  void setResponse() {
    getChatMessageApiResponse = ApiResponse.undertermined();
    getNotificationApiResponse = ApiResponse.undertermined();
    deleteChatApiResponse = ApiResponse.undertermined();

    if (messages.isNotEmpty) {
      messages.clear();
    }
    isChatOn = false;
    chatId = null;
    notifyListeners();
  }

  void listenDispose() {
    _firebaseSubscription?.cancel();
    userData = null;
  }
}

final chatRepoProvider = ChangeNotifierProvider(
  (ref) => ChatRepoProvider(
      chatRepo: ChatRemoteRepo(),
      firebaseService: FirebaseService.firebaseInstance),
);
