import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class AdOrderView extends ConsumerStatefulWidget {
  const AdOrderView({super.key});

  @override
  ConsumerState<AdOrderView> createState() => _AdOrderViewConsumerState();
}

class _AdOrderViewConsumerState extends ConsumerState<AdOrderView> {
  late final ScrollController? scrollController;
  int selectIndex = 0;
  final List<String> filterList = [
   
    "Pending",
    "Confirmed",
  ];

  @override
  void initState() {
    scrollController = ScrollController();
    Future.microtask(() {
      ref.read(productDataProvider.notifier).onDispose();
      ref.read(productDataProvider.notifier).getAdOrder(
          cursor: null,
          limit: 10,
          status: filterList[selectIndex]);
    });
    scrollController?.addListener(() {
      if (scrollController?.position.pixels ==
          scrollController?.position.maxScrollExtent) {
        Future.microtask(() {
          String? cursor = ref.watch(productDataProvider).orderAdHistoryCursor;
          // String status = ref.watch(productDataProvider).status;
          ref.read(productDataProvider).getAdOrder(
              cursor: cursor,
              limit: 5,
              status:  filterList[selectIndex]);
                });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final status = provider.orderAdApiResponse.status;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding, vertical: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                filterList.length,
                (index) => GestureDetector(
                  onTap: () {
                    selectIndex = index;
                    ref.read(productDataProvider.notifier).getAdOrder(
                        cursor: null,
                        limit: 10,
                        status:
                            filterList[selectIndex]);
                    setState(() {});
                  },
                  child: Container(
                    height: 28.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 15.r),
                    margin: EdgeInsets.only(right: 5.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(15.r),
                          right: Radius.circular(15.r)),
                      gradient: selectIndex == index
                          ? AppColors.primaryGradinet
                          : null,
                    ),
                    child: GenericTranslateWidget( 
                      filterList[index],
                      style: context.textStyle.bodyMedium!.copyWith(
                          color: selectIndex == index
                              ? Colors.white
                              : Colors.black.withValues(alpha: 0.6)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.read(productDataProvider).getAdOrder(
                  cursor: null,
                  limit: 5,
                  status: selectIndex == 0 ? null : filterList[selectIndex]);
            },
            child: AsyncStateHandler(
                  status: status,
                  emptyMessage: "No order exist!",
                  dataList: provider.adOrderHistory,
                  padding: EdgeInsets.only(
                      left: AppStyles.screenHorizontalPadding,
                      right: AppStyles.screenHorizontalPadding,
                      bottom: 50.r),
                  itemBuilder: (context, index) {
                    if (status == Status.loadingMore &&
                        index == provider.adOrderHistory.length) {
                      return const CustomLoadingWidget();
                    } else {
                      final order = provider.adOrderHistory[index];
                      return GestureDetector(
                        onTap: () {
                          AppRouter.push(OrderDetailView(
                              summary: {
                                "Order No": order.adOrderNo,
                                "Name": order.contactInfo.username,
                                "Phone": order.contactInfo.phoneNo,
                                "Sub total":
                                    "${order.totalAmount - order.product.applicationFee!}",
                                "Application fees":
                                    "${order.product.applicationFee!}"
                              },
                              totalAmount: order.totalAmount,
                              child: AdOrderCardWidget(
                                order: order,
                                showOrderId: false,
                              )),fun: (){
                                 ref.read(productDataProvider.notifier).getAdOrder(
          cursor: null,
          limit: 10,
          status: filterList[selectIndex]);
                              }
                              );
                        },
                        child: AdOrderCardWidget(
                          order: order,
                          showOrderId: true,
                        ),
                      );
                    }
                  },
                  onRetry: () {
                    ref.read(productDataProvider.notifier).getAdOrder(
                        cursor: null,
                        limit: 10,
                        status:
                             filterList[selectIndex]);
                  }),
          ),
        ),
      ],
    );
  }
}

class AdOrderCardWidget extends StatelessWidget {
  final AdOrderDataModel order;
  final bool? showOrderId;
  const AdOrderCardWidget(
      {super.key, required this.order, this.showOrderId = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white, // background: #FFF
        borderRadius: BorderRadius.circular(10), // border-radius: 10px
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09), // rgba(0,0,0,0.09)
            offset: const Offset(0, 3), // x=0, y=3
            blurRadius: 4, // blur-radius: 4px
            spreadRadius: 0, // spread-radius: 0
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        children: [
          if (showOrderId!)
            Row(
              children: [
                GenericTranslateWidget( 
                  "Order No: ${order.adOrderNo}",
                  style: context.textStyle.displayMedium!
                      .copyWith(fontSize: 18.sp),
                )
              ],
            ),
          Row(
            children: [
              UserProfileWidget(
                  radius: 20.r, imageUrl: order.product.productOwner!.picture),
              10.pw,
              GenericTranslateWidget( 
                order.product.productOwner!.userName,
                style: context.textStyle.displayMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Container(
                height: 22.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10.r),
                decoration: BoxDecoration(
                    color: const Color(0xffE1E1E1),
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10.r),
                        right: Radius.circular(10.r))),
                child: GenericTranslateWidget( 
                  order.status,
                  style: context.textStyle.bodySmall!.copyWith(
                      color: Colors.black.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          SizedBox(
            height: 102.h,
            child: Row(
              spacing: 10,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: DisplayNetworkImage(
                    imageUrl: order.product.productImage!,
                    width: 102.r,
                    height: double.infinity,
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
                            child: GenericTranslateWidget( 
                          order.product.productName!,
                          style: context.textStyle.displayMedium!
                              .copyWith(fontSize: 18.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 22.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10.r),
                          decoration: BoxDecoration(
                              color: const Color(0xffE1E1E1),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10.r),
                                  right: Radius.circular(10.r))),
                          child: GenericTranslateWidget( 
                            order.product.category!.title,
                            style: context.textStyle.bodySmall!.copyWith(
                                color: Colors.black.withValues(alpha: 0.4),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              if (order.product.buyingReceipt!.isNotEmpty) {
                                showFullScreenReceiptModal(context,
                                    order.product.buyingReceipt!.first);
                              }
                            },
                            child: GenericTranslateWidget( 
                              "View Receipt",
                              textAlign: TextAlign.right,
                              style: context.textStyle.displayMedium!.copyWith(
                                decoration: TextDecoration.underline,
                                color: AppColors.primaryColor,
                              ),
                            ))
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GenericTranslateWidget( 
                          "\$${order.totalAmount}",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontSize: 18.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     AppRouter.push(ProductDetailView(
                        //         productId: order.product.id!,
                        //         categoryId: order.product.category!.id));
                        //   },
                        //   child: Container(
                        //     height: 22.h,
                        //     alignment: Alignment.center,
                        //     padding: EdgeInsets.symmetric(horizontal: 5.r),
                        //     margin: EdgeInsets.only(right: 5.r),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.horizontal(
                        //           left: Radius.circular(15.r),
                        //           right: Radius.circular(15.r)),
                        //       gradient: AppColors.primaryGradinet,
                        //     ),
                        //     child: GenericTranslateWidget( 
                        //       "Buy Again",
                        //       style: context.textStyle.bodySmall!.copyWith(
                        //           color: Colors.white, fontSize: 10.sp),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
