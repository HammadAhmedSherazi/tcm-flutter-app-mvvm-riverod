import '../export_all.dart';

class CustomNotificationBadgetWidget extends ConsumerWidget {
  const CustomNotificationBadgetWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(chatRepoProvider).notificationCount;
    return CustomBadgeWidget(
      showBadge: count > 0,
      count: count,
      child: CustomMenuIconShape(
          icon: Assets.notificationIcon,
          onTap: () {
            AppRouter.push(const NotificationView());
          }),
    );
  }
}
