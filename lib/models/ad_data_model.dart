import '../export_all.dart';
class AdDataModel {
  late List<CategoryDataModel> category;
  late LocationData location;
  late double radius;
  late int id;

  AdDataModel({
    required this.category,
    required this.location,
    required this.radius,
    required this.id
  });

  factory AdDataModel.fromJson(Map<String, dynamic> json){
    return AdDataModel(
      category:json['categories'] != null && (json['categories'] as List).isNotEmpty ? List.from(json['categories'].map((e)=>CategoryDataModel.fromJson(e, true))): [],
      location: LocationData.fromJson(json),
      radius: double.parse("${json['radius']}"),
      id:   json['id']

    );
  }
}