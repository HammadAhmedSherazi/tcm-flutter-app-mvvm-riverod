import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tcm/config/asset_path.dart';

class UserProfileWidget extends StatelessWidget {
  final double radius;
  final String imageUrl;
  const UserProfileWidget({super.key, required this.radius , required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(imageUrl: imageUrl,imageBuilder: (context, imageProvider) => CircleAvatar(
      radius: radius,
      backgroundImage: imageProvider,
    ), placeholder: (context, url) => CircleAvatar(
      radius: radius,
      backgroundImage: const AssetImage(Assets.userAvatar),
    ), errorWidget: (context, url, error) => CircleAvatar(
      radius: radius,
      backgroundImage: const AssetImage(Assets.userAvatar),
    ),);
  }
}