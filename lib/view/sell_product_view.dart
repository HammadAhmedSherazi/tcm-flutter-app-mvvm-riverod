import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class SellProductView extends ConsumerStatefulWidget {
  final String? title;
  final List<Widget>? children;
  final bool? showSearchBar;
  final int? id;
  // final CategoryDataModel? category;
  const SellProductView({
    super.key,
    this.title,
    this.children,
    this.id,
    this.showSearchBar = false,
  });

  @override
  ConsumerState<SellProductView> createState() =>
      _SellProductViewConsumerState();
}

class _SellProductViewConsumerState extends ConsumerState<SellProductView> {
  @override
  void initState() {
    // if (widget.isSelectionList!) {
    //   isSelect = List.generate(
    //     widget.children!.length,
    //     (index) => false,
    //   );
    //   setState(() {});
    // }
    Future.delayed(Duration.zero, () {
      appLog("Sell View");
      ref
          .read(productDataProvider)
          .getAllCategories(limit: 10, cursor: null, id: widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
        title: "Sell Your Pre-owned Product",
        leadingWidget: const CustomBackButtonWidget(),
        onRefresh: ()async {
          ref
          .read(productDataProvider)
          .getAllCategories(limit: 10, cursor: null, id: widget.id);
        },
        child: BuySellScreenTemplateWidget(
          isBuy: false,
          title: widget.title ?? "All Categories",
          searchEnable: widget.showSearchBar,
        ));
  }
}

class ProductCategoryTitleWidget extends StatelessWidget {
  final bool? showLeadWidget;
  final String title;
  final String? imageUrl;
  final VoidCallback onTap;
  final bool? isSelectOpt;
  final bool? isCheck;
  const ProductCategoryTitleWidget(
      {super.key,
      this.showLeadWidget = false,
      required this.title,
      required this.onTap,
      this.isSelectOpt = false,
      this.isCheck = false,
      this.imageUrl = ""});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4.0),
      horizontalTitleGap: showLeadWidget! ? 25.r : null,
      leading: showLeadWidget!
          ? Container(
              height: 62.r,
              width: 62.r,
              decoration: BoxDecoration(
                  color: context.colors.onInverseSurface,
                  borderRadius: BorderRadius.circular(5000.r)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5000.r),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: -20,
                      bottom: -1,
                      child: ClipRRect(
                        clipBehavior: Clip.none,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(500.r)),
                        child: DisplayNetworkImage(
                          imageUrl: imageUrl!,
                          width: 70.r,
                          height: 40.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      title: GenericTranslateWidget( 
        title,
        style: context.textStyle.bodyMedium!.copyWith(
            fontSize: 16.sp,
            color: isSelectOpt!
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.black),
      ),
      trailing: !isSelectOpt!
          ? Icon(
              Icons.arrow_forward_ios,
              size: 15.r,
              color: Colors.black,
            )
          : GestureDetector(
              child: Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isCheck! ? AppColors.primaryGradinet : null,
                  color: !isCheck! ? Colors.grey.withValues(alpha: 0.2) : null,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18.r,
                ),
              ),
            ),
    );
  }
}
