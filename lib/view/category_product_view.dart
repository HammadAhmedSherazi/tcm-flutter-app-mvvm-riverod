import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class CategoryProductView extends ConsumerStatefulWidget {
  final CategoryDataModel? category;
  final int index;
  const CategoryProductView(
      {super.key, required this.category, required this.index});

  @override
  ConsumerState<CategoryProductView> createState() =>
      _CategoryProductViewConsumerState();
}

class _CategoryProductViewConsumerState
    extends ConsumerState<CategoryProductView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late ScrollController scrollController;

  final searchTextEditController = TextEditingController();
  @override
  void initState() {
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: widget.index > 0 ? widget.index - 1 : widget.index);
    tabController.addListener(() {
      final provider = ref.watch(productDataProvider);
      if(!tabController.indexIsChanging){
        if (provider.seeAllAdsApiResponse.status != Status.loading) {
        final loc = ref.watch(currentLocationProvider).currentLocation;
        final id = provider.lastSelectedCategory == null
            ? widget.category?.id
            : provider.lastSelectedCategory!.id;
        Future.delayed(const Duration(milliseconds: 200), () {
          fetchProducts(
            loc,
            searchTextEditController.text.isEmpty
                ? null
                : searchTextEditController.text,
            setType2(tabController.index),
            null,
            id,
          );
        });
      }
      }
      
      

      
    });
    scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      ref.read(productDataProvider.notifier).unsetCategory();
      if (widget.category != null) {
        ref.read(productDataProvider).setCategory(widget.category!);
      }
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.read(productDataProvider).seeAllAdCursor;

          final loc = ref.watch(currentLocationProvider).currentLocation;
          final provider = ref.watch(productDataProvider);
          final id = provider.lastSelectedCategory == null
              ? widget.category?.id
              : provider.lastSelectedCategory!.id;
          fetchProducts(
              loc,
              searchTextEditController.text == ""
                  ? null
                  : searchTextEditController.text,
              setType2(tabController.index),
              cursor,
              id);
                });
      }
    });
    super.initState();
  }

  void fetchProducts(LocationData loc, String? searchText, String type,
      String? cursor, int? categoryId) {
    ref.read(productDataProvider).getSeeAllAds(
        categoryId: categoryId,
        limit: 10,
        lat: loc.lat,
        long: loc.lon,
        cursor: cursor,
        searchText: searchText,
        type: type,
        under10: false,
        vanish: false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final languageCode = ref.watch(languageChangeNotifierProvider).currentLanguage.code;
    final bool isRTL = languageCode == "ar";
    final response = provider.seeAllAdsApiResponse;
    final id = provider.lastSelectedCategory == null
        ? widget.category?.id
        : provider.lastSelectedCategory!.id;
    final isLoad = response.status == Status.loading ||
        response.status == Status.undertermined;
    final products = isLoad
        ? List.generate(
            6,
            (index) => ProductDataModel(
                id: 21,
                productName: "hsgahjgdhjasgd",
                productImage: "afdhjafhjafjhdasfdhj",
                productPrice: 10,
                categoryId: -1,
                status: "ashjkah"),
          )
        : provider.seeAllProducts;
    final loc = ref.watch(currentLocationProvider).currentLocation;
    if (response.status == Status.undertermined &&
        searchTextEditController.text == "" && response.status != Status.loading) {
      appLog("Run Api 2");
      Future.delayed(Duration.zero, () {
        fetchProducts(loc, null, setType2(tabController.index), null, id);
      });
    }

    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(Assets.homeBackgroundImage),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(140.h),
            child: Stack(
              children: [
                Container(
                  // height: 380.h,
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyles.screenHorizontalPadding),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(widget.index == 0
                              ? Assets.beachViewImage
                              : widget.index == 1
                                  ? Assets.marketTopViewImage
                                  : Assets.venderTopViewImage),
                          fit: BoxFit.cover)),
                ),
                Container(
                  // height: 380.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00F9F9F9),
                        Color(0xFFF9F9F9), // #F9F9F9 (solid white)
                        // rgba(249, 249, 249, 0) (fully transparent white)
                      ],
                      stops: [0.0, 0.9], // Gradient stops for each color
                    ),
                  ),
                ),
                Container(
                  height: 380.h,
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyles.screenHorizontalPadding),
                  child: Column(
                    children: [
                      50.ph,
                      Row(
                        children: [
                          CustomBackButtonWidget(
                            size: 60.r,
                          ),
                          10.pw,
                          Expanded(
                            child: CustomSearchBarWidget(
                              isArabic: isRTL,
                                controller: searchTextEditController,
                                onChanged: (text) {
                                  if (text.length >= 2) {
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      fetchProducts(
                                          loc,
                                          text,
                                          setType2(tabController.index),
                                          null,
                                          id);
                                    });
                                  } else if (text == "") {
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      fetchProducts(
                                          loc,
                                          null,
                                          setType2(tabController.index),
                                          null,
                                          id);
                                    });
                                  }
                                },
                                hintText: Helper.getCachedTranslation(ref: ref, text: "Search product")),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          if (provider.selectedCategory != null)
                            GestureDetector(
                              onTap: () {
                                if (widget.category == null) {
                                  AppRouter.push(
                                      const FilterCategoryView(
                                        category: null,
                                      ), fun: () {
                                    if (provider.selectedCategory != null) {
                                      fetchProducts(
                                          loc,
                                          null,
                                          setType2(tabController.index),
                                          null,
                                          provider.selectedCategory!.id);
                                    }
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 41.h,
                                    decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradinet,
                                        borderRadius:
                                            BorderRadius.circular(5000.r)),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(5000.r),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            left: -4,
                                            bottom: -2,
                                            child: ClipRRect(
                                              clipBehavior: Clip.none,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(500.r)),
                                              child: DisplayNetworkImage(
                                                imageUrl: provider
                                                    .selectedCategory!.imageUrl,
                                                width: 70.r,
                                                height: 40.r,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: isRTL ?[
                                              10.pw,
                                              GenericTranslateWidget( 
                                                provider.lastSelectedCategory ==
                                                        null
                                                    ? provider
                                                        .selectedCategory!.title
                                                    : "${provider.selectedCategory!.title}: ${provider.lastSelectedCategory!.title}",
                                                style: context
                                                    .textStyle.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                              65.pw
                                            ] : [
                                              65.pw,
                                              GenericTranslateWidget( 
                                                provider.lastSelectedCategory ==
                                                        null
                                                    ? provider
                                                        .selectedCategory!.title
                                                    : "${provider.selectedCategory!.title}: ${provider.lastSelectedCategory!.title}",
                                                style: context
                                                    .textStyle.bodyMedium!
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                              10.pw
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (provider.selectedCategory == null) ...[
                            GestureDetector(
                              onTap: () {
                                AppRouter.push(
                                    FilterCategoryView(
                                      category: provider.selectedCategory,
                                    ), fun: () {
                                  if (provider.lastSelectedCategory != null) {
                                    fetchProducts(
                                        loc,
                                        null,
                                        setType2(tabController.index),
                                        null,
                                        provider.lastSelectedCategory!.id);
                                  }
                                });
                              },
                              child: Container(
                                height: 40.h,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 20.r),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: AppColors.borderColor),
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(30.r),
                                        right: Radius.circular(30.r))),
                                child: GenericTranslateWidget( 
                                  "Select Category",
                                  style: context.textStyle.displayMedium,
                                ),
                              ),
                            )
                          ],
                          const Spacer(),
                          if (provider.selectedCategory != null &&
                              !provider.selectedCategory!.isFinal)
                            CustomMenuIconShape(
                                icon: Assets.filterIcon,
                                onTap: () {
                                  AppRouter.push(
                                      FilterCategoryView(
                                        category: provider.selectedCategory,
                                      ), fun: () {
                                    if (provider.lastSelectedCategory != null) {
                                      fetchProducts(
                                          loc,
                                          null,
                                          setType2(tabController.index),
                                          null,
                                          provider.lastSelectedCategory!.id);
                                    }
                                  });
                                })
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )),
        body: Column(
          children: [
            if (widget.index == 0)
              CustomTabBarWidget(
                tabs:  [
                  Tab(text: Helper.getCachedTranslation(ref: ref, text: "Pre-Owned")),
                  Tab(text: Helper.getCachedTranslation(ref: ref, text: "Vendor") ),
                ],
                controller: tabController,
              ),
            10.ph,
            Expanded(
                child: response.status == Status.error
                    ? CustomErrorWidget(onPressed: () {
                        searchTextEditController.clear();
                        fetchProducts(
                            loc, null, setType2(tabController.index), null, id);
                      })
                    : response.status == Status.completed && products.isEmpty
                        ? const ShowEmptyItemDisplayWidget(
                            message: "No Products Exits!")
                        : VerticalProjectsDisplayLayoutWidget(
                            temp: products,
                            isLoad: isLoad,
                            keyString: "",
                            physics: const AlwaysScrollableScrollPhysics(),
                            isLoadMore: response.status == Status.loadingMore,
                          )),
          ],
        ),
      ),
    );
  }
}

String setType2(int index) {
  if (index == 0) {
    return "Ad";
  } else {
    return "Store";
  }
}
