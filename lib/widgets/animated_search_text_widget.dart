import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class AnimatedSearchText extends StatefulWidget {
  final List<String> texts;

  const AnimatedSearchText( {
    super.key,
    required this.texts,
  });

  @override
  AnimatedSearchTextState createState() => AnimatedSearchTextState();
}

class AnimatedSearchTextState extends State<AnimatedSearchText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed && !_isPaused) {
        // Pause when animation reaches the center
        if (!mounted) return; // Ensure widget is still mounted

        // Initial pause and state change
        setState(() {
          _isPaused = true;
        });

        // Wait for 4-5 seconds
        await Future.delayed(const Duration(seconds: 2));

        // If widget is still mounted, proceed with next text and reset animation
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.texts.length;
          });

          // Reset animation and start it again
          _controller.reset();
          _controller.forward();

          // After animation finishes, reset pause flag
          if (mounted) {
            setState(() {
              _isPaused = false;
            });
          }
        }
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0.0, 50.h * _animation.value),
                child: GenericTranslateWidget( 
                  widget.texts[_currentIndex],
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.displayMedium!.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
