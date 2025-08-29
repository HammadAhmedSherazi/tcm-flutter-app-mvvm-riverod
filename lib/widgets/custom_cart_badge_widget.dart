import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class CustomCartBadgeWidget extends ConsumerWidget {
  const CustomCartBadgeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final count =
                            ref.watch(productDataProvider).checkOutList.length;
                      
                        return Badge(
                            isLabelVisible: count > 0,
                            backgroundColor: AppColors.bagdeColor,
                            label: GenericTranslateWidget( "$count"),
                            textStyle: context.textStyle.bodySmall!.copyWith(
                              height: 0.9,
                            ),
                            child: CustomMenuIconShape(
                                icon: Assets.bagIcon,
                                onTap: () {
                                  AppRouter.push(const MyCartView());
                                }));
  }
}