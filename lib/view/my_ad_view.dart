import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class MyAdView extends ConsumerStatefulWidget {
  const MyAdView({super.key});

  @override
  ConsumerState<MyAdView> createState() => _MyWidgetConsumerState();
}

class _MyWidgetConsumerState extends ConsumerState<MyAdView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  // void showFilterDialog(BuildContext context, WidgetRef ref) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const GenericTranslateWidget( "Select Filter",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 10),
  //             _buildFilterOption("Active", ref),
  //             _buildFilterOption("Sold", ref),
  //             _buildFilterOption("Archived", ref),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildFilterOption(String option, WidgetRef ref) {
  //   String status = ref.watch(productDataProvider).status;
  //   return ListTile(
  //     leading: Icon(
  //       status == option ? Icons.check_circle : Icons.radio_button_unchecked,
  //       color: status == option ? Colors.blue : Colors.grey,
  //     ),
  //     title: GenericTranslateWidget( option, style: TextStyle(fontSize: 16.sp)),
  //     onTap: () {
  //       ref
  //           .read(productDataProvider)
  //           .getMyAdProducts(limit: 10, cursor: null, myStatus: option);
  //       Navigator.pop(context); // Close the bottom sheet
  //     },
  //   );
  // }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
       if (tabController.indexIsChanging) return; 
      final provider = ref.watch(productDataProvider);
      if (provider.adApiResponse.status != Status.loading) {
        ref.read(productDataProvider).getMyAdProducts(
            limit: 15, cursor: null, myStatus: setType(tabController.index));
      }
    });

    Future.delayed(Duration.zero, () {
      ref.read(productDataProvider).getMyAdProducts(
          limit: 15, cursor: null, myStatus: setType(tabController.index));
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(productDataProvider).adProuctCursor;
          // String status = ref.watch(productDataProvider).status;
          ref.read(productDataProvider).getMyAdProducts(
              limit: 4,
              cursor: cursor,
              myStatus: setType(tabController.index));
                });
      }
    });
    super.initState();
  }

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final isLoad = ref.watch(productDataProvider).adApiResponse.status;
    final items = ref.watch(productDataProvider).myAdProducts;
    return CommonScreenTemplateWidget(
        title: "My Ads",
        leadingWidget: const CustomBackButtonWidget(),
        appBarHeight: AppBar().preferredSize.height + 70.h,
        bottomAppbarWidget:
            CustomTabBarWidget(controller: tabController, tabs:  [
               Tab(text: Helper.getCachedTranslation(ref: ref, text: "Active")),
               Tab(text: Helper.getCachedTranslation(ref: ref, text: "Sold")),
               Tab(text: Helper.getCachedTranslation(ref: ref, text:"Expired")),
        
        ]),
        onRefresh: () async {
          ref.read(productDataProvider).getMyAdProducts(
              limit: 15, cursor: null, myStatus: setType(tabController.index));
        },
        child: isLoad == Status.loading
            ? const Center(child: CustomLoadingWidget())
            : isLoad == Status.error
                ? Center(
                    child: CustomErrorWidget(
                      onPressed: () {
                        ref.read(productDataProvider).getMyAdProducts(
                            limit: 15,
                            cursor: null,
                            myStatus: setType(tabController.index));
                      },
                    ),
                  )
                : items.isEmpty
                    ? const ShowEmptyItemDisplayWidget(
                        message: "No Ads exits!")
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        padding: EdgeInsets.only(
                            top: AppStyles.screenHorizontalPadding,
                            left: AppStyles.screenHorizontalPadding,
                            right: AppStyles.screenHorizontalPadding,
                            bottom: 30.r),
                        itemBuilder: (context, index) {
                          return isLoad == Status.loadingMore &&
                                  index == items.length
                              ? const CustomLoadingWidget()
                              : MyADProductCardWidget(
                                  items: items[index],
                                  index: index,
                                );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: isLoad == Status.loadingMore
                            ? items.length + 1
                            : items.length));
  }
}

class MyADProductCardWidget extends StatelessWidget {
  const MyADProductCardWidget({
    super.key,
    required this.items,
    required this.index,
  });

  final ProductDetailDataModel items;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.push(AdPreviewView(
          data: items,
        ));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        children: [
          Row(
            spacing: 10.w,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: DisplayNetworkImage(
                  imageUrl: items.productImage!,
                  height: 123.r,
                  width: 125.r,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenericTranslateWidget( 
                                items.productName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.labelMedium!
                                    .copyWith(fontSize: 16.sp),
                              ),
                              GenericTranslateWidget( 
                                items.productDescription!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.bodyMedium,
                              ),
                              GenericTranslateWidget( 
                                "\$${items.productPrice!}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyle.displayMedium!
                                    .copyWith(fontSize: 18.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.r,
                          ),
                          decoration: BoxDecoration(
                              color: setColor(items.status!)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.r)),
                          child: GenericTranslateWidget( 
                            items.status!,
                            style: context.textStyle.bodyMedium!
                                .copyWith(color: setColor(items.status!)),
                          ),
                        )
                      ],
                    ),
                    5.ph,
                    Row(
                      spacing: 3.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.watch_later,
                          size: 16.r,
                          color: setColor(items.status!),
                        ),
                        Expanded(
                          child: GenericTranslateWidget( 
                            "Available From ${Helper.formatDateTime2(items.checkIn!)} to ${Helper.formatDateTime2(items.checkOut!)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyle.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (items.status != "Sold" ) ...[
            Row(
              children: [
                // if(items.status == "Active")...[
                  Expanded(
                    child: CustomButtonWidget(
                  title: "Edit",
                  onPressed: () {
                    AppRouter.push(AdProductView(
                      category: null,
                      subCategory: null,
                      product: items,
                      index: index,
                    ));
                  },
                  border: Border.all(color: AppColors.borderColor),
                  textColor: Colors.black,
                  color: const Color(0xffEFEDEC),
                )),
                9.pw,
                // ],
                
                Expanded(
                    child: CustomButtonWidget(
                        title: "Delete",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    AppRouter.back();
                                  },
                                  child: GenericTranslateWidget( 
                                    "No",
                                    style: context.textStyle.displayMedium!
                                        .copyWith(fontSize: 18.sp),
                                  ),
                                ),
                                Consumer(
                                  builder: (_, WidgetRef ref, __) {
                                    final isLoad = ref
                                        .watch(productDataProvider)
                                        .deleteAdApiResponse
                                        .status;
                                    return isLoad == Status.loading
                                        ? const CircularProgressIndicator()
                                        : TextButton(
                                            onPressed: () {
                                              ref
                                                  .read(productDataProvider)
                                                  .deleteAd(
                                                      id: items.id!,
                                                      index: index);
                                            },
                                            child: GenericTranslateWidget( 
                                              "Yes",
                                              style: context
                                                  .textStyle.displayMedium!
                                                  .copyWith(fontSize: 18.sp),
                                            ),
                                          );
                                  },
                                ),
                              ],
                              content: Row(
                                children: [
                                  Expanded(
                                    child: GenericTranslateWidget( 
                                      "Are you sure to delete this ad?",
                                      style: context.textStyle.displayMedium!
                                          .copyWith(fontSize: 20.sp),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        
                        }))
              ],
            )
          ]
        ],
      ),
    );
  }
}

Color setColor(String status) {
  switch (status.toLowerCase()) {
    case "active":
      return const Color(0xff0C9409);
    case "sold":
      return Colors.black;
    case "archived":
      return AppColors.primaryColor;
    default:
      return Colors.transparent;
  }
}


String setType(int index) {
  if (index == 0) {
    return "Active";
  } else if (index == 1) {
    return "Sold";
  } else {
    return "Archived";
  }
}
