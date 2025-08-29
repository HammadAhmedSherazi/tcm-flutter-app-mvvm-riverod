import '../export_all.dart';

class MyOrderView extends ConsumerStatefulWidget {
  const MyOrderView({super.key});

  @override
  ConsumerState<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends ConsumerState<MyOrderView>
    with SingleTickerProviderStateMixin {
  
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {});
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
      appBarHeight: AppBar().preferredSize.height + 70.h,
      bottomAppbarWidget: CustomTabBarWidget(
        controller: tabController,
        tabs: [
          Tab(text: Helper.getCachedTranslation(ref: ref, text: "Store")),
          Tab(text: Helper.getCachedTranslation(ref: ref, text: "Ad")),
        ],
      ),
      leadingWidget: const CustomBackButtonWidget(),
      title: "My Order",
      child: TabBarView(
        controller: tabController,
        children: const [
          StoreOrderView(),
          AdOrderView(),
        ],
      ),
    );
  }
}
