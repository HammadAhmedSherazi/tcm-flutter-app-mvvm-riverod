import 'package:tcm/utils/app_extensions.dart';
import '../../export_all.dart';


class WalletView extends ConsumerStatefulWidget {
  const WalletView({super.key});

  @override
  ConsumerState<WalletView> createState() => _WalletViewConsumerState();
}

class _WalletViewConsumerState extends ConsumerState<WalletView> {
  late final ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    Future.microtask((){
      ref.read(cardProvider).getWalletDetails();
      ref.read(cardProvider).getTransaction(cursor: null, limit: 10, type: "Withdraw");
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(cardProvider).transactionCursor;
          ref.read(cardProvider).getTransaction(cursor: cursor, limit: 10, type: "Withdraw");
                });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(cardProvider);
    final response = provider.getWalletDetailApiResponse;
    final status = response.status;
    final isLoad = provider.withDrawApiResponse.status == Status.loading;
    final responseTransaction = provider.getTransactionApiResponse;
    final statusTransaction = responseTransaction.status;
    final list = statusTransaction == Status.loading ? List.generate(4, (index) => TransactionDataModel(id: -1, amount: 100.0, type: "ad", status: "status", createdAt: DateTime.now()) ,) : provider.transactions;
    return CommonScreenTemplateWidget(
      appBarHeight: 80.h,
      title: "Wallet",
      leadingWidget: const CustomBackButtonWidget(),
      onRefresh: ()async{
        provider.getWalletDetails();
        provider.getTransaction(cursor: null, limit: 10, type: "Withdraw");
      },
      child: 
      AsyncStateHandler(
        data: response.data,
        status: status, dataList: const [""], itemBuilder: (p0, p1) => const SizedBox.shrink(), onRetry: () {
          ref.read(cardProvider).getWalletDetails();
        }, customSuccessWidget: response.data == null? const SizedBox.shrink():
        Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppStyles.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.h,
          children: [
             Stack(
               children: [
                 Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradinet,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppStyles.screenHorizontalPadding,
                                vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        spacing: 10.w,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minWidth: 0.0,
                                              maxWidth: context.screenwidth  * 0.35
                                            ),
                                            child: GenericTranslateWidget( 
                                              "Available Balance" ,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                              
                                                  context.textStyle.displayMedium?.copyWith(
                                                  
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w400,
                                                
                                                color: AppColors.scaffoldColor,
                                              ),
                                            ),
                                          ),
                                          SvgPicture.asset(Assets.noteIcon),
                                          const Spacer()
                                        ],
                                      ),
                                      GenericTranslateWidget( 
                                        "\$${double.tryParse(response.data!.balance.available.toStringAsFixed(2))}",
                                        style:
                                            context.textStyle.displayMedium?.copyWith(
                                          fontSize: 34.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.scaffoldColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // const Spacer(),
                                SizedBox(
                                    height: 42.h,
                                    width: 119.w,
                                    child: CustomButtonWidget(
                                      isLoad: isLoad,
                                      title: response.data?.attachBank == "pending" || response.data?.attachBank == "failed"
                                          ? "Attach Bank"
                                          : response.data?.attachBank == "processing"? "Processing" : "",
                                      onPressed: () {
                                        if(response.data?.attachBank == "pending" || response.data?.attachBank == "failed"){
                                          AppRouter.push(const AttachBankForm());
                                        }
                                        else if(response.data?.attachBank == "attached"){
                                          if(response.data!.balance.available > 0){
                                            provider.payOut();
                                          }
                                          // else{
                                          //   Helper.showMessage("No available balance");
                                          // }
                                         
                                          // AppRouter.push(const SelectPaymetView());
                                        }
                                        
                                      },
                                      color: response.data!.balance.available > 0 ? AppColors.greyColor : response.data?.attachBank == "attached"? Colors.grey.shade400.withValues(alpha: 0.7) : Colors.white,
                                      textColor: AppColors.lightIconColor,
                                      child: response.data?.attachBank == "attached"? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children:  [
                                          GenericTranslateWidget( 
                                            "Withdraw",
                                            style: context.textStyle.displayMedium!
                                                .copyWith(
                                              height: 1.8,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 6.r),
                                            child: Image.asset(Assets.walletIcon),
                                          )
                                        ],
                                      ) : null,
                                    ))
                              ],
                            ),
                          )),

                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(onPressed: (){
                    provider.getWalletDetails();
                    provider.getTransaction(cursor: null, limit: 10, type: "Withdraw");
                  }, icon: const Icon(Icons.refresh, color: Colors.white,)))
               ],
             ),
            Row(
              spacing: 10.w,
              children: [
                Expanded(
                  child: Container(
                        width: double.infinity,
             
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradinet,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppStyles.screenHorizontalPadding,
                              vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10.w,
                                children: [
                                  Expanded(
                                    child: GenericTranslateWidget( 
                                      "Locked Amount",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          context.textStyle.displayMedium?.copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.scaffoldColor,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(Assets.lockIcon),
                                //  const Spacer()
                                ],
                              ),
                              GenericTranslateWidget( 
                                "\$${double.tryParse(response.data!.balance.locked.toStringAsFixed(2))}",
                                style:
                                    context.textStyle.displayMedium?.copyWith(
                                  fontSize: 34.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.scaffoldColor,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10.w,
                                children: [
                                  Expanded(
                                    child: GenericTranslateWidget( 
                                      "This amount will become available for use after 03 days.",
                                      maxLines: 2,
                                      style:
                                          context.textStyle.bodyMedium?.copyWith(
                             
                                      
                                        color: AppColors.scaffoldColor,
                                      ),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ],
                          ),
                        )),
                ),
                Expanded(
                  child: Container(
                        width: double.infinity,
                     
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradinet,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppStyles.screenHorizontalPadding,
                              vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10.w,
                                children: [
                                  Expanded(
                                    child: GenericTranslateWidget( 
                                      "Refund Amount",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          context.textStyle.displayMedium?.copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.scaffoldColor,
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(Assets.refundIcon),
                                  // const Spacer()
                                ],
                              ),
                              GenericTranslateWidget( 
                                "\$${double.tryParse(response.data!.balance.refund.toStringAsFixed(2))}",
                                style:
                                    context.textStyle.displayMedium?.copyWith(
                                  fontSize: 34.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.scaffoldColor,
                                ),
                              ),
                               Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10.w,
                                children: [
                                  Expanded(
                                    child: GenericTranslateWidget( 
                                      "This amount can only be used to purchase other products.",
                                      maxLines: 2,
                                      style:
                                          context.textStyle.bodyMedium?.copyWith(
                             
                                      
                                        color: AppColors.scaffoldColor,
                                      ),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ],
                          ),
                        )),
                ),
             
             
              ],
            ),
            // Container(
            //   width: double.infinity,
             
            //   decoration: BoxDecoration(
            //     color: AppColors.scaffoldColor,
            //     borderRadius: BorderRadius.circular(20.r),
            //   ),
            //   child: Column(
            //     children: [
            //       Container(
            //           width: double.infinity,
            //           decoration: BoxDecoration(
            //             gradient: AppColors.primaryGradinet,
            //             borderRadius: BorderRadius.only(
            //                 topRight: Radius.circular(20.r),
            //                 topLeft: Radius.circular(20.r)),
            //           ),
            //           child: Padding(
            //             padding: EdgeInsets.symmetric(
            //                 horizontal: AppStyles.screenHorizontalPadding,
            //                 vertical: 16),
            //             child: Row(
            //               children: [
            //                 Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Row(
            //                       mainAxisSize: MainAxisSize.min,
            //                       children: [
            //                         GenericTranslateWidget( 
            //                           "Available Balance",
            //                           style:
            //                               context.textStyle.displayMedium?.copyWith(
            //                             fontSize: 18.sp,
            //                             fontWeight: FontWeight.w400,
            //                             color: AppColors.scaffoldColor,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     GenericTranslateWidget( 
            //                       "\$120.50",
            //                       style:
            //                           context.textStyle.displayMedium?.copyWith(
            //                         fontSize: 34.sp,
            //                         fontWeight: FontWeight.w700,
            //                         color: AppColors.scaffoldColor,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 const Spacer(),
            //                 SizedBox(
            //                     height: 42.h,
            //                     width: 119.w,
            //                     child: CustomButtonWidget(
            //                       title: "Deposit",
            //                       onPressed: () {
            //                         AppRouter.push(const SelectPaymetView());
            //                       },
            //                       color: AppColors.greyColor,
            //                       textColor: AppColors.lightIconColor,
            //                       child: Row(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.center,
            //                         children: [
            //                           GenericTranslateWidget( 
            //                             "Desposit",
            //                             style: context.textStyle.displayMedium!
            //                                 .copyWith(
            //                               height: 1.8,
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(bottom: 6.r),
            //                             child: Image.asset(Assets.walletIcon),
            //                           )
            //                         ],
            //                       ),
            //                     ))
            //               ],
            //             ),
            //           )),
            //       Padding(
            //         padding: EdgeInsets.symmetric(
            //           vertical: 10.r,
            //           horizontal: 20.r
            //         ),
            //         child: Row(
            //           children: [
            //             Expanded(
            //                 child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 GenericTranslateWidget( 
            //                   "Deposits",
            //                   style: context.textStyle.displayMedium?.copyWith(
            //                     fontSize: 14.sp,
            //                     fontWeight: FontWeight.w400,
            //                     color: AppColors.lightIconColor,
            //                   ),
            //                 ),
            //                 GenericTranslateWidget( 
            //                   "\$100.00",
            //                   style: context.textStyle.displayMedium?.copyWith(
            //                     fontSize: 18.sp,
            //                     fontWeight: FontWeight.w600,
            //                     color: AppColors.lightIconColor,
            //                   ),
            //                 ),
            //               ],
            //             )),
            //             Expanded(
            //                 child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 GenericTranslateWidget( 
            //                   "Refunds",
            //                   style: context.textStyle.displayMedium?.copyWith(
            //                     fontSize: 14.sp,
            //                     fontWeight: FontWeight.w400,
            //                     color: AppColors.lightIconColor,
            //                   ),
            //                 ),
            //                 GenericTranslateWidget( 
            //                   "\$20.00",
            //                   style: context.textStyle.displayMedium?.copyWith(
            //                     fontSize: 18.sp,
            //                     fontWeight: FontWeight.w600,
            //                     color: AppColors.lightIconColor,
            //                   ),
            //                 ),
            //               ],
            //             ))
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            
               
            GenericTranslateWidget( 
              "Recent Transactions",
              style: context.textStyle.displayMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            // ListView.separated(
            //        ,
            //         separatorBuilder: (context, index) => 10.ph,
            //         itemCount: DepositeDataModel.list.length)
          
            Expanded(
                child: AsyncStateHandler(
                  emptyMessage: "No any transaction found",
                  status: statusTransaction, dataList: list, itemBuilder:   (context, index) {
                      if(statusTransaction == Status.loadingMore && index == list.length){
                        return const Center(child: CircularProgressIndicator());
                      }
                      else{
                        final item = list[index];
                      return CustomDespositeWidget(
                          title: "${item.type} ${item.status}",
                          price: double.tryParse(item.amount.toStringAsFixed(2))!,
                          type: item.type);
                      }
                      
                    }, onRetry: (){
                      ref.read(cardProvider).getTransaction(cursor: null, limit: 10, type: "Withdraw");
        
                    }))
          ],
        ),
      ),
    )
    );
  }
}


