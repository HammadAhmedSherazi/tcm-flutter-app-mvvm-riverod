import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tcm/config/app_styles.dart';
import 'package:tcm/widgets/common_screen_template_widget.dart';
import 'package:tcm/widgets/custom_back_button_widget.dart';

class SoldOutView extends ConsumerStatefulWidget {
  const SoldOutView({super.key});

  @override
  ConsumerState<SoldOutView> createState() => _SoldOutViewConsumerState();
}

class _SoldOutViewConsumerState extends ConsumerState<SoldOutView> {
  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(title: "Ad Details", leadingWidget: const CustomBackButtonWidget(), child: ListView(
      padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
      children: const [],
    ),);
  }
}