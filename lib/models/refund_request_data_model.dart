import '../export_all.dart';

class RefundRequestDataModel {
  final String status;
  final int orderItemId;
  final List<String> images;
  final Product product;
  final String reason;
  final String reasonCode;
  final num refundAmount;

  RefundRequestDataModel({
    required this.status,
    required this.orderItemId,
    required this.images,
    required this.product,
    required this.reason,
    required this.reasonCode,
    required this.refundAmount,
  });

  factory RefundRequestDataModel.fromJson(Map<String, dynamic> json) {
    return RefundRequestDataModel(
      status: json['status'] ?? '',
      orderItemId: json['order_item_id'] ?? 0,
      images: (json['images'] as List<dynamic>?)
                ?.map((e) => "${BaseApiServices.imageURL}$e")
                .toList() ??
            [],
      product: Product.fromJson(json['product']),
      reason: json['reason'] ?? '',
      reasonCode: json['reason_code'] ?? '',
      refundAmount: json['refund_amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'order_item_id': orderItemId,
      'images': images,
      'product': product.toJson(),
      'reason': reason,
      'reason_code': reasonCode,
      'refund_amount': refundAmount,
    };
  }
}

class Product {
  final int id;
  final String title;
  final String thumbnailImage;
  final String description;


  Product({
    required this.id,
    required this.title,
    required this.thumbnailImage,
    required this.description,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      thumbnailImage: "${BaseApiServices.imageURL}${json['thumbnail_image'] ?? ""}",
      description: json['description'] ?? '',
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail_image': thumbnailImage,
      'description': description,
      
    };
  }
}
