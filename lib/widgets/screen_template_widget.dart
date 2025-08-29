import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class ScreenTemplateWidget extends StatelessWidget {
  final String title;
  final Widget? actionButton;
  final List<Widget>? children;
  final Widget? child;
  final ScrollController? controller;

  const ScreenTemplateWidget(
      {super.key,
      required this.title,
      this.children,
      this.controller,
      this.child,
      this.actionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primaryContainer,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: AppBar(
            centerTitle: true,
            elevation: 0.0,
            leading: IconButton(
                padding: EdgeInsets.zero,
                visualDensity:
                    const VisualDensity(horizontal: -4.0, vertical: -4.0),
                onPressed: () {
                  AppRouter.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: context.colors.onSurfaceVariant,
                  size: 22.r,
                )),
            title: GenericTranslateWidget( 
              title,
              style: context.textStyle.labelMedium!.copyWith(fontSize: 16.sp),
            ),
            backgroundColor: Colors.transparent,
            actions: actionButton != null ? [actionButton!] : null,
          )),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: child ??
            ListView(
              controller: controller,
              physics: child != null
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyles.screenHorizontalPadding, vertical: 0),
              children: children ?? [],
            ),
      ),
    );
  }
}
