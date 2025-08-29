import 'package:intl/intl.dart';

import '../export_all.dart';

class NotificationDataModel {
  final bool isNew;
  final DateTime createdAt;
  final String title;
  final Map<String, dynamic>? data;

  // Normal Constructor
  NotificationDataModel({
    required this.title,
    required this.createdAt,
    this.isNew = false,
    this.data
  });

  // Factory Constructor for JSON Parsing
  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      title: json['sub_title'] ?? '',
      isNew: Helper.isSameDay(json['created_at']),
      createdAt:  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .parse(json['created_at']).toLocal(),
      data: json['data']

    );
  }

  // Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
     
      'isNew': isNew,
    };
  }
}
