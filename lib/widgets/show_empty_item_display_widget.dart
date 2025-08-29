import '../export_all.dart';

class ShowEmptyItemDisplayWidget extends StatelessWidget {
  final String message;
  final String? lottie;
  final double? width;
  const ShowEmptyItemDisplayWidget(
      {super.key, required this.message, this.lottie, this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Lottie.asset(lottie ?? Assets.noCategoryAnimation,
                repeat: true, width: width ?? 200.r, fit: BoxFit.fill),
            GenericTranslateWidget( 
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
