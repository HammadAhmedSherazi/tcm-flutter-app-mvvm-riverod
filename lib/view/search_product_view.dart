import 'package:tcm/export_all.dart';
import 'package:tcm/utils/app_extensions.dart';

class SearchProductView extends ConsumerStatefulWidget {
  final String title;

  final int? categoryId;
  final bool? under10;
  final bool? isVanish;
  final String type;
  const SearchProductView(
      {super.key,
      required this.title,
      required this.type,
      this.categoryId,
      this.isVanish,
      this.under10});

  @override
  ConsumerState<SearchProductView> createState() =>
      _SearchProductViewConsumerState();
}

class _SearchProductViewConsumerState extends ConsumerState<SearchProductView> {
  final searchTextEditController = TextEditingController();
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();

    Future.delayed(Duration.zero, () {
      ref.read(chatRepoProvider).setResponse();
      ref.read(productDataProvider).setSeeAllProductResponse();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(productDataProvider).seeAllAdCursor;
          final loc = ref.watch(currentLocationProvider).currentLocation;

          ref.read(productDataProvider).getSeeAllAds(
              categoryId: widget.categoryId,
              limit: 10,
              lat: loc.lat,
              long: loc.lon,
              cursor: cursor,
              type: widget.type,
              searchText: searchTextEditController.text != ""
                  ? searchTextEditController.text
                  : null,
              under10: widget.under10,
              vanish: widget.isVanish);
                });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final response = provider.seeAllAdsApiResponse;
    final languageCode = ref.watch(languageChangeNotifierProvider).currentLanguage.code;
   
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
        searchTextEditController.text == "") {
      Future.delayed(Duration.zero, () {
        ref.read(productDataProvider).getSeeAllAds(
            categoryId: widget.categoryId,
            limit: 10,
            lat: loc.lat,
            long: loc.lon,
            cursor: null,
            searchText: null,
            type: widget.type,
            under10: widget.under10,
            vanish: widget.isVanish);
      });
    }

    return CommonScreenTemplateWidget(
      title: widget.title,
      leadingWidget: const CustomBackButtonWidget(),
      appBarHeight: 100.h,
      onRefresh: () async {
        ref.read(productDataProvider).getSeeAllAds(
            categoryId: widget.categoryId,
            limit: 10,
            lat: loc.lat,
            long: loc.lon,
            cursor: null,
            searchText: null,
            type: widget.type,
            under10: widget.under10,
            vanish: widget.isVanish);
      },
      actionWidget: const CustomMessageBadgetWidget(),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: AppStyles.screenHorizontalPadding,
                right: AppStyles.screenHorizontalPadding,
                bottom: 30.r),
            child: CustomSearchBarWidget(
                controller: searchTextEditController,
                isArabic: languageCode == "ar",
                onChanged: (text) {
                  if (text.length >= 2) {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      ref.read(productDataProvider).getSeeAllAds(
                          categoryId: widget.categoryId,
                          limit: 10,
                          lat: loc.lat,
                          long: loc.lon,
                          cursor: null,
                          searchText: text,
                          type: widget.type,
                          under10: widget.under10,
                          vanish: widget.isVanish);
                    });
                  } else if (text == "") {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      ref.read(productDataProvider).getSeeAllAds(
                          categoryId: widget.categoryId,
                          limit: 10,
                          lat: loc.lat,
                          long: loc.lon,
                          cursor: null,
                          searchText: null,
                          type: widget.type,
                          under10: widget.under10,
                          vanish: widget.isVanish);
                    });
                  }
                },
                hintText: Helper.getCachedTranslation(ref: ref, text: "Search product")),
          ),
          10.ph,
          // 14.ph,
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: AppStyles.screenHorizontalPadding),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       GenericTranslateWidget( 
          //         "Showing:  ",
          //         style: context.textStyle.bodyMedium,
          //       ),
          //       GenericTranslateWidget( 
          //         "152 Products",
          //         style: context.textStyle.displayMedium!
          //             .copyWith(fontSize: 18.sp),
          //       ),
          //     ],
          //   ),
          // ),
          response.status == Status.error
              ? SizedBox(
                  height: context.screenheight * 0.6,
                  child: CustomErrorWidget(onPressed: () {
                    searchTextEditController.clear();
                    ref.read(productDataProvider).getSeeAllAds(
                        categoryId: widget.categoryId,
                        limit: 10,
                        lat: loc.lat,
                        long: loc.lon,
                        cursor: null,
                        searchText: null,
                        type: widget.type,
                        under10: widget.under10,
                        vanish: widget.isVanish);
                  }),
                )
              : response.status == Status.completed && products.isEmpty
                  ? SizedBox(
                      height: context.screenheight * 0.6,
                      child: const ShowEmptyItemDisplayWidget(
                          message: "No Products Exits!"),
                    )
                  : VerticalProjectsDisplayLayoutWidget(
                      temp: products,
                      isLoad: isLoad,
                      isLoadMore: response.status == Status.loadingMore,
                      keyString: "",
                    )
        ],
      ),
    );
  }
}
