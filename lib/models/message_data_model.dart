class MessageDataModel {
  late final int id;
  late final String message;
  late final String time;
  late final bool isDelivered;
  late final bool isSender;
  late final bool isMedia;
  late final List<String>? mediaUrls;
  late final bool isFailed;
  late final String? messageId;

  MessageDataModel(
      {required this.message,
      required this.time,
      required this.id,
      this.isDelivered = false,
      required this.isSender,
      this.isMedia = false,
      this.mediaUrls = const [],
      this.isFailed = false,
      this.messageId
      });
  factory MessageDataModel.fromJson(Map<String, dynamic> json, int id, bool isDelivered) {
    return MessageDataModel(
        id: json['id'],
        message: json['message'] ?? "",
        time: json['created_at'] ?? "",
        isSender: json['sender_id'] != null ? json['sender_id'] == id : false,
        isMedia: json['is_media'] ?? false,
        isDelivered: isDelivered,
        messageId: json['message_id'] ?? "",
        
        );
  }
}
