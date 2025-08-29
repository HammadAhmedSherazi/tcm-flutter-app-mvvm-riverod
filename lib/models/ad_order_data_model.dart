import '../export_all.dart';
class AdOrderDataModel {
  late final String adOrderNo;
  late final int id;
  late final ProductDetailDataModel product;
  late final num totalAmount;
  late final String status;
  late final ContactInfoDataModel contactInfo;

  AdOrderDataModel({
    required this.adOrderNo,
    required this.id,
    required this.product,
    required this.totalAmount,
    required this.status,
    required this.contactInfo,
  });

  factory AdOrderDataModel.fromJson(Map<String, dynamic> json) {
    return AdOrderDataModel(
      adOrderNo: json['ads_no'] ?? '',
      id: json['id'] ?? 0,
      product: ProductDetailDataModel.fromJson(json['ad'],false),
      totalAmount: json['total_amount'] ?? 0,
      status: json['status'] ?? '',
      contactInfo: ContactInfoDataModel.fromJson(json['contact_information'] ?? {}),
    );
  }
}
