import '../export_all.dart';

class TabScreenTemplate extends StatelessWidget {
  final double height;
  final String topImage;
  final int tabIndex;
  final List<Widget> childrens;

  final Future<void> Function() onRefresh;

  const TabScreenTemplate(
      {super.key,
      required this.onRefresh,
      required this.tabIndex,
      required this.height,
      required this.topImage,
      required this.childrens});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.homeBackgroundImage),
                fit: BoxFit.cover)
                ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.r),
                child: Column(
                  children: [
                    TopWidget(
                      image: topImage,
                      index: tabIndex,
                      height: height,
                      // showLocation: showLocation,
                    ),
                    ...childrens
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
