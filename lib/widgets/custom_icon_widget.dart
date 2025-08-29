import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tcm/utils/app_extensions.dart';

class CustomIconWidget extends StatelessWidget {
  final String icon;
  final double? height;
  final double? width;
  final Color? color;
  final BlendMode? mode;
  const CustomIconWidget(
      {super.key,
      required this.icon,
      this.height,
      this.width,
      this.color,
      this.mode});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
          color ?? context.colors.onSurfaceVariant, mode ?? BlendMode.srcIn),
    );
  }
}
