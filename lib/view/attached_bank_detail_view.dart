

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class AttachBankForm extends StatefulWidget {
  const AttachBankForm({super.key});

  @override
  State<AttachBankForm> createState() => _AttachBankFormState();
}

class _AttachBankFormState extends State<AttachBankForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final routingNumberController = TextEditingController();
  final accountNumberController = TextEditingController();

  BankAccountHolderType selectedType = BankAccountHolderType.Individual;

  String selectedCountryCode = 'US';
  String selectedCurrency = 'USD';
  final List<Map<String, String>> countries = [
    {'name': 'United States', 'code': 'US', 'currency': 'USD'},
    {'name': 'Canada', 'code': 'CA', 'currency': 'CAD'},
    {'name': 'United Kingdom', 'code': 'GB', 'currency': 'GBP'},
    {'name': 'Pakistan', 'code': 'PK', 'currency': 'PKR'},
    // Add more as needed
  ];

  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
      leadingWidget: const CustomBackButtonWidget(),
      title: "Add Bank Details",
      bottomWidget: Padding(
        padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
        child: Consumer(
          builder: (_, WidgetRef ref, __) {
            final isLoad = ref.watch(cardProvider).addBankDetailApiResponse.status == Status.loading;
            return CustomButtonWidget(
                title: "Add",
                isLoad: isLoad,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref.read(cardProvider).addBanKDetails(name: nameController.text, accNum: accountNumberController.text, rouNum: routingNumberController.text, type: selectedType, country: selectedCountryCode, currency: selectedCurrency);
                  }
                });
          },
        ),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: AppStyles.screenHorizontalPadding),
          children: [
            TextFieldUnderGround(
              title: "Account Holder Name",
              controller: nameController,
              keyboardType: TextInputType.name,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Name is required';
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) {
                  return 'Only letters allowed';
                }
                return null;
              },
              hintText: "Enter account holder name",
            ),
            TextFieldUnderGround(
              title: "Account Number",
              controller: accountNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12), // optional cap
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Account number is required';
                }
                if (!RegExp(r'^\d{10,12}$').hasMatch(v)) {
                  return 'Enter a valid 10–12 digit number';
                }
                return null;
              },
              hintText: "Enter bank account number",
            ),
            TextFieldUnderGround(
              title: "Routing Number",
              controller: routingNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Routing number is required';
                }
                if (!RegExp(r'^\d{9}$').hasMatch(v)) {
                  return 'Enter a 9-digit routing number';
                }
                return null;
              },
              hintText: "Enter routing number",
            ),
            GenericTranslateWidget( 
              "Country",
              style: context.textStyle.displayMedium!.copyWith(
                fontSize: 14.sp,
                color: AppColors.lightIconColor.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
            12.ph,
            DropdownButtonFormField<String>(
              value: selectedCountryCode,
              padding: EdgeInsets.zero,
              style: context.textStyle.displayMedium!.copyWith(fontSize: 22.sp),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 20.r),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.lightIconColor.withValues(alpha: 0.05),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2.0),
                ),
              ),
              onChanged: (value) {
                final selected =
                    countries.firstWhere((c) => c['code'] == value);
                setState(() {
                  selectedCountryCode = selected['code']!;
                  selectedCurrency = selected['currency']!;
                });
              },
              items: countries.map((country) {
                return DropdownMenuItem(
                  value: country['code'],
                  child: GenericTranslateWidget( country['name']!),
                );
              }).toList(),
            ),
            12.ph,
            GenericTranslateWidget( 
              "Account Holder Type",
              style: context.textStyle.displayMedium!.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.lightIconColor.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500),
            ),
            12.ph,
            DropdownButtonFormField<BankAccountHolderType>(
              value: selectedType,
              padding: EdgeInsets.zero,
              autovalidateMode: AutovalidateMode.always,
              style: context.textStyle.displayMedium!.copyWith(fontSize: 22.sp),
              decoration: InputDecoration(
                  maintainHintSize: true,
                  contentPadding:
                      EdgeInsets.only(bottom: 20.r, left: 0.0, right: 0.0),
                  fillColor: Colors.transparent,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            AppColors.lightIconColor.withValues(alpha: 0.05)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  labelStyle: context.textStyle.displayMedium!.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.lightIconColor.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500)),
              onChanged: (type) => setState(() => selectedType = type!),
              items: BankAccountHolderType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: GenericTranslateWidget( 
                    type.name,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
