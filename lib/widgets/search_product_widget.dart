import '../export_all.dart';
class SearchProductWidgets extends ConsumerStatefulWidget {
  final String text;

  const SearchProductWidgets({super.key, required this.text});

  @override
  SearchProductWidgetsState createState() => SearchProductWidgetsState();
}

class SearchProductWidgetsState extends ConsumerState<SearchProductWidgets> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
       
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final apiResponse = ref.watch(productRepoProvider).apiSearchProductApi;
    // return buildWidget(apiResponse, ref, widget.text, _scrollController);
    return const Center();
  }
}

// Widget buildWidget(ApiResponse response, WidgetRef ref, String text,
//     ScrollController controller) {
//   switch (response.status) {
//     case Status.loading:
//       return Skeletonizer(
//         enabled: true,
//         child: displayProducts(
//             List.generate(
//               5,
//               (index) => Product(
//                   id: -1,
//                   name: "name",
//                   discountPrice: 0.0,
//                   price: 0.0,
//                   mainImageUrl: ""),
//             ),
//             ref,
//             response,
//             controller),
//       );
//     case Status.error:
//       return Center(
//         child: CustomErrorWidget(onPressed: () {
//           ref.read(productRepoProvider).searchLoadAgain(text, 10, 0);
//         }),
//       );
//     case Status.loadingMore:
//     case Status.loadingProcess:
//     case Status.completed:
//       return displayProducts(ref.watch(productRepoProvider).homeProductsMore,
//           ref, response, controller);

//     default:
//       return const SizedBox.shrink();
//   }
// }

// Widget displayProducts(List<Product> products, WidgetRef ref, ApiResponse res,
//     ScrollController controller) {
//   return products.isNotEmpty
//       ? Column(
//           children: [
//             Expanded(
//               child: ScrollConfiguration(
//                 behavior: MyBehavior(),
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   controller: controller,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: AppStyles.screenHorizontalPadding,
//                       vertical: AppStyles.screenHorizontalPadding),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 2.w,
//                     mainAxisSpacing: 2.h,
//                     childAspectRatio: 0.79.h, // Adjust based on design
//                   ),
//                   itemCount: res.status == Status.loadingMore ||
//                           res.status == Status.loadingProcess
//                       ? products.length + (products.length.isOdd ? 5 : 4)
//                       : products.length,
//                   itemBuilder: (context, index) {
//                     if (index > products.length - 1) {
//                       return const ProductLoaderWidget();
//                     }
//                     return ProductCard(
//                       index: index,
//                       onHeartTap: () {
//                         ref
//                             .read(productRepoProvider)
//                             .toggleMoreProductFavourite(
//                                 products[index].id, index);
//                       },
//                       productData: products[index],
//                     );
//                   },
//                 ),
//               ),
//             ),
//             // if (res.status == Status.loadingMore) ...[
//             //   SizedBox(
//             //     height: 40.h,
//             //     child: const CustomLoadingWidget(),
//             //   )
//             // ]
//           ],
//         )
//       :  CustomProductNoShowMessageWidget(
//           lottiePath: Assets.noCategoryAnimation,
//            width: 280.r,
//            text: "No product found!",
//         );
// }
