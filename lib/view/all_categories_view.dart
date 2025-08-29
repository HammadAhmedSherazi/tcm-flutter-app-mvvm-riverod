

import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class AllCategoriesView extends ConsumerStatefulWidget {
  const AllCategoriesView({super.key});

  @override
  ConsumerState<AllCategoriesView> createState() =>
      _AllCategoriesViewConsumerState();
}

class _AllCategoriesViewConsumerState extends ConsumerState<AllCategoriesView> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ref
          .read(productDataProvider)
          .getAllCategories(limit: 15, cursor: null, id: null);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(productDataProvider).categoryCurson ?? "";
          if (cursor != "") {
            ref
                .read(productDataProvider)
                .getAllCategories(limit: 4, cursor: cursor, id: null);
          }
        });
      }
    });
  }

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isLoad = ref.watch(productDataProvider).categoryApiResponse.status;
    final items = ref.watch(productDataProvider).allCategories;
    return CommonScreenTemplateWidget(
        title: "Categories",
        leadingWidget: const CustomBackButtonWidget(),
        child: 
        isLoad == Status.loading
            ? const Center(child: CustomLoadingWidget())
            : isLoad == Status.error
                ? Center(
                    child: CustomErrorWidget(
                      onPressed: () {
                        ref.read(productDataProvider).getAllCategories(
                            limit: 15, cursor: null, id: null);
                      },
                    ),
                  )
                : items.isEmpty
                    ? const ShowEmptyItemDisplayWidget(
                        message: "No Category exists!")
                    : 
                    ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppStyles.screenHorizontalPadding),
                        itemBuilder: (context, index) {
                          return isLoad == Status.loadingMore &&
                                  index == items.length
                              ? const CustomLoadingWidget()
                              : ProductCategoryTitleWidget(
                                  showLeadWidget: true,
                                  title: items[index].title,
                                  onTap: () {
                                    AppRouter.push(
                                        CategoryProductView(category: items[index],index: 0,), fun: () {
                                       ref
          .read(productDataProvider)
          .getAllCategories(limit: 15, cursor: null, id: null);
                                    });
                                  },
                                  imageUrl: items[index].imageUrl,
                                );
                        },
                        separatorBuilder: (context, index) => 15.ph,
                        itemCount: isLoad == Status.loadingMore
                            ? items.length + 1
                            : items.length)
                            );
  }
}
