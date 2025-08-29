import '../export_all.dart';

class AdReviewDataModel{
  final List<String> images;
  final List<String> buyingReceipts;
  final String status;
  final int id;
  final String title;
  final String description;
  final double price;
  final String condition;
  final int unit;
  final DateTime checkIn;
  final DateTime checkOut;
  final LocationModel location;
  final int userId;
  final int categoryId;
  final DateTime updatedAt;
  final DateTime createdAt;

  AdReviewDataModel({
    this.images = const [],
    this.buyingReceipts = const [],
    this.status = "Inactive",
    this.id = 0,
    this.title = "Untitled",
    this.description = "",
    this.price = 0.0,
    this.condition = "Unknown",
    this.unit = 1,
    DateTime? checkIn,
    DateTime? checkOut,
    LocationModel? location,
    this.userId = 0,
    this.categoryId = 0,
    DateTime? updatedAt,
    DateTime? createdAt,
  })  : checkIn = checkIn ?? DateTime.now(),
        checkOut = checkOut ?? DateTime.now(),
        location = location ?? LocationModel(),
        updatedAt = updatedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  factory AdReviewDataModel.fromJson(Map<String, dynamic> json) {
    return AdReviewDataModel(
      images: List<String>.from(json['images'].map((e)=> !(e as String ).contains(BaseApiServices.imageURL)?"${BaseApiServices.imageURL}$e" : e)),
      buyingReceipts: List<String>.from(json['buying_receipts'].map((e)=> !(e as String ).contains(BaseApiServices.imageURL)?"${BaseApiServices.imageURL}$e" : e)),
      status: json['status'] as String? ?? "Inactive",
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? "Untitled",
      description: Helper.convertToHtml(json['description'])  ,
      price: double.tryParse(json['price']?.toString() ?? "0.0") ?? 0.0,
      condition: json['condition'] as String? ?? "Unknown",
      unit: json['unit'] as int? ?? 1,
      checkIn: DateTime.tryParse(json['check_in'] ?? "") ?? DateTime.now(),
      checkOut: DateTime.tryParse(json['check_out'] ?? "") ?? DateTime.now(),
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : LocationModel(),
      userId: json['user_id'] as int? ?? 0,
      categoryId: json['category_id'] as int? ?? 0,
      updatedAt:
          DateTime.tryParse(json['updatedAt'] ?? "") ?? DateTime.now(),
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'images': images,
      'buying_receipts': buyingReceipts,
      'status': status,
      'id': id,
      'title': title,
      'description': description,
      'price': price.toString(),
      'condition': condition,
      'unit': unit,
      'check_in': checkIn.toIso8601String(),
      'check_out': checkOut.toIso8601String(),
      'location': location.toJson(),
      'user_id': userId,
      'category_id': categoryId,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class LocationModel {
  final String addressLine;
  final double lat;
  final double lon;
  final String city;
  final String state;
  final String country;

  LocationModel({
    this.addressLine = "",
    this.lat = 0.0,
    this.lon = 0.0,
    this.city = "",
    this.state = "",
    this.country = "",
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      addressLine: json['address_line'] as String? ?? "",
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      city: json['city'] as String? ?? "",
      state: json['state'] as String? ?? "",
      country: json['country'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_line': addressLine,
      'lat': lat,
      'lon': lon,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}
