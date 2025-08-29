import '../export_all.dart';

class MarketPlaceDataModel {
  final Map<String, List<ProductDataModel>>? mapData;

  MarketPlaceDataModel({required this.mapData});

  // Factory method to parse JSON response
  factory MarketPlaceDataModel.fromJson(Map<String, dynamic> json, bool isStore) {
    return MarketPlaceDataModel(
      mapData: json.map((key, value) {
        return MapEntry(key, (value as List).map((e) => ProductDataModel.fromJson(e, isStore)).toList());
      }),
    );
  }

  // Convert model back to JSON
  Map<String, dynamic> toJson() {
    return mapData!.map((key, value) => MapEntry(key, value));
  }
}