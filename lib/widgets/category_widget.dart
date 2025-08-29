import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class CategoriesWidget extends StatelessWidget {
  final bool? isShowTitle;
  final WidgetRef ref;
  final int index;

  const CategoriesWidget(
      {super.key, required this.ref, this.isShowTitle = false, required this.index});

  @override
  Widget build(BuildContext context) {
    final isLoad =
        ref.watch(productDataProvider).mainCategoryApiResponse.status;
    final items = isLoad == Status.loading ||
            isLoad == Status.loading ||
            isLoad == Status.error
        ? CategoryDataModel.categories
        : ref.watch(productDataProvider).mainCategories;
    final languageNotifier = ref.watch(languageChangeNotifierProvider);
            final languageCode = languageNotifier.currentLanguage.code;
            final isRtl = languageCode == 'ar';
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: AppStyles.screenHorizontalPadding),
        margin: EdgeInsets.only(bottom: 10.r),
        width: double.infinity,
        height: 100.h,
        child: isShowTitle!
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: GenericTranslateWidget( 
                        "Categories",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontSize: 18.sp),
                      )),
                      if (items.isNotEmpty)
                        TextButton(
                            onPressed: () {
                              AppRouter.push(const AllCategoriesView());
                            },
                            child: GenericTranslateWidget( 
                              "See All",
                              style: context.textStyle.bodyMedium!
                                  .copyWith(color: AppColors.primaryColor),
                            ))
                    ],
                  ),
                  Expanded(
                    child: items.isNotEmpty
                        ? Skeletonizer(
                            enabled: isLoad == Status.loading ||
                                isLoad == Status.error,
                            child: ListView.separated(
                              itemCount: items.length,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, i) => 4.pw,
                              itemBuilder: (context, i) => GestureDetector(
                                onTap: (){
                                  AppRouter.push(
                                    CategoryProductView(
                                    category: items[i],
                                    index: index,
                                  ));
                                },
                                child: CategoryItemDisplayWidget(items: items[i], isRTL: isRtl,),
                              ),
                            ))
                        : GenericTranslateWidget( 
                            "No categories exist!",
                            style: context.textStyle.bodyMedium,
                          ),
                  )
                ],
              )
            : items.isNotEmpty
                ? Skeletonizer(
                    enabled: isLoad == Status.loading || isLoad == Status.error,
                    child: ListView.separated(
                      itemCount: items.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, i) => 4.pw,
                      itemBuilder: (context, i) => GestureDetector(
                                onTap: (){
                                  AppRouter.push(
                                    CategoryProductView(
                                    category: items[i],
                                    index: index,
                                  ));
                                },
                                child: CategoryItemDisplayWidget(items: items[i], isRTL: isRtl,),
                              ) 
                    ))
                : Container(
                    height: 14.h,
                    alignment: Alignment.center,
                    child: GenericTranslateWidget( 
                      "No categories exist!",
                      style: context.textStyle.bodyMedium,
                    ),
                  ));
  }
}

class CategoryItemDisplayWidget extends StatelessWidget {
  const CategoryItemDisplayWidget({
    super.key,
    required this.items,
    this.isSelect = false,
    this.subCategoryText,
    this.isRTL = false

  });

  final CategoryDataModel items;
  final bool? isSelect;
  final String? subCategoryText;
  final bool isRTL;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 41.h,
          decoration: BoxDecoration(
              color:   context.colors.onInverseSurface,
             
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
                      imageUrl: items.imageUrl,
                      width: 70.r,
                      height: 40.r,
                    ),
                  ),
                ),
                Row(
                  children: isRTL ? [ 10.pw, GenericTranslateWidget( items.title), 65.pw,] : [
                    
                    65.pw, GenericTranslateWidget( items.title), 10.pw,
                    
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
