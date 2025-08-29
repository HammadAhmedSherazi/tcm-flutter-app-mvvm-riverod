import '../export_all.dart';

class BuyProductView extends ConsumerStatefulWidget {
  final String? title;
  final bool? isEdit;

  final List<Widget>? children;
  final bool? showSearchBar;
  final Widget? bottomWidget;
  final bool? isSelectionList;
  final int? id;
  const BuyProductView(
      {super.key,
      this.title,
      this.isEdit = false,
      this.children,
      this.showSearchBar = false,
      this.isSelectionList = false,
      this.id,
      this.bottomWidget});

  @override
  ConsumerState<BuyProductView> createState() => _BuyProductViewConsumerState();
}

class _BuyProductViewConsumerState extends ConsumerState<BuyProductView> {
  List<bool> isSelect = [];
  @override
  void initState() {
    if (widget.bottomWidget == null) {
      Future.delayed(Duration.zero, () {
        ref
            .read(productDataProvider)
            .getAllCategories(limit: 10, cursor: null, id: widget.id);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = ref.watch(productDataProvider);
    return CommonScreenTemplateWidget(
        title: widget.isEdit! ? "Edit Notified Products" :  "Buy Your Desired Products",
        leadingWidget: const CustomBackButtonWidget(),
        bottomWidget: productProvider.selectItemsId.isNotEmpty
            ? Padding(
                padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
                child: CustomButtonWidget(
                    title: "Next",
                    onPressed: () {
                      AppRouter.push( SetLocationRadiusView(
                        isEdit: widget.isEdit,
                      ));
                    }),
              )
            : null,
        child: BuySellScreenTemplateWidget(
          isBuy: true,
          title: widget.title ?? "All Categories",
          searchEnable: widget.showSearchBar,
          id: widget.id,

          // childrens:
          //     List.generate(
          //       subCategories.length,
          //       (index) => Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           ProductCategoryTitleWidget(
          //             showLeadWidget: subCategories[index].isMain,
          //             title: subCategories[index].title,
          //             onTap: () {
          //               AppRouter.push(
          //                   BuyProductView(
          //                     id: subCategories[index].id,
          //                     children: List.generate(
          //                         subCategories.length,
          //                         (index) => ProductCategoryTitleWidget(
          //                               title: subCategories[index].title,
          //                               onTap: () {
          //                                 AppRouter.push(BuyProductView(
          //                                   title: subCategories[index].title,
          //                                   id: subCategories[index].id,
          //                                   children: List.generate(
          //                                       subCategories.length,
          //                                       (index) =>
          //                                           ProductCategoryTitleWidget(
          //                                             title:
          //                                                 subCategories[index]
          //                                                     .title,
          //                                             onTap: () {
          //                                               AppRouter.push(
          //                                                   BuyProductView(
          //                                                 showSearchBar:
          //                                                     subCategories[
          //                                                             index]
          //                                                         .isFinal,
          //                                                 bottomWidget:
          //                                                     Padding(
          //                                                   padding: EdgeInsets
          //                                                       .all(AppStyles
          //                                                           .screenHorizontalPadding),
          //                                                   child:
          //                                                       CustomButtonWidget(
          //                                                           title:
          //                                                               "Next",
          //                                                           onPressed:
          //                                                               () {
          //                                                             AppRouter.push(
          //                                                                 const SetLocationRadiusView());
          //                                                           }),
          //                                                 ),
          //                                                 title:
          //                                                     subCategories[
          //                                                             index]
          //                                                         .title,
          //                                                 children:
          //                                                     List.generate(
          //                                                         CategoryDataModel
          //                                                             .buyInnerSuCategories
          //                                                             .length,
          //                                                         (index) =>
          //                                                             ProductCategoryTitleWidget(
          //                                                               isSelectOpt:
          //                                                                   subCategories[index].isFinal,
          //                                                               isCheck:
          //                                                                   subCategories[index].isSelected,
          //                                                               title:
          //                                                                   subCategories[index].title,
          //                                                               onTap:
          //                                                                   () {
          //                                                                 ref.read(productDataProvider).checkList(index);
          //                                                               },
          //                                                               showLeadWidget:
          //                                                                   false,
          //                                                             )),
          //                                               ));
          //                                             },
          //                                             showLeadWidget: false,
          //                                           )),
          //                                 ));
          //                               },
          //                               showLeadWidget: false,
          //                             )),
          //                   ), fun: () {
          //                 ref.read(productDataProvider).getAllCategories(
          //                     limit: 10, cursor: null, id: widget.id);
          //               });
          //             },
          //             imageUrl: subCategories[index].imageUrl,
          //           ),
          //           15.ph
          //         ],
          //       ),
          //     )
        ));
  }
}
