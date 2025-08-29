import 'package:tcm/utils/app_extensions.dart';
import '../../export_all.dart';


class SelectPaymetView extends StatelessWidget {
  const SelectPaymetView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
      title: "Select Payment",
      leadingWidget: const CustomBackButtonWidget(),
      appBarHeight: 80.h,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppStyles.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                AppRouter.push(const SelectPaymentAddMoreView());
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.darkIconColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1,
                      color: AppColors.lightIconColor.withValues(alpha: 0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      GenericTranslateWidget( "Select a method",
                          style: context.textStyle.displayMedium!.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.lightIconColor,
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Container(
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: SvgPicture.asset(Assets.paypal),
                      ),
                      8.pw,
                      Container(
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: SvgPicture.asset(Assets.masterCard),
                      ),
                      8.pw,
                      Container(
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: SvgPicture.asset(Assets.visa),
                      ),
                      12.pw,
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.lightIconColor,
                        size: 16.r,
                      ),
                      12.pw,
                    ],
                  ),
                ),
              ),
            ),
            20.ph,
            GenericTranslateWidget( 
              "Deposit Amount",
              style: context.textStyle.displayMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.lightIconColor,
              ),
            ),
            20.ph,
            const SelectableContainerList(
              items: ["\$100.00", "\$200.00", "\$300.00"],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectableContainerList extends StatefulWidget {
  final List<String> items;

  const SelectableContainerList({super.key, required this.items});

  @override
  SelectableContainerListState createState() => SelectableContainerListState();
}

class SelectableContainerListState extends State<SelectableContainerList> {
  int? selectedIndex; // To track which container is selected
  final TextEditingController textController =
      TextEditingController(); // Controller for TextField

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.items.map((item) {
              int index = widget.items.indexOf(item);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    textController.text = item;
                  });
                },
                child: Container(
                  height: 50.h,
                  width: (context.screenwidth / 3) * 0.85,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? AppColors.primaryColor.withValues(alpha: 0.1)
                        : AppColors.greyColor.withValues(alpha: 0.1),
                    border: Border.all(
                        color: AppColors.lightIconColor.withValues(alpha: 0.1),
                        width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GenericTranslateWidget( 
                    item,
                    style: context.textStyle.displayMedium?.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightIconColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          TextFieldUnderGround(
            hintText: "Amount",
            controller: textController,
          ),
          const Spacer(),
          CustomButtonWidget(
              title: "Proceed with ${textController.text}",
              onPressed: () {
                AppRouter.push(const SelectPaymentAddMoreView());
              }),
          20.ph,
        ],
      ),
    );
  }
}
