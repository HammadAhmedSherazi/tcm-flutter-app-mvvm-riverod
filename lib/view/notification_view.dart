import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class NotificationView extends ConsumerStatefulWidget {
  const NotificationView({super.key});

  @override
  ConsumerState<NotificationView> createState() =>
      _NotificationViewConsumerState();
}

class _NotificationViewConsumerState extends ConsumerState<NotificationView> {
  late final ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();

    Future.delayed(Duration.zero, () {
      ref.read(chatRepoProvider).getNotifications(limit: 15, cursor: null);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(chatRepoProvider).notificationCursor;

          ref
              .read(chatRepoProvider)
              .getNotifications(limit: 10, cursor: cursor);
                });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final status =
        ref.watch(chatRepoProvider).getNotificationApiResponse.status;

    final isLoad = status == Status.loading;
    final data = isLoad
        ? List.generate(
            5,
            (index) => NotificationDataModel(
                title: "fagsdfgshaf", createdAt: DateTime.now()),
          )
        : ref.watch(chatRepoProvider).notifications;
    return CommonScreenTemplateWidget(
        title: "Notifications",
        onRefresh: () async {
          ref.read(chatRepoProvider).getNotifications(limit: 15, cursor: null);
        },
        leadingWidget: const CustomBackButtonWidget(),
        child: status == Status.error
            ? CustomErrorWidget(onPressed: () {
                ref
                    .read(chatRepoProvider)
                    .getNotifications(limit: 15, cursor: null);
              })
            : Skeletonizer(
                enabled: isLoad,
                child: data.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppStyles.screenHorizontalPadding),
                        itemCount: status == Status.loadingMore
                            ? data.length + 1
                            : data.length,
                        itemBuilder: (context, index) {
                          if (status == Status.loadingMore &&
                              index == data.length) {
                            return const CustomLoadingWidget();
                          } else {
                            final item = data[index];

                            // Convert createdAt String to DateTime
                            DateTime currentDate = item.createdAt;

                            // Get previous date (if exists)
                            DateTime? previousDate =
                                index > 0 ? data[index - 1].createdAt : null;

                            // Show date header if it's the first item or a new day
                            bool showDateHeader = currentDate.day != previousDate!.day ||
                                currentDate.month != previousDate.month ||
                                currentDate.year != previousDate.year;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showDateHeader) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5),
                                    child: GenericTranslateWidget( 
                                      Helper.formatDate(currentDate) != "Today"
                                          ? "Old Notifications"
                                          : "Today",
                                      style: context.textStyle.displayMedium!
                                          .copyWith(fontSize: 16.sp),
                                    ),
                                  ),
                                ],
                                NotificationTitleWidget(data: item)
                              ],
                            );
                          }
                        },
                      )
                    : const ShowEmptyItemDisplayWidget(
                        message: "No notification exits!")));
  }
}

class NotificationTitleWidget extends StatelessWidget {
  final NotificationDataModel data;
  const NotificationTitleWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (data.data?['type'] == "ads_notification") {
          AppRouter.push(ProductDetailView(
              productId: data.data?['id'],
              categoryId: data.data?['category_id']));
        }
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0.0,
      ),
      visualDensity: const VisualDensity(horizontal: -4.0),
      // minLeadingWidth: 200.w,
      // minTileHeight: 10.h,
      minVerticalPadding: 13.r,
      leading: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          UserProfileWidget(
              radius: 38.r,
              imageUrl: "${BaseApiServices.imageURL}${data.data?['image']}"),
          if (data.isNew)
            Positioned(
                top: -7,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.r),
                  decoration: BoxDecoration(
                      color: context.colors.primary,
                      borderRadius: BorderRadius.circular(4.r)),
                  child: GenericTranslateWidget( 
                    "New",
                    style: context.textStyle.bodySmall!
                        .copyWith(height: 1.1, color: Colors.white),
                  ),
                )),
          // if (data.isPostNotification!)
          //   Positioned(
          //     bottom: -3,
          //     right: -5,
          //     child: CircleAvatar(
          //         backgroundColor: Colors.white,
          //         radius: 20.r,
          //         child: UserProfileWidget(
          //             radius: 15.r, imageUrl: data.userImageUrl!)),
          //   )
        ],
      ),
      title: CustomHTMLViewer(data: data.title),
      // GenericTranslateWidget( 
      //   data.title,
      //   style: context.textStyle.bodyMedium!.copyWith(height: 1.1),
      // ),
      subtitle: GenericTranslateWidget( 
        data.createdAt.timeAgo(),
        style: context.textStyle.bodySmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: data.isNew
                ? AppColors.primaryColor
                : Colors.black.withValues(alpha: 0.7),
            wordSpacing: 1.4),
      ),
      // trailing: IconButton(
      //   visualDensity: const VisualDensity(horizontal: -4.0),
      //   onPressed: () {},
      //   icon: const Icon(
      //     Icons.more_horiz,
      //     color: Colors.black,
      //   ),
      //   padding: EdgeInsets.zero,
      // ),
    );
  }
}


extension on DateTime {
  String timeAgo() {
    DateTime now = DateTime.now();

    Duration diff = now.difference(this);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hr ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} weeks ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} month ago';
    } else {
      return '${(diff.inDays / 365).floor()} year ago';
    }
  }
}