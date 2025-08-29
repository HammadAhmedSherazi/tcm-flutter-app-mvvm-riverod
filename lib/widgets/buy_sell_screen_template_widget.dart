import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class BuySellScreenTemplateWidget extends ConsumerStatefulWidget {
  final String title;
  // final List<Widget> childrens;
  final bool? searchEnable;
  final bool isBuy;
  final int? id;
  final bool? isFilter;
  final bool? isEdit;
  const BuySellScreenTemplateWidget(
      {super.key,
      required this.title,
      // required this.childrens,
      this.id,
      required this.isBuy,
      this.isFilter = false,
      this.isEdit = false,
      this.searchEnable = false});

  @override
  ConsumerState<BuySellScreenTemplateWidget> createState() =>
      _BuySellScreenTemplateWidgetConsumerState();
}

class _BuySellScreenTemplateWidgetConsumerState
    extends ConsumerState<BuySellScreenTemplateWidget> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(productDataProvider).categoryCurson;
          if (cursor != "") {
            ref.read(productDataProvider).getAllCategories(
                limit: 4,
                cursor: cursor,
                id: ref.read(productDataProvider).lastId);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final isLoad = provider.categoryApiResponse.status;
    final items = ref.watch(productDataProvider).allCategories;
    final lastId = ref.watch(productDataProvider).lastId;
    final selectedCategory = ref.watch(productDataProvider).selectedCategory;
    final languageCode = ref.watch(languageChangeNotifierProvider).currentLanguage.code;
   

    return isLoad == Status.loading
        ? const Center(
            child: CustomLoadingWidget(),
          )
        : isLoad == Status.error
            ? Center(
                child: CustomErrorWidget(onPressed: () {
                  ref
                      .read(productDataProvider)
                      .getAllCategories(limit: 10, cursor: null, id: widget.id);
                }),
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: AppStyles.screenHorizontalPadding,
                    right: AppStyles.screenHorizontalPadding,
                    bottom: 40.r),
                child: Column(children: [
                  if (widget.searchEnable!) ...[
                    CustomSearchBarWidget(
                        isArabic: languageCode == "ar",
                        controller: TextEditingController(),
                        hintText: "Search product"),
                    20.ph,
                  ],
                  Row(
                    children: [
                      GenericTranslateWidget( 
                        widget.title,
                        style: context.textStyle.displayMedium!
                            .copyWith(fontSize: 18.sp),
                      ),
                    ],
                  ),
                  10.ph,
                  Expanded(
                      child: items.isNotEmpty
                          ? ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                            
                              itemBuilder: (context, index) {
                                return isLoad == Status.loadingMore && items.length == index
                                    ? const CustomLoadingWidget()
                                    : ProductCategoryTitleWidget(
                                        isSelectOpt: widget.isBuy &&
                                            items[index].isFinal,
                                        showLeadWidget: items[index].isMain,
                                        isCheck: ref
                                            .watch(productDataProvider)
                                            .selectItemsId
                                            .contains(items[index].id),
                                        title: items[index].title,
                                        onTap: widget.isBuy &&
                                                items[index].isFinal
                                            ? () {
                                                ref
                                                    .read(productDataProvider)
                                                    .checkList(items[index].id);
                                              }
                                            : () {
                                                if (!widget.isFilter!) {
                                                  if (provider
                                                          .selectedCategory ==
                                                      null) {
                                                    ref
                                                        .read(
                                                            productDataProvider)
                                                        .setCategory(
                                                            items[index]);
                                                  }
                                                  widget.isBuy
                                                      ? AppRouter.push(
                                                          BuyProductView(
                                                            isEdit:
                                                                widget.isEdit,
                                                            title: items[index]
                                                                .title,
                                                            id: items[index].id,
                                                          ), fun: () {
                                                          ref
                                                              .read(
                                                                  productDataProvider)
                                                              .getAllCategories(
                                                                  limit: 10,
                                                                  cursor: null,
                                                                  id: lastId);
                                                        })
                                                      : items[index].isFinal
                                                          ? AppRouter.push(
                                                              AdProductView(
                                                                  category:
                                                                      selectedCategory,
                                                                  subCategory:
                                                                      items[
                                                                          index]),
                                                              fun: () {
                                                              ref
                                                                  .read(
                                                                      productDataProvider)
                                                                  .getAllCategories(
                                                                      limit: 10,
                                                                      cursor:
                                                                          null,
                                                                      id: lastId);
                                                            })
                                                          : AppRouter.push(
                                                              SellProductView(
                                                                id: items[index]
                                                                    .id,
                                                                title:
                                                                    items[index]
                                                                        .title,
                                                                showSearchBar:
                                                                    items[index]
                                                                        .isFinal,
                                                              ), fun: () {
                                                              ref
                                                                  .read(
                                                                      productDataProvider)
                                                                  .getAllCategories(
                                                                      limit: 10,
                                                                      cursor:
                                                                          null,
                                                                      id: lastId);
                                                            });
                                                } else {
                                                  if (items[index].isFinal) {
                                                    final loc = ref
                                                        .watch(
                                                            currentLocationProvider)
                                                        .currentLocation;
                                                    if (widget.id == null) {
                                                      ref
                                                          .read(
                                                              productDataProvider)
                                                          .setCategory(
                                                              items[index]);
                                                      AppRouter.back();
                                                    } else {
                                                      ref
                                                          .read(
                                                              productDataProvider)
                                                          .setLastCategory(
                                                              items[index]);
                                                      appLog(
                                                          "Run ${provider.selectedCategoryPageCount}");
                                                      AppRouter.customback(
                                                          times: provider
                                                              .selectedCategoryPageCount);
                                                    }

                                                    ref
                                                        .read(
                                                            productDataProvider)
                                                        .getSeeAllAds(
                                                            limit: 10,
                                                            lat: loc.lat,
                                                            long: loc.lon,
                                                            cursor: null,
                                                            categoryId:
                                                                items[index].id,
                                                            searchText: null,
                                                            under10: false,
                                                            vanish: false,
                                                            type: "Ad");
                                                  } else {
                                                    if (widget.id == null) {
                                                      ref
                                                          .read(
                                                              productDataProvider)
                                                          .setCategory(
                                                              items[index]);
                                                      AppRouter.back();
                                                    }
                                                    else{
                                                       AppRouter.push(
                                                        FilterCategoryView(
                                                            category:
                                                                items[index]),
                                                        fun: () {
                                                      ref
                                                          .read(
                                                              productDataProvider)
                                                          .getAllCategories(
                                                              limit: 10,
                                                              cursor: null,
                                                              id: lastId);
                                                    });
                                                    }
                                                   
                                                  }
                                                }
                                              },
                                        imageUrl: items[index].imageUrl,
                                      );
                              }
                              // :
                              //  ProductCategoryTitleWidget(
                              //     showLeadWidget: true,
                              //     title: items[index].title,
                              //     onTap: () {
                              //       AppRouter.push(SellProductView(
                              //         children: List.generate(
                              //             CategoryDataModel
                              //                 .sellSubCategories.length,
                              //             (index) =>
                              //                 ProductCategoryTitleWidget(
                              //                   title: CategoryDataModel
                              //                       .sellSubCategories[
                              //                           index]
                              //                       .title,
                              //                   onTap: () {
                              //                     AppRouter.push(
                              //                         SellProductView(
                              //                       showSearchBar: true,
                              //                       title: CategoryDataModel
                              //                           .sellSubCategories[
                              //                               index]
                              //                           .title,
                              //                       children: List.generate(
                              //                           CategoryDataModel
                              //                               .sellSubInnerCategories
                              //                               .length,
                              //                           (index) =>
                              //                               ProductCategoryTitleWidget(
                              //                                 title: CategoryDataModel
                              //                                     .sellSubInnerCategories[
                              //                                         index]
                              //                                     .title,
                              //                                 onTap: () {
                              // AppRouter.push(AdProductView(
                              //     category:
                              //         CategoryDataModel.categories[
                              //             index],
                              //     subCategoryTitle: CategoryDataModel
                              //         .sellSubInnerCategories[index]
                              //         .title));
                              //                                 },
                              //                                 showLeadWidget:
                              //                                     false,
                              //                               )),
                              //                     ));
                              //                   },
                              //                   showLeadWidget: false,
                              //                 )),
                              //       ));
                              //     },
                              //     imageUrl: CategoryDataModel
                              //         .categories[index].imageUrl,
                              //   ),

                              ,
                              separatorBuilder: (context, index) => 15.ph,
                              controller: scrollController,
                              itemCount: isLoad == Status.loadingMore
                                  ? items.length + 1
                                  : items.length)
                          : const Center(
                              child: ShowEmptyItemDisplayWidget(
                                  message: "No Category exists!"),
                            ))
                
                ]),
              );
  }
}
