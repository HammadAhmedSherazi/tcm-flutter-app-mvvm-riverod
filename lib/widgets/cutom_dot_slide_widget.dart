import '../export_all.dart';

class PagerDot extends StatelessWidget {
  const PagerDot(
      {super.key,
      required this.length,
      required this.currentIndex,
      this.isCircle = false});

  final int length;
  final int currentIndex;
  final bool? isCircle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 4),
          height: 7,
          width: !isCircle! ? 30 : 7,
          decoration: BoxDecoration(
            borderRadius: !isCircle! ? BorderRadius.circular(10.r) : null,
            gradient: currentIndex == index ? AppColors.primaryGradinet : null,
            shape: isCircle! ? BoxShape.circle : BoxShape.rectangle,
            color: currentIndex != index
                ? isCircle!
                    ? const Color(0xffD9D9D9).withValues(alpha: 0.5)
                    : Colors.white
                : null,
          ),
        ),
      ),
    );
  }
}
