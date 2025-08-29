import '../export_all.dart';

class UserDataModel {
  final String fname;
  final String email;
  final String lname;
  final String gender;
  final String picture;
  final String accountType;
  final String userName;
  final String phoneNo;
  final int id;
  final bool isActive;
  final bool isNotification;

  // Constructor with default values
  UserDataModel({
    this.fname = '',
    this.email = '',
    this.lname = '',
    this.gender = '',
    this.picture = '',
    this.accountType = '',
    required this.id ,
    this.isActive = false,
    this.userName = "",
    this.phoneNo = "",
    this.isNotification = false,
  });

  // Factory constructor to create an instance from JSON
  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      fname: json['first_name']  ?? '',
      email: json['email']  ?? '',
      lname: json['last_name']  ?? '',
      gender: json['gender']  ?? '',
      picture: json['picture'] != null && (json['picture'] as String).contains('http') ?json['picture'] : "${BaseApiServices.imageURL}${json['picture']}",
      accountType: json['account_type']  ?? '',
      id: json['id'],
      isActive: json['is_active']  ?? false,
      isNotification: json['is_notification']  ?? false,
      userName: "${json['first_name'] ?? ""} ${json['last_name'] ?? ""}",
      phoneNo: json['phone'] ?? ""
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': fname,
      'email': email,
      'last_name': lname,
      'gender': gender,
      'picture': picture,
      'account_type': accountType,
      'id': id,
      'is_active': isActive,
      'is_notification': isNotification,
      'phone' : phoneNo
    };
  }
}
class ContactInfoDataModel {
  late final String username;
  late final String phoneNo;

  ContactInfoDataModel({required this.username, required this.phoneNo});

  factory ContactInfoDataModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoDataModel(
      username: json['full_name'] ?? '',
      phoneNo: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': username,
      'phone': phoneNo,
    };
  }
}
