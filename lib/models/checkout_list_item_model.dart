import '../export_all.dart';

class CheckoutListItemModel {
  late final StoreProductDetailDataModel product;

  late int quantity;
  late int totalItem;
  late final int id;
  late bool isSelect;

  CheckoutListItemModel.from(Map<String, dynamic> json) {
    id = json['id'];
    product = StoreProductDetailDataModel.fromJson(json['product']);

    quantity = json['quantity'] ?? 1;
    totalItem = json['total_items'] ?? 0;
    isSelect = false;
  }
}