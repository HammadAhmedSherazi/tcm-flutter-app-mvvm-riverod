import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class OrderDetailView extends StatefulWidget {
  final Widget child;
  final num totalAmount;
  final Map<String, String> summary;
  final LocationData? locationData;
  const OrderDetailView({super.key, required this.child, required this.summary, this.locationData, required this.totalAmount});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
      leadingWidget: const CustomBackButtonWidget(),
      title: "Order Detail", child: Padding(
        padding:  EdgeInsets.all(AppStyles.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
        children: [
          if(widget.locationData != null)...[
            Container(
                      height: 67.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10.r),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.borderColor),
                          color: const Color(0xffEFEDEC)),
                      child:  Row(
                              children: [
                                Container(
                                  width: 50.r,
                                  height: 50.r,
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(3.13.r)),
                                  child: SvgPicture.asset(
                                      Assets.setPinLocationIcon),
                                ),
                                10.pw,
                                Expanded(
                                    child: GenericTranslateWidget( 
                                  widget.locationData!.placeName,
                                  style: context.textStyle.displayMedium!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                                // if (!isConfirm)
                                //   Icon(
                                //     Icons.arrow_forward_ios,
                                //     size: 17.r,
                                //   )
                              ],
                            ),
                    ),
                    20.ph,
         
          ],
            Expanded(child: SingleChildScrollView(child: widget.child)),

         GenericTranslateWidget( "Order Summary", style: context.textStyle.displayMedium!.copyWith(
          fontWeight: FontWeight.w700,
          foreground: Paint()..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF006CD4),
          Color(0xFF0675D5),
          Color(0xFF168FD6),
          Color(0xFF1E9CD7),
        ],
        stops: [0.0187, 0.3052, 0.7799, 0.9886], // matches CSS stops
      ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 50.0),
         ))),
         ...List.generate(widget.summary.length,(index) {
          final entry = widget.summary.entries.elementAt(index);
       
           return Row(
          children: [
            GenericTranslateWidget( entry.key, style: context.textStyle.displayMedium,),
            const Spacer(),
            GenericTranslateWidget( entry.value, style: context.textStyle.displayMedium,)
          ],
                 );
         },),
        const Divider(
          color: Colors.grey,
        ),
        
        Row(
          children: [
            GenericTranslateWidget( "Total", style: context.textStyle.displayMedium,),
            const Spacer(),
            GenericTranslateWidget( "\$${widget.totalAmount}", style: context.textStyle.displayMedium,)
          ],
        ),
        const Divider(
          color: Colors.grey,
        ),
        ],
            ),
      ));
  }
}