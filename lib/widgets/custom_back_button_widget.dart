import '../export_all.dart';

class CustomBackButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final double? size;
  const CustomBackButtonWidget({super.key, this.onTap,this.size});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4.0),
        onPressed: onTap ??
            () {
              AppRouter.back();
            },
        icon: Container(
          width: size ?? 31.r,
          height: size ?? 31.r,
          padding: EdgeInsets.all(5.r),
          alignment: Alignment.center,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 21.r,
          ),
        ));
  }
}