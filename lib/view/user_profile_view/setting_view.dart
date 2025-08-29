import 'package:tcm/utils/app_extensions.dart';

import '../../export_all.dart';


class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepoProvider).userData;

    // List of items for the profile screen
    final List<Map<String, dynamic>> profileItems = [
      {
        "icon": Assets.wallet,
        "title": "Wallet",
        "onTap": () {
          AppRouter.push(const WalletView());
        },
        "color": AppColors.lightIconColor
      },
      {
        "icon": Assets.buyProfile,
        "title": "My Order",
        "onTap": () {
          AppRouter.push(const MyOrderView());
        },
        "color": AppColors.lightIconColor,
      },
      {
        "icon": Assets.arrowStrip,
        "title": "My Refund Products",
        "onTap": () {
          AppRouter.push(const MyRefundView());
        },
        "color": AppColors.lightIconColor,
      },
      {
        "icon": Assets.alignRight,
        "title": "My Notes",
        "onTap": () {
          AppRouter.push(const MyNotesView());
        },
        "color": AppColors.lightIconColor,
      },
      {
        "icon": Assets.alignRight,
        "title": "My Ads",
        "onTap": () {
          AppRouter.push(const MyAdView());
        },
        "color": AppColors.lightIconColor,
      },
      {
        "icon": Assets.alignRight,
        "title": "My Reviews",
        "onTap": () {
          AppRouter.push(const MyReviewsView());
        },
        "color": AppColors.lightIconColor,
      },
      {
        "icon": Assets.favouriteIcon,
        "title": "Favourite Products",
        "onTap": () {
          AppRouter.push(const FavouriteProductView());
        },
        "color": AppColors.lightIconColor,
      },
      {
        "icon": Assets.volumeHigh,
        "title": "Notify Products",
        "onTap": () {
          AppRouter.push(const MyNotifyProductView());
        },
        "color": AppColors.lightIconColor,
      },
      {
        "icon": Assets.notificationIcon,
        "title": "Notification",
        "onTap": () {},
        "color": AppColors.lightIconColor,
      },
      {
        "icon": Assets.logout,
        "title": "Log Out",
        "onTap": () {
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
                    final isLoad =
                        ref.watch(authRepoProvider).logoutApiResponse.status;
                    return isLoad == Status.loading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: () {
                              ref.read(authRepoProvider).logout();
                              ref.read(chatRepoProvider).setResponse();
                              ref.read(chatRepoProvider).listenDispose();
                              // ref.read(communityRepoProvider).dispose();
                            },
                            child: GenericTranslateWidget( 
                              "Yes",
                              style: context.textStyle.displayMedium!
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
                      "Are you sure you want to logout?",
                      style: context.textStyle.displayMedium!
                          .copyWith(fontSize: 20.sp),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        "color": Colors.red,
      },
    ];

    final screenHeight = MediaQuery.of(context).size.height;
    return CommonScreenTemplateWidget(
      title: "More",
      leadingWidget: const CustomBackButtonWidget(),
      appBarHeight: 120.h,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.05),

          // borderRadius: const BorderRadius.only(
          //     topLeft: Radius.circular(40), topRight: Radius.circular(40)
          // )
          borderRadius: const BorderRadius.only(
              topLeft: Radius.elliptical(200, 50),
              topRight: Radius.elliptical(200, 50)),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
                top: screenHeight * -0.85,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                    child: UserProfileWidget(
                        radius: 40, imageUrl: user?.picture ?? ''))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                50.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text( 
                      "${user?.userName}",
                      style: context.textStyle.displayMedium
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    8.pw,
                    GestureDetector(
                        onTap: () {
                          AppRouter.push(const EditProfileView());
                        },
                        child: SvgPicture.asset(Assets.editIcon))
                  ],
                ),
                Center(
                  child: GenericTranslateWidget( 
                    user?.email ?? "",
                    style: context.textStyle.displayMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightIconColor.withValues(alpha: 0.7)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GenericTranslateWidget( 
                    "My Account",
                    style: context.textStyle.displayMedium?.copyWith(
                        fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: profileItems.length,
                    itemBuilder: (context, index) {
                      final item = index != profileItems.length
                          ? profileItems[index]
                          : null;
                      return
                          // index == profileItems.length
                          //     ? ListTile(
                          //         title: GenericTranslateWidget( 
                          //           "Staging",
                          //           style: context.textStyle.displayMedium!
                          //               .copyWith(fontSize: 18.sp),
                          //         ),
                          //         trailing: Consumer(
                          //           builder: (_, WidgetRef ref, __) {
                          //             final isCheck =
                          //                 ref.watch(authRepoProvider).isStaging;
                          //             return Switch(
                          //                 activeColor: context.colors.primary,
                          //                 value: isCheck,
                          //                 onChanged: (c) {
                          //                   ref
                          //                       .read(authRepoProvider)
                          //                       .toggleStaging(isCheck);
                          //                 });
                          //           },
                          //         ),
                          //       )
                          //     :
                          CustomProfileScreenWidget(
                        icon: item!['icon'],
                        title: item['title'],
                        onTap: item['onTap'],
                        color: item['color'],
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
