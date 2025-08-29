import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class CustomDespositeWidget extends StatelessWidget {
  final String title;
  final double price;
  final String type;
  const CustomDespositeWidget(
      {super.key,
      required this.title,
      required this.price,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: setColor2(type),
        radius: 35.r,
        child: SvgPicture.asset(
          setIcon(type),
        ),
      ),
      title: GenericTranslateWidget( 
        title,
        style: context.textStyle.bodyMedium,
      ),
      trailing: GenericTranslateWidget( 
        "\$$price+",
        style: context.textStyle.displayMedium!
            .copyWith(color: const Color.fromRGBO(76, 175, 80, 1)),
      ),
    );
  }
}

String setIcon(String type) {
  switch (type.toLowerCase()) {
    case "deposite":
    case "withdraw":
      return Assets.down;
    case "refund":
      return Assets.refresh;

    default:
      return Assets.down;
  }
}

Color setColor2(String type) {
  switch (type.toLowerCase()) {
    case "deposite":
    case "withdraw":
      return AppColors.greenColor.withValues(alpha: 0.1);
    case "refund":
    
      return AppColors.blueColor.withValues(alpha: 0.1);

    default:
      return AppColors.greenColor.withValues(alpha: 0.1);
  }
}

class DepositeDataModel {
  late final String title;
  late final double price;
  late final String type;

  DepositeDataModel(
      {required this.title, required this.price, required this.type});

  static List<DepositeDataModel> list = [
    DepositeDataModel(
        title: "Deposit Successfully", price: 100.00, type: "deposite"),
    DepositeDataModel(
        title: "Refund Successfully", price: 100.00, type: "refresh"),
    DepositeDataModel(
        title: "Deposit Successfully", price: 100.00, type: "deposite"),
    DepositeDataModel(
        title: "Deposit Successfully", price: 100.00, type: "deposite"),
  ];
}