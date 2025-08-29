import '../export_all.dart';

class TopVenderDataModel {
  late final String title;
  late final String image;
  late final int id;

  late final List<DeliveryOptionDataModel>? deliveryOptions;

  TopVenderDataModel({
    required this.title,
    required this.image,
    required this.id,
    this.deliveryOptions,
 

  });

  factory TopVenderDataModel.fromJson(Map<String, dynamic> json) {
    return TopVenderDataModel(
      title: json['name'] ?? '',
      image: "${BaseApiServices.imageURL}${json['logo']}" ,
      id: json['id'] ,
      deliveryOptions: json['delivery_options'] != null ? List.from((json['delivery_options'] as List).map((e)=>DeliveryOptionDataModel.fromJson(e))): null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'logo': image,
      'id': id,
    };
  }
}

class DeliveryOptionDataModel {
  late final String type;
  late final num price;
  late final String description;
  late String selectType;

  DeliveryOptionDataModel({
    required this.type,
    required this.price,
    required this.description,
 
  });

  factory DeliveryOptionDataModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOptionDataModel(
      type: json['type'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'price': price,
      'description': description,
    };
  }
}
