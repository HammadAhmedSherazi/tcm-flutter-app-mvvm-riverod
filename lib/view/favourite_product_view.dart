import '../export_all.dart';
class FavouriteProductView extends ConsumerStatefulWidget {
  const FavouriteProductView({super.key});

  @override
  ConsumerState<FavouriteProductView> createState() => _MyWidgetConsumerState();
}

class _MyWidgetConsumerState extends ConsumerState<FavouriteProductView> {
  late final ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    Future.microtask(() {
    ref
          .read(productDataProvider)
          .getFavouriteProductList(limit: 15, cursor: null);
  });
    // Future.delayed(Duration.zero, () {
      
    // });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(productDataProvider).favouriteListCursor;

          ref
              .read(productDataProvider)
              .getFavouriteProductList(limit: 15, cursor: cursor);
                });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final status = provider.favouriteProductApiResponse.status;
    final isLoad = status == Status.loading;
    final items = ref.watch(productDataProvider).favouriteProducts;
    final products =
        isLoad ? provider.loadingProduct : provider.favouriteProducts;
    return CommonScreenTemplateWidget(
        title: "Favourite Products  ",
        leadingWidget: const CustomBackButtonWidget(),
        onRefresh: () async {
          ref
              .read(productDataProvider)
              .getFavouriteProductList(limit: 15, cursor: null);
        },
        child: status == Status.error
            ? Center(
                child: CustomErrorWidget(
                  onPressed: () {
                    ref
                        .read(productDataProvider)
                        .getFavouriteProductList(limit: 15, cursor: null);
                  },
                ),
              )
            : status == Status.completed && items.isEmpty
                ? const ShowEmptyItemDisplayWidget(message: "No Product Found!")
                : VerticalProjectsDisplayLayoutWidget(
                    temp: products,
                    isLoad: isLoad,
                    keyString: "",
                    isFavourite: true,
                    fun: (){
                      ref
                        .read(productDataProvider)
                        .getFavouriteProductList(limit: 15, cursor: null);
                    },
                    isLoadMore: status == Status.loadingMore,
                  ));
  }
}
