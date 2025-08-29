import '../export_all.dart';
class FilterCategoryView extends ConsumerStatefulWidget {
  final CategoryDataModel ?category;
  const FilterCategoryView({super.key, required this.category});

  @override
  ConsumerState<FilterCategoryView> createState() =>
      _FilterCategoryViewConsumerState();
}

class _FilterCategoryViewConsumerState
    extends ConsumerState<FilterCategoryView> {
//  late final ScrollController scrollController ;
  @override
  void initState() {
    // scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      ref
          .read(productDataProvider)
          .getAllCategories(limit: 15, cursor: null, id: widget.category?.id);
    });
    // scrollController.addListener(() {
    //   if (scrollController.position.pixels ==
    //       scrollController.position.maxScrollExtent) {
    //     Future.delayed(Duration.zero, () {
    //       String? cursor = ref.watch(productDataProvider).categoryCurson ?? "";
    //       if (cursor != "") {
    //         ref
    //             .read(productDataProvider)
    //             .getAllCategories(limit: 4, cursor: cursor, id: null);
    //       }
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return CommonScreenTemplateWidget(
        title: widget.category != null ?  "Filter" : "Select Category",
        leadingWidget: const CustomBackButtonWidget(),
        child: BuySellScreenTemplateWidget(
          title: widget.category != null ? widget.category!.title : "All Categories",
          isBuy: false,
          id: widget.category?.id,
          isFilter: true,
        ));
  }
}
