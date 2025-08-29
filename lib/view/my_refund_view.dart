import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class MyRefundView extends ConsumerStatefulWidget {
  const MyRefundView({super.key});

  @override
  ConsumerState<MyRefundView> createState() => _RefundViewConsumerState();
}

class _RefundViewConsumerState extends ConsumerState<MyRefundView>
    with SingleTickerProviderStateMixin {
  late final ScrollController scrollController;
  late TabController tabController;
  @override
  @override
  void initState() {
    scrollController = ScrollController();
    tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref
          .read(productDataProvider.notifier)
          .getRefundRequest(limit: 10, cursor: null);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
            if(tabController.index == 0){
  Future.microtask( () {
          String? cursor = ref.watch(productDataProvider).refundRequestCursor;
          ref
        .read(productDataProvider.notifier).getRefundRequest(limit: 10, cursor: cursor);
                });
            }
            else{
               Future.microtask( () {
          String? cursor = ref.watch(cardProvider).transactionCursor;
          ref.read(cardProvider).getTransaction(cursor: cursor, limit: 10, type:"Refund");
                });
            }

          }
    });
    tabController.addListener(() {
      if (tabController.indexIsChanging) return;
      if (tabController.index == 0) {
        ref
            .read(productDataProvider.notifier)
            .getRefundRequest(limit: 10, cursor: null);
      } else {
        ref.read(cardProvider).getTransaction(cursor: null, limit: 10, type: "Refund");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final provider2 = ref.watch(cardProvider);
     final responseTransaction = provider2.getTransactionApiResponse;
    final statusTransaction = responseTransaction.status;
    
    // final products = provider.loadingProduct;
    return CommonScreenTemplateWidget(
      onRefresh: () async {},
      leadingWidget: const CustomBackButtonWidget(),
      title: "My Refunds",
      appBarHeight: AppBar().preferredSize.height + 70.h,
      bottomAppbarWidget:
          CustomTabBarWidget(controller: tabController, tabs:  [
             Tab(text: Helper.getCachedTranslation(ref: ref, text: "Refund Requests")),
                Tab(text: Helper.getCachedTranslation(ref: ref, text:  "Transactions")),
       
      ]),
      child: TabBarView(controller: tabController, children: [
        AsyncStateHandler(
            status: provider.getRefundRequestApiResponse.status,
            dataList: provider.refundRequestList,
            scrollController: scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding,
              vertical: 20.r
            ),

            itemBuilder: (context, index) {
              if(provider.getRefundRequestApiResponse.status == Status.loadingMore && index == provider.refundRequestList.length ) {
                return const CustomLoadingWidget();
              }
              else{
              final RefundRequestDataModel item = provider.refundRequestList[index];
                return RefundRequestCardWidget(
                  data: item,
                );
          
              }

                },
            onRetry: (){
              ref
            .read(productDataProvider.notifier)
            .getRefundRequest(limit: 10, cursor: null);
            }),
        AsyncStateHandler(
           padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding,
              vertical: 20.r
            ),
                  emptyMessage: "No any transaction found",
                  status: statusTransaction, dataList: provider2.transactions, itemBuilder:   (context, index) {
                      if(statusTransaction == Status.loadingMore && index == provider2.transactions.length){
                        return const Center(child: CircularProgressIndicator());
                      }
                      else{
                        final item = provider2.transactions[index];
                      return CustomDespositeWidget(
                          title: "${item.type} ${item.status}",
                          price: double.tryParse(item.amount.toStringAsFixed(2))!,
                          type: item.type);
                      }
                      
                    }, onRetry: (){
                       ref.read(cardProvider).getTransaction(cursor: null, limit: 10, type: "Refund");
        
                    })
      ]),
    );
  }
}

class RefundRequestCardWidget extends StatelessWidget {
  final RefundRequestDataModel data;
  const RefundRequestCardWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white, // background: #FFF
      borderRadius:
          BorderRadius.circular(10), // border-radius: 10px
      boxShadow: [
        BoxShadow(
          color: Colors.black
              .withValues(alpha: 0.09), // rgba(0,0,0,0.09)
          offset: const Offset(0, 3), // x=0, y=3
          blurRadius: 4, // blur-radius: 4px
          spreadRadius: 0, // spread-radius: 0
        ),
      ],
    ),
    child: Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60.h,
          child: Row(
            spacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: DisplayNetworkImage(
                  imageUrl: data.product.thumbnailImage,
                  width: 60.r,
                  height: double.infinity,
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: GenericTranslateWidget( 
                    data.product.title,
                    style: context.textStyle.displayMedium!
                        .copyWith(fontSize: 18.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                  GenericTranslateWidget( 
                    data.product.description,
                    style: context.textStyle.displayMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )),
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
                  data.status,
                  style: context.textStyle.bodySmall!.copyWith(
                      color: Colors.black.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GenericTranslateWidget( 
              "Reason Type: ",
              style: context.textStyle.displayMedium,
            ),
            GenericTranslateWidget( 
              data.reasonCode,
              style: context.textStyle.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GenericTranslateWidget( 
              "Amount",
              style: context.textStyle.displayMedium,
            ),
            GenericTranslateWidget( 
              "\$${data.refundAmount.toStringAsFixed(2)}",
              style: context.textStyle.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GenericTranslateWidget( 
              "Reason",
              style: context.textStyle.displayMedium,
            ),
            const Spacer(),
            Expanded(
              child: GenericTranslateWidget( 
                data.reason,
                style: context.textStyle.bodyMedium,
                maxLines: 1,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    ),
                  );
  }
}
