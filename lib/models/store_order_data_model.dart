import '../export_all.dart';


class StoreOrderDataModel {
  late  String shippingType;
  late final int storeId;
  late final List<StoreProductDetailDataModel>? product;
  late final List<OrderItemDataModel> orderItems;

  StoreOrderDataModel({
    required this.shippingType,
    required this.storeId,
    required this.orderItems,
     this.product
  });

  factory StoreOrderDataModel.fromJson(Map<String, dynamic> json) {
    return StoreOrderDataModel(
      shippingType: json['shipping_type'] ?? '',
      storeId: json['store_id'],
      orderItems: (json['order_items'] as List<dynamic>)
          .map((e) => OrderItemDataModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipping_type': shippingType,
      'store_id': storeId,
      'cart_items': orderItems.map((e) => e.cartId).toList(),
    };
  }
}

class OrderItemDataModel {
  late final int? cartId;
  late final int productId;
  late final int quantity;

  OrderItemDataModel({
    this.cartId,
    required this.productId,
    required this.quantity,
  });

  factory OrderItemDataModel.fromJson(Map<String, dynamic> json) {
    return OrderItemDataModel(
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,

    };
  }
}
class OrderDataModel {

  late final int id;
  late final String orderNo;
  
  late final ContactInfoDataModel contactInfo;
  late final List<StoreDataModel> stores;
  late final LocationData shippingAddress;
  late final num totalAmount;

  OrderDataModel({
    
    required this.id,
    required this.orderNo,

    required this.stores,
    required this.shippingAddress,
    required this.totalAmount,
    required this.contactInfo
  });

  factory OrderDataModel.fromJson(Map<String, dynamic> json) {
    return OrderDataModel(
      id: json['id'],
      orderNo: json['order_no'],
     
      contactInfo: ContactInfoDataModel.fromJson(json['contact_information']),
      
     
      stores: (json['store_orders'] as List<dynamic>)
          .map((e) => StoreDataModel.fromJson(e))
          .toList(),
      shippingAddress: LocationData.fromJson(json['shipping_address']),
      totalAmount: json['total_amount'] ?? 0,
    );
  }
}

class StoreDataModel {
  late final int id;
  late final TopVenderDataModel store;
  late final List<OrderProductDataModel> orderItems;
  late final String status;
  late final String shippingType;
  late final num shippingCost;

  StoreDataModel({
    required this.id,
    required this.store,
    required this.orderItems,
    required this.status,
    required this.shippingCost,
    required this.shippingType
  });

  factory StoreDataModel.fromJson(Map<String, dynamic> json) {
    return StoreDataModel(
      id: json['id'],
      store: TopVenderDataModel.fromJson(json['store']),
      shippingCost: json['shipping_cost'] ?? 0.0,
      shippingType: json['shipping_type'] ?? "",
      orderItems: (json['order_items'] as List<dynamic>)
          .map((e) => OrderProductDataModel.fromJson(e))
          .toList(),
      status: json['status'] ?? '',
    );
  }
}


class OrderProductDataModel {
  late final String title;
  late final int quantity;
  late final num totalAmount;
  late final num price;
  late final num discountPrice;
  late final String image;
  late final int id;
  late final int productId;
  late final bool isRefunded;


  OrderProductDataModel({
    required this.title,
    required this.quantity,
    required this.totalAmount,
    required this.price,
    required this.discountPrice,
    required this.image,
    required this.id,
    required this.productId,
    required this.isRefunded,

  });

  factory OrderProductDataModel.fromJson(Map<String, dynamic> json) {
    return OrderProductDataModel(
      id: json['id'],

      productId: json['product']['id'],
      title: json['product']['title'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalAmount: json['total_price'] ?? 0,
      price: json['price'] ?? 0,
      discountPrice: json['discount_price'] ?? 0,
      image: "${BaseApiServices.imageURL}${json['product']['thumbnail_image']}",
      isRefunded: json['is_refunded'] ?? false,
    );
  }
}
