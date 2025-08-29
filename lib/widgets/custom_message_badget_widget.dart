import '../export_all.dart';

class CustomMessageBadgetWidget extends ConsumerWidget{
  const CustomMessageBadgetWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(chatRepoProvider).chatCount;
                        return CustomBadgeWidget(
                          showBadge: count > 0,
                          count: count,
                          child: CustomMenuIconShape(
                              icon: Assets.messageicon,
                              onTap: () {
                                AppRouter.push(const ChattingListView());
                              }),
                        );
  }
}