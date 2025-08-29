import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';
class CommonScreenTemplateWidget extends StatelessWidget {
  final String title;
  final Widget? leadingWidget;
  final Widget? actionWidget;
  final Widget child;
  final double? appBarHeight;
  final PreferredSizeWidget? bottomAppbarWidget;
  final Widget? bottomWidget;
  final Future<void> Function()? onRefresh;

  const CommonScreenTemplateWidget(
      {super.key,
      this.leadingWidget,
      required this.title,
      required this.child,
      this.actionWidget,
      this.appBarHeight,
      this.onRefresh,
      this.bottomWidget,
      this.bottomAppbarWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor1,
      bottomSheet: bottomWidget,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            appBarHeight ?? AppBar().preferredSize.height + 30.h),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: leadingWidget,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: GenericTranslateWidget( 
            title,
            style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
          ),
          iconTheme: IconThemeData(size: 100.r),
          actions: actionWidget != null ? [actionWidget!, 20.pw] : null,
          bottom: bottomAppbarWidget,
        ),
      ),
      body: onRefresh != null ? RefreshIndicator(
          onRefresh: onRefresh! ,
          child: ScrollConfiguration(behavior: MyBehavior(), child: child)): ScrollConfiguration(behavior: MyBehavior(), child: child),
    );
  }
}
