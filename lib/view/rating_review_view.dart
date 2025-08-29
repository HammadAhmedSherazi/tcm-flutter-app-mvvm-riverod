import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';


class RatingReviewView extends ConsumerStatefulWidget {
  final int id;
  final double rating;
  final num numberOfReviews;
  const RatingReviewView(
      {super.key,
      required this.id,
      required this.rating,
      required this.numberOfReviews});

  @override
  ConsumerState<RatingReviewView> createState() =>
      _RatingReviewViewConsumerState();
}

class _RatingReviewViewConsumerState extends ConsumerState<RatingReviewView> {
  late final ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    Future.microtask(() {
      ref.read(productDataProvider).getProductReview(
          cursor: null, input: {"product_id": widget.id, "limit": 10});
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.microtask(() {
          String? cursor = ref.watch(productDataProvider).reviewCursor;
          // String status = ref.watch(productDataProvider).status;
          ref.read(productDataProvider).getProductReview(
              cursor: cursor, input: {"product_id": widget.id, "limit": 5});
                });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productDataProvider);
    final status = provider.productReviewApiResponse.status;
    final isLoad = status == Status.loading;
    final list = isLoad
        ? List.generate(
            3,
            (index) => ProductReviewsDataModel(
                id: -1,
                review: "sfdgsfh",
                rating: 0.0,
                user: UserDataModel(id: -1)),
          )
        : provider.productReviews;
    return CommonScreenTemplateWidget(
        leadingWidget: const CustomBackButtonWidget(),
        title: "Rating & Reviews",
        child: Column(
          spacing: 10.h,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppStyles.screenHorizontalPadding),
              child: Row(
                spacing: 3.w,
                children: [
                  GenericTranslateWidget( 
                    "${widget.rating}",
                    style: context.textStyle.displayLarge!.copyWith(
                        fontWeight: FontWeight.w800,
                        foreground: AppColors.gradientPaint),
                  ),
                  CustomRatingIndicator(
                    rating: widget.rating,
                    iconSize: 20.r,
                  ),
                  const Spacer(),
                  GenericTranslateWidget( "${widget.numberOfReviews} Reviews",
                      style: context.textStyle.bodyLarge!
                          .copyWith(fontSize: 18.sp)),
                ],
              ),
            ),
            Expanded(
              child:
               AsyncStateHandler(
                status: status,
                dataList: list,
                loadingWidget: Skeletonizer(
                  enabled: isLoad,
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: AppStyles.screenHorizontalPadding),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final review = list[index];
                        return ReviewCardWidget(review: review);
                      },
                      separatorBuilder: (context, index) => 10.ph,
                      itemCount: list.length),
                ),
                itemBuilder: (context, index) {
                  if (index == list.length - 1 &&
                      status == Status.loadingMore) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    final review = list[index];
                    return ReviewCardWidget(review: review);
                  }
                },
                onRetry: () {
                  ref.read(productDataProvider).getProductReview(
                      cursor: null,
                      input: {"product_id": widget.id, "limit": 10});
                },
              ),
            ),
          ],
        ));
  }
}
