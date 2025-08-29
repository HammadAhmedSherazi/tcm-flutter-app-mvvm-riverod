import '../export_all.dart';

class CustomMenuIconShape extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double ? padding;
  const CustomMenuIconShape(
      {super.key,
      required this.icon,
      required this.onTap,
      this.width,
      this.padding,
      this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 40.r,
        height: height ?? 40.r,
        padding: EdgeInsets.all(padding ?? 8.r),
        decoration: BoxDecoration(
          border:
              Border.all(width: 1, color: const Color.fromRGBO(0, 0, 0, 0.10)),
          shape: BoxShape.circle,
          color: const Color(0xffF6F6F6),
        ),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
