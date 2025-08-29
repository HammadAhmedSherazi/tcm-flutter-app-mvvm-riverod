import '../export_all.dart';

class ChatListDataModel {
  late final ProductDetailDataModel? product;
  late final UserDataModel? user;
  late final String lastmessagetext;
  late final bool? isMedia;
  late final int id;
  late final bool? isMyProduct;
  late final bool? isRead;

  ChatListDataModel(
      {this.product,
      this.user,
      this.isMedia = false,
      required this.id,
      required this.lastmessagetext,
      this.isMyProduct = false,
      this.isRead = false
      });

  factory ChatListDataModel.from(Map<String, dynamic> json, int userId) {
    return ChatListDataModel(
        id: json['id'] ?? -1,
        lastmessagetext: json["last_message"]["message"] ?? "",
        isMedia: json["last_message"]["is_media"] ?? false,
        product: ProductDetailDataModel.fromJson(json["ad"], false),
        isMyProduct: json['sender_id'] != userId ,
        isRead: json["last_message"]['is_read'] ?? false ,
        user:  json['sender_id'] == userId
            ? UserDataModel.fromJson(json['Receiver'])
            : UserDataModel.fromJson(json['Sender']));
  }
}
