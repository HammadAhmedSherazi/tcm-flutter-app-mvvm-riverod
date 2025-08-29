import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class ChattingListView extends ConsumerStatefulWidget {
  const ChattingListView({super.key});

  @override
  ConsumerState<ChattingListView> createState() =>
      _ChattingListViewConsumerState();
}

class _ChattingListViewConsumerState extends ConsumerState<ChattingListView>
    with SingleTickerProviderStateMixin {
  late final ScrollController scrollController;
  late TabController tabController;
  @override
  void initState() {
    scrollController = ScrollController();
    tabController = TabController(length: 3, vsync: this);
    Future.microtask( () {
      ref
          .read(chatRepoProvider)
          .getChatList(limit: 10, cursor: null, type: "All");
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(chatRepoProvider).chatListCursor;
          Status status = ref.watch(chatRepoProvider).getChatMessageApiResponse.status;
          String tabType = getTabType(tabController.index);
          if (status != Status.loadingMore) {
            ref
                .read(chatRepoProvider)
                .getChatList(limit: 10, cursor: cursor, type: tabType);
          }
        });
      }
    });
    tabController.addListener(() {
      if (tabController.indexIsChanging) return; // Avoid unnecessary calls

      String tabType = getTabType(tabController.index);

      // Fetch new chat list based on selected tab
      ref
          .read(chatRepoProvider)
          .getChatList(limit: 10, cursor: null, type: tabType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(chatRepoProvider);
    final responseStatus = provider.getChatApiResponse.status;
    final list = responseStatus == Status.loading
        ? List.generate(
            5,
            (index) => ChatListDataModel(id: -1, lastmessagetext: ""),
          )
        : provider.chatList;

    return CommonScreenTemplateWidget(
      onRefresh: () async {
        ref
            .read(chatRepoProvider)
            .getChatList(limit: 10, cursor: null, type: "All");
      },
      leadingWidget: const CustomBackButtonWidget(),
      title: "All Messages",
      appBarHeight:  AppBar().preferredSize.height + 70.h,
      bottomAppbarWidget: CustomTabBarWidget(
        controller: tabController,
        tabs:  [

          Tab(text: Helper.getCachedTranslation(ref: ref, text: "All")),
          Tab(text: Helper.getCachedTranslation(ref: ref, text: "Seller")),
          Tab(text: Helper.getCachedTranslation(ref: ref, text: "Buyer")),
       
        ]) ,
      child: Column(
        children: [
          DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Expanded(
                child: responseStatus != Status.error
                    ? Skeletonizer(
                        enabled: responseStatus == Status.loading,
                        child: list.isNotEmpty
                            ? ListView.separated(
                                itemCount: responseStatus == Status.loadingMore
                                    ? list.length + 1
                                    : list.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        AppStyles.screenHorizontalPadding),
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  final ChatListDataModel? item =
                                      responseStatus == Status.loadingMore &&
                                              index == list.length
                                          ? null
                                          : list[index];
          
                                  return responseStatus == Status.loadingMore &&
                                          index == list.length
                                      ? const CustomLoadingWidget()
                                      : SizedBox(
                                          height: 100.h,
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0.0),
                                            onTap: () {
                                              AppRouter.push(
                                                  ChattingView(
                                                    isButtonEnable:
                                                        item.isMyProduct,
                                                    ad: item.product,
                                                    chatId: item.id,
                                                    user: item.user,
                                                  ), fun: () {
                                                ref
                                                    .read(chatRepoProvider)
                                                    .getChatList(
                                                        limit: 10,
                                                        cursor: null,
                                                        type: "All");
                                              });
                                            },
                                            visualDensity: const VisualDensity(
                                                horizontal: -4.0),
                                            horizontalTitleGap: 40.r,
                                            leading: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  child: DisplayNetworkImage(
                                                    width: 74.r,
                                                    height: 69.r,
                                                    imageUrl:
                                                        item!.product != null
                                                            ? item.product!
                                                                .productImage!
                                                            : "",
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -15,
                                                  right: -15,
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 26.r,
                                                      child: UserProfileWidget(
                                                        radius: 18.r,
                                                        imageUrl: item.user !=
                                                                null
                                                            ? item.user!.picture
                                                            : "",
                                                      )),
                                                )
                                              ],
                                            ),
                                            title: GenericTranslateWidget( 
                                              item.user?.userName ?? "",
                                              style: context
                                                  .textStyle.labelMedium!
                                                  .copyWith(fontSize: 16.sp, ),
                                              maxLines: 1,
                                            ),
                                            subtitle: item.isMedia!
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(
                                                        Icons.image,
                                                        color: item.isRead!? context
                                                            .colors.primary : null,
                                                      ),
                                                    ],
                                                  )
                                                : GenericTranslateWidget( 
                                                    item.lastmessagetext,
                                                    style:  item.isRead!? context
                                                        .textStyle.bodyMedium!.copyWith( 
                                                          fontWeight: FontWeight.bold
                                                        ): context
                                                        .textStyle.bodyMedium ,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 15.r,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                },
                              )
                            :const ShowEmptyItemDisplayWidget(
                                message: "No Chat List exits!"),
                      )
                    : CustomErrorWidget(onPressed: () {
                        ref
                            .read(chatRepoProvider)
                            .getChatList(limit: 10, cursor: null, type: "All");
                      })),
          ),
        ],
      ),
    );
  }
}

String getTabType(int index) {
  switch (index) {
    case 0:
      return "All";
    case 1:
      return "Sell";
    case 2:
      return "Buy";
    default:
      return "All";
  }
}
