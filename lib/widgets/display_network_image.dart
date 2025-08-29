import '../export_all.dart';

class DisplayNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const DisplayNetworkImage(
      {super.key,
      required this.imageUrl,
      this.height,
      this.width,
      this.errorWidget,
      this.loadingWidget});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) =>
          errorWidget ??
          Image.asset(
            Assets.placeholderImage,
            fit: BoxFit.cover,
          ),
      placeholder: (context, url) =>
          loadingWidget ??
          Image.asset(
            Assets.placeholderImage,
            fit: BoxFit.cover,
          ),
    );
  }
}
