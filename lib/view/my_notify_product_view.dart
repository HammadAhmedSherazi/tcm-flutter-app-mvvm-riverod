import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class MyNotifyProductView extends ConsumerStatefulWidget {
  const MyNotifyProductView({super.key});

  @override
  ConsumerState<MyNotifyProductView> createState() =>
      _MyNotifyProductViewConsumerState();
}

class _MyNotifyProductViewConsumerState
    extends ConsumerState<MyNotifyProductView>
    with SingleTickerProviderStateMixin {
  late final ScrollController? scrollController;
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    tabController.addListener(() {
      // final provider = ref.watch(productDataProvider);
    });
    scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      ref
          .read(productDataProvider)
          .getNotifyCategoryList(limit: 10, cursor: null);
    });
    scrollController?.addListener(() {
      if (scrollController?.position.pixels ==
          scrollController?.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(productDataProvider).adProuctCursor;

          ref
              .read(productDataProvider)
              .getNotifyCategoryList(limit: 5, cursor: cursor);
                });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoad = ref.watch(productDataProvider).notifyListApiResponse.status;
    final items = ref.watch(productDataProvider).myNotfiyList;
    return CommonScreenTemplateWidget(
        title: "Notify Products",
        leadingWidget: const CustomBackButtonWidget(),
        appBarHeight:  AppBar().preferredSize.height + 70.h,
        bottomAppbarWidget:
            CustomTabBarWidget(controller: tabController, tabs:  [
              Tab(text: Helper.getCachedTranslation(ref: ref, text: "To be list")),
                Tab(text: Helper.getCachedTranslation(ref: ref, text: "Listed")),
          
        ]),
        onRefresh: () async {
          ref
              .read(productDataProvider)
              .getNotifyCategoryList(limit: 10, cursor: null);
        },
        child: TabBarView(controller: tabController, children: [
          NotifyCardList(
              isLoad: isLoad,
              items: items,
              ref: ref,
              fun: () {
                ref
                    .read(productDataProvider)
                    .getNotifyCategoryList(limit: 10, cursor: null);
              },
              scrollController: scrollController),
          ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              padding: EdgeInsets.only(
                  top: AppStyles.screenHorizontalPadding,
                  left: AppStyles.screenHorizontalPadding,
                  right: AppStyles.screenHorizontalPadding,
                  bottom: 30.r),
              itemBuilder: (context, index) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: UserProfileWidget(radius: 28.r, imageUrl: "gshg"),
                    title: GenericTranslateWidget( "Blue Neck Towel has been listed", style: context.textStyle.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black,),
                  ),
              separatorBuilder: (context, index) => 10.ph,
              itemCount: 5)
        ]));
  }
}

class NotifyCardWidget extends StatelessWidget {
  final AdDataModel item;
  final int index;
  final void Function()? onEditTap;
  const NotifyCardWidget({
    super.key,
    required this.item,
    required this.index,
    required this.onEditTap

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120.h,
      padding: EdgeInsets.only(
        top: 20.r,
        bottom: 20.r,
        left: 30.r,
        right: 20.r,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58.r,
            height: 58.r,
            padding: EdgeInsets.all(13.r),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(22, 143, 214, 0.16),
                shape: BoxShape.circle),
            child: const CustomIconWidget(icon: Assets.boxIcon),
          ),
          10.pw,
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GenericTranslateWidget( 
                "Category",
                style: context.textStyle.displayMedium!.copyWith(
                    fontSize: 18.sp,
                    foreground: Paint()
                      ..shader = AppColors.primaryGradinet
                          .createShader(const Rect.fromLTWH(0, 0, 200, 70))),
              ),
              GenericTranslateWidget( 
                item.category.map((c) => c.title).join(', '),
                style:
                    context.textStyle.displayMedium!.copyWith(fontSize: 16.sp),
              ),
              GenericTranslateWidget( 
                "${item.location.placeName} ${item.location.cityName} ${item.location.state}, ${item.location.country}" * 2,
                maxLines: 2,
                style: context.textStyle.bodyMedium!.copyWith(
                    fontSize: 15.sp,
                    overflow: TextOverflow.ellipsis,
                    color: const Color.fromRGBO(38, 43, 67, 0.7)),
              )
            ],
          )),
          IconButton(
              padding: EdgeInsets.zero,
              visualDensity:
                  const VisualDensity(vertical: -4.0, horizontal: -4.0),
              onPressed: onEditTap,
              icon: SvgPicture.asset(Assets.editIcon)),
          10.pw,
          IconButton(
              padding: EdgeInsets.zero,
              visualDensity:
                  const VisualDensity(vertical: -4.0, horizontal: -4.0),
              onPressed: () {
                 showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.r)),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              AppRouter.back();
                                                            },
                                                            child: GenericTranslateWidget( 
                                                              "No",
                                                              style: context
                                                                  .textStyle
                                                                  .displayMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18.sp),
                                                            ),
                                                          ),
                                                          Consumer(
                                                            builder: (_,
                                                                WidgetRef ref,
                                                                __) {
                                                              final isLoad = ref
                                                                  .watch(
                                                                      productDataProvider)
                                                                  .deleteAdApiResponse
                                                                  .status;
                                                              return isLoad ==
                                                                      Status
                                                                          .loading
                                                                  ? const CircularProgressIndicator()
                                                                  : TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        ref.read(productDataProvider).deleteNotifyAd(
                                                                            id: item
                                                                                .id,
                                                                            index:
                                                                                index);
                                                                      },
                                                                      child:
                                                                          GenericTranslateWidget( 
                                                                        "Yes",
                                                                        style: context
                                                                            .textStyle
                                                                            .displayMedium!
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
                                                                "Are you sure to delete?",
                                                                style: context
                                                                    .textStyle
                                                                    .displayMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            20.sp),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
              },
              icon: SvgPicture.asset(Assets.deleteIcon2)),
        ],
      ),
    );
  }
}

class NotifyCardList extends StatelessWidget {
  final Status isLoad;
  final List<AdDataModel> items;
  final ScrollController? scrollController;
  final Function fun;
  final WidgetRef ref;
  const NotifyCardList(
      {super.key,
      required this.isLoad,
      required this.items,
      required this.fun,
      required this.ref,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return isLoad == Status.loading
        ? const Center(child: CustomLoadingWidget())
        : isLoad == Status.error
            ? Center(
                child: CustomErrorWidget(
                  onPressed: () {
                    fun();
                  },
                ),
              )
            : items.isEmpty
                ? const ShowEmptyItemDisplayWidget(
                    message: "No Notify Product exits!")
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    padding: EdgeInsets.only(
                        top: AppStyles.screenHorizontalPadding,
                        left: AppStyles.screenHorizontalPadding,
                        right: AppStyles.screenHorizontalPadding,
                        bottom: 30.r),
                    itemBuilder: (context, index) {
                      final ad = items[index];
                      return isLoad == Status.loadingMore &&
                              index == items.length
                          ? const CustomLoadingWidget()
                          : NotifyCardWidget(item: ad, index: index, onEditTap: (){
                            ref.read(productDataProvider).setNotfiyId(ad.id);
                            AppRouter.push(const BuyProductView(isEdit: true,), fun: (){
                              fun();
                            });
                          },);
                    },
                    separatorBuilder: (context, index) => 20.ph,
                    itemCount: isLoad == Status.loadingMore
                        ? items.length + 1
                        : items.length);
  }
}
