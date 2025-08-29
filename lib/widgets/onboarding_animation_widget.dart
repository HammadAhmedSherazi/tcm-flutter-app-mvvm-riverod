import '../export_all.dart';

class RowAnimation extends StatefulWidget {
  const RowAnimation({super.key});

  @override
  RowAnimationState createState() => RowAnimationState();
}

class RowAnimationState extends State<RowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    _animation = Tween<double>(begin: 0.0, end: 1).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Stack(
              children: [
                // First Column - Top to Bottom
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      left: 0,
                      top: MediaQuery.of(context).size.height *
                          (_animation.value - 1),
                      child: const Column(
                        children: [
                          Tile(
                            image: Assets.sliders1,
                          ),
                          Tile(
                            image: Assets.sliders2,
                          ),
                          Tile(
                            image: Assets.sliders3,
                          ),
                          Tile(
                            image: Assets.sliders4,
                          ),
                          Tile(
                            image: Assets.sliders5,
                          ),
                          Tile(
                            image: Assets.sliders6,
                          ),
                          Tile(
                            image: Assets.sliders7,
                          ),
                          Tile(
                            image: Assets.sliders8,
                          ),
                          Tile(
                            image: Assets.sliders9,
                          ),
                          Tile(
                            image: Assets.sliders10,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Second Column - Bottom to Top
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      right: 0,
                      top: MediaQuery.of(context).size.height *
                          (_animation.value - 1),
                      child: const Column(
                        children: [
                          Tile(
                            image: Assets.sliders21,
                          ),
                          Tile(
                            image: Assets.sliders22,
                          ),
                          Tile(
                            image: Assets.sliders23,
                          ),
                          Tile(
                            image: Assets.sliders24,
                          ),
                          Tile(
                            image: Assets.sliders25,
                          ),
                          Tile(
                            image: Assets.sliders26,
                          ),
                          Tile(
                            image: Assets.sliders27,
                          ),
                          Tile(
                            image: Assets.sliders28,
                          ),
                          Tile(
                            image: Assets.sliders31,
                          ),
                          Tile(
                            image: Assets.sliders37,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Third Column - Top to Bottom
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      bottom: MediaQuery.of(context).size.height *
                          (_animation.value - 1),
                      child: const Column(
                        children: [
                          Tile(
                            image: Assets.sliders30,
                          ),
                          Tile(
                            image: Assets.sliders31,
                          ),
                          Tile(
                            image: Assets.sliders32,
                          ),
                          Tile(
                            image: Assets.sliders33,
                          ),
                          Tile(
                            image: Assets.sliders34,
                          ),
                          Tile(
                            image: Assets.sliders35,
                          ),
                          Tile(
                            image: Assets.sliders36,
                          ),
                          Tile(
                            image: Assets.sliders37,
                          ),
                          Tile(
                            image: Assets.sliders38,
                          ),
                          Tile(
                            image: Assets.sliders39,
                          ),
                          Tile(
                            image: Assets.sliders40,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 154.h,
      width: 112.w,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: EdgeInsets.only(bottom: 10.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
    );
  }
}
