import '../export_all.dart';

class ProductDataModel {
  late final int? id;
  late final String? productName;
  late final String? productImage;
  late final double? productPrice;
  late final int? categoryId;
  late final String? status;
  late final String? checkIn;
  late final String? checkOut;
  late final bool isStoreProduct;
  int? quantity;

  ProductDataModel(
      {required this.id,
      required this.productName,
      required this.productImage,
      required this.productPrice,
      required this.categoryId,
      required this.status,
      this.quantity,
      this.isStoreProduct = false,
      this.checkIn,
      this.checkOut});
  factory ProductDataModel.fromJson(
      Map<String, dynamic> json, bool isStoreProduct) {
    return ProductDataModel(
        id: json['id'] as int? ?? 1,
        productName: json['title'] as String? ?? 'Unknown Product',
        productImage: isStoreProduct
            ? "${BaseApiServices.imageURL}${json['thumbnail_image'] ?? ""}"
            : json['images'] != null &&
                    (json['images'] as List<dynamic>?)!.isNotEmpty
                ? "${BaseApiServices.imageURL}${json['images'][0]}"
                : "",
        productPrice: json['price'] != null
            ? double.tryParse(json['price'].toString())
            : 0.0,
        categoryId: json['category_id'] ?? -1,
        status: json['status'] ?? "",
        isStoreProduct: isStoreProduct,
        checkIn: json['check_in'] as String? ?? "",
        checkOut: json['check_out'] as String? ?? "",
        quantity: json['quantity']);
  }
}

class ProductDetailDataModel extends ProductDataModel {
  late final bool? isFavourite;
  late final List<String>? productSampleImages;
  late final String? productDescription;
  late final List<String>? keyFeatures;
  late final UserDataModel? productOwner;
  late final LocationData? locationData;
  late final String? brand;
  late final String? condition;

  late final List<String>? buyingReceipt;
  late final int? chatId;
  late final double? applicationFee;
  late final CategoryDataModel? category;

  ProductDetailDataModel(
      {this.isFavourite = false,
      this.productSampleImages,
      this.productDescription,
      this.keyFeatures,
      this.productOwner,
      this.locationData,
      this.condition,
      this.category,
      this.buyingReceipt,
      this.brand = "",
      this.chatId,
      required super.productName,
      required super.productImage,
      required super.productPrice,
      required super.categoryId,
      required super.id,
      required super.status,
      required super.checkIn,
      required super.checkOut,
      required super.quantity,
      this.applicationFee});

  // fromJson method to parse JSON into a ProductDataModel object
  factory ProductDetailDataModel.fromJson(
      Map<String, dynamic> json, bool isStoreProduct) {
    return ProductDetailDataModel(
        id: json['id'] as int? ?? 1, // Default value for id
        productName: json['title'] as String? ?? 'Unknown Product',
        productImage: isStoreProduct
            ? "${BaseApiServices.imageURL}${json['thumbnail_image'] ?? ""}"
            : json['images'] != null &&
                    (json['images'] as List<dynamic>?)!.isNotEmpty
                ? !(json['images'][0] as String).contains(BaseApiServices.imageURL)? "${BaseApiServices.imageURL}${json['images'][0]}": "${json['images'][0]}"
                : "",
        productPrice: json['price'] != null
            ? double.tryParse(json['price'].toString())
            : 0.0,
        isFavourite: json['wishlists'] ?? false,
        productSampleImages: (json['images'] as List<dynamic>?)
                ?.map((e) => !(e as String).contains(BaseApiServices.imageURL)? "${BaseApiServices.imageURL}$e": e)
                .toList() ??
            [],
        productDescription: Helper.convertHtmlToFormat(json['description']),
        keyFeatures: (json['keyFeatures'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        productOwner:
            json['user'] != null ? UserDataModel.fromJson(json['user']) : null,
        locationData: LocationData.fromJson(json['location'] ?? {}),
        quantity:
            isStoreProduct ? json['quantity'] ?? 1 : json['unit'] as int? ?? 1,
        category: json['category'] != null
            ? CategoryDataModel.fromJson(json['category'], false)
            : null,
        condition: json['condition'] as String? ?? "",
        buyingReceipt: json['buying_receipts'] != null
            ? (json['buying_receipts'] as List<dynamic>?)
                ?.map((e) => "${BaseApiServices.imageURL}$e")
                .toList()
            : [],
        categoryId: json['category_id'] ?? -1,
        status: json['status'] ?? "",
        brand: json['brands'] ?? "Unknown",
        chatId: json['ads_chats'] != null ? json['ads_chats']['id'] : null,
        checkIn: json['check_in'] as String? ?? "",
        checkOut: json['check_out'] as String? ?? "",
        applicationFee: calculateApplicationFee(
            json, double.tryParse(json['price'].toString()) ?? 0.0));
  }
}

class StoreProductDetailDataModel extends ProductDataModel {
  late final List<String>? productSampleImages;
  late final String? productDescription;
  late final CategoryDataModel? category;
  late final TopVenderDataModel storeData;
  late final List<String>? keyFeatures;
  late final num discountValue;
  late final int totalReviews;
  late final num averageRating;
  late final bool ? isAvaliable;
  late final bool ? isStock;

  StoreProductDetailDataModel({
    required super.id,
    required super.productName,
    required super.productImage,
    required super.productPrice,
    required super.categoryId,
    required super.status,
    required super.quantity,
    required super.isStoreProduct,
    this.productSampleImages,
    this.productDescription,
    this.category,
    this.isAvaliable,
    this.isStock,
    required this.storeData,
    this.keyFeatures,
    required this.discountValue,
    required this.totalReviews,
    required this.averageRating,
  });

  factory StoreProductDetailDataModel.fromJson(Map<String, dynamic> json) {
    return StoreProductDetailDataModel(
      id: json['id'],
      productName: json['title'],
      productImage: "${BaseApiServices.imageURL}${json['thumbnail_image'] ?? ""}",
      productPrice: json['price'] != null
          ? double.tryParse(json['price'].toString())! - calculateDiscountValue(
          json['off_type'], json['price'], json['discount_value'])
          : 0.0,
      categoryId: -1,
      status: "Active",
      quantity: json['quantity'],
      productSampleImages: (json['images'] as List<dynamic>?)
              ?.map((e) => "${BaseApiServices.imageURL}$e")
              .toList() ??
          [],
      productDescription: Helper.convertHtmlToFormat(json['description']),
      keyFeatures: (json['keyFeatures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      category: json['category'] != null
          ? CategoryDataModel.fromJson(json['category'], false)
          : null,
      storeData: TopVenderDataModel.fromJson(json['store']),
      isStoreProduct: true,
      
      discountValue: calculateDiscountValue(
          json['off_type'], json['price'], json['discount_value']),
      totalReviews: json['total_reviews'] ?? 0,
      averageRating: json['average_rating'] ?? 0,
      isAvaliable: json['is_available'] ?? true,
      isStock: json['is_stock'] ?? true
    );
  }
}

double calculateApplicationFee(Map<String, dynamic> json, double price) {
  if (json['application_fee'] == null) return 0.0;

  String? type = json['application_fee']['type'];
  double value = double.parse("${json['application_fee']['value'] ?? 0.0}");

  if (type == "fixed") {
    return value; // Return fixed fee
  } else if (type == "percentage") {
    return (price * value) / 100; // Calculate percentage fee
  }

  return 0.0; // Default fallback
}

num calculateDiscountValue(String? type, num price, num value) {
  if (type == null) return 0.0;

  if (type.toLowerCase() == "fixed") {
    return value; // Return fixed fee
  } else if (type.toLowerCase() == "percentage") {
    return (price * value) / 100; // Calculate percentage fee
  }

  return 0.0; // Default fallback
}
