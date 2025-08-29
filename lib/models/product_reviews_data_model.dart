import '../export_all.dart';

class ProductReviewsDataModel {
  late final int id;
  late final String review;
  late final double rating;
  late final UserDataModel? user;
  late final List<String> images;
  late final DateTime? createdAt;
  late final int? storeOrderId;
  late final String? reply;
  late final StoreProductDetailDataModel ? product;


  ProductReviewsDataModel({
    required this.id,
    required this.review,
    required this.rating,
    required this.user,
    this.product,
    this.createdAt, 
    this.storeOrderId,

    this.reply,
    this.images = const [],
  });

  factory ProductReviewsDataModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewsDataModel(
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      id: json['id'],
      review: json['review'] ?? "" * 10,
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      storeOrderId: json['store_order_id'],
      user: json['customer'] != null ? UserDataModel.fromJson(json['customer']) : null,
      product: json['product'] != null ? StoreProductDetailDataModel.fromJson(json['product']) : null,
      reply: json['store_reply'] ?? "",

      images: json['images'] != null ?
      (json['images'] as List<dynamic>?)
                ?.map((e) => "${BaseApiServices.imageURL}$e")
                .toList() ?? [] :[]
            // ['https://images.unsplash.com/photo-1505740420928-5e560c06d30e?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D','https://images.unsplash.com/photo-1505740420928-5e560c06d30e?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'review': review,
      'rating': rating,
      'customer': user?.toJson(),
    };
  }
}