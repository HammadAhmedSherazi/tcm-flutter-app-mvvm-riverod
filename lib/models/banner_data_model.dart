 

import '../export_all.dart';

class BannerDataModel {
    final int id;
    final Meta meta;

    BannerDataModel({
        required this.id,
        required this.meta,
    });

    BannerDataModel copyWith({
        int? id,
        Meta? meta,
    }) => 
        BannerDataModel(
            id: id ?? this.id,
            meta: meta ?? this.meta,
        );

    

    String toRawJson() => json.encode(toJson());

    factory BannerDataModel.fromJson(Map<String, dynamic> json) => BannerDataModel(
        id: json["id"],
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "meta": meta.toJson(),
    };
}

class Meta {
    final String bannerType;
    final String imageUrl;

    Meta({
        required this.bannerType,

        required this.imageUrl,
    });

    Meta copyWith({
        String? bannerType,
        String? imageUrl,
    }) => 
        Meta(
            bannerType: bannerType ?? this.bannerType,

            imageUrl: imageUrl ?? this.imageUrl,
        );

    factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        bannerType: json["banner_type"],
        imageUrl: "${BaseApiServices.imageURL}${json["image_url"]}",
    );

    Map<String, dynamic> toJson() => {
        "banner_type": bannerType,
        "image_url": imageUrl,
    };
}
