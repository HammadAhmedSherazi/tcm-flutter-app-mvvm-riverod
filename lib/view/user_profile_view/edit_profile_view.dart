import 'package:tcm/utils/app_extensions.dart';
import '../../export_all.dart';


class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() =>
      _EditProfileViewConsumerState();
}

class _EditProfileViewConsumerState extends ConsumerState<EditProfileView> {
  File? image;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;

  late TextEditingController genderController;

// Pick an image.

  selectImage() async {
    final image = await ImageSelector.selectImages(
      context: context,
      maxImages: 1,
      compressImageFn: Helper.compressImage,
    );
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowMultiple: false,
    //   allowedExtensions: ['jpg', 'png', 'jpeg'],
    // );
    // if (result != null) {
    //   image = File(result.files.single.path!);
    // }
    if (image.isNotEmpty) {
      ref.read(authRepoProvider).updateProfile({}, image.first);
    }

    setState(() {});
  }

  @override
  void initState() {
    final user = ref.read(authRepoProvider).userData;
    final PhoneNumber? phone = user?.phoneNo != ""
        ? PhoneNumber.parse(user!.phoneNo.replaceAll("null", "+1"))
        : null;
    initialCountryCode = phone != null ? phone.isoCode.name : "US";
    // countryCode = phone != null ? phone.countryCode : "+1";
    firstNameController = TextEditingController(
      text: user?.fname ?? '',
    );
    lastNameController = TextEditingController(
      text: user?.lname ?? '',
    );
    genderController = TextEditingController(
      text: user?.gender ?? '',
    );
    emailController = TextEditingController(
      text: user?.email ?? '',
    );
    phoneNumberController =
        TextEditingController(text: phone != null ? phone.nsn : "");

    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String initialCountryCode = "US";
  // String countryCode = "+1";
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepoProvider).userData;
    
    return CommonScreenTemplateWidget(
      appBarHeight: 60.h,
      title: "Basic Infromation",
      leadingWidget: const CustomBackButtonWidget(),
      child: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: AppStyles.screenHorizontalPadding,
            vertical: AppStyles.screenHorizontalPadding + 10),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              image == null
                  ? UserProfileWidget(radius: 60, imageUrl: user?.picture ?? '')
                  : CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(image!),
                    ),

              12.pw, // Add spacing between the image and the text content

              // Text Content (Title and Subtitle)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    28.ph,
                    // Title
                    Text( 
                      "${user?.userName}",
                      style: context.textStyle.displayMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    4.ph, // Add spacing between title and subtitle

                    // Subtitle
                    GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: GenericTranslateWidget( 
                        "Replace Image",
                        style: context.textStyle.displayMedium!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          40.ph,
          TextFieldUnderGround(
            hintText: "First Name",
            title: "First Name",
            controller: TextEditingController(text: user?.fname),
            readOnly: true,
            onTap: () {
              final TextEditingController fcontroller =
                  TextEditingController(text: user?.fname);
              showDialog(
                context: context,
                builder: (context) {
                  return Form(
                    key: formKey,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final isLoad = ref.watch(authRepoProvider).updateApiResponse.status == Status.loading;
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                AppRouter.back();
                              },
                              child: GenericTranslateWidget( 
                                "Cancel",
                                style: context.textStyle.displayMedium!
                                    .copyWith(fontSize: 18.sp),
                              ),
                            ),
                            isLoad 
                                ? const CircularProgressIndicator()
                                : TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        ref.read(authRepoProvider).updateProfile(
                                            {"first_name": fcontroller.text.trim()},
                                            null).whenComplete(() {
                                          AppRouter.back();
                                          // setState(() {});
                                        });
                                      }
                                    },
                                    child: GenericTranslateWidget( 
                                      "Save",
                                      style: context.textStyle.displayMedium!
                                          .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 18.sp),
                                    ),
                                  ),
                          ],
                          content: CustomTextFieldWidget(ref:ref,
                            controller: fcontroller,
                            hintText: "Enter First Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                          ),
                        );
                      }
                    ),
                  );
                },
              );
            },
            hasIcon: true,
          ),
          TextFieldUnderGround(
            hintText: "Last Name",
            title: "Last Name",
            readOnly: true,
            onTap: () {
              final TextEditingController lcontroller =
                  TextEditingController(text: user?.lname);
              showDialog(
                context: context,
                builder: (context) {
                  return Form(
                    key: formKey,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final isLoad = ref.watch(authRepoProvider).updateApiResponse.status == Status.loading;
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                AppRouter.back();
                              },
                              child: GenericTranslateWidget( 
                                "Cancel",
                                style: context.textStyle.displayMedium!
                                    .copyWith(fontSize: 18.sp),
                              ),
                            ),
                            isLoad 
                                ? const CircularProgressIndicator()
                                : TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        ref.read(authRepoProvider).updateProfile(
                                            {"last_name": lcontroller.text.trim()},
                                            null).whenComplete(() {
                                          AppRouter.back();
                                        });
                                      }
                                    },
                                    child: GenericTranslateWidget( 
                                      "Save",
                                      style: context.textStyle.displayMedium!
                                          .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 18.sp),
                                    ),
                                  ),
                          ],
                          content: CustomTextFieldWidget(ref:ref,
                            hintText: "Enter Last Name",
                            controller: lcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                          ),
                        );
                      }
                    ),
                  );
                },
              );
            },
            controller: TextEditingController(text: user?.lname),
            hasIcon: true,
          ),
          TextFieldUnderGround(
            hintText: "Gender",
            title: "Gender",
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r)),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GenericTranslateWidget( 
                        'Select Gender',
                        style: context.textStyle.headlineMedium
                            ?.copyWith(fontSize: 18.sp),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          genderController.text = "Male";
                          ref.read(authRepoProvider).updateProfile(
                              {"gender": genderController.text}, null);
                          setState(() {});
                          AppRouter.back();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          child: GenericTranslateWidget( 
                            "Male",
                            style: context.textStyle.displayMedium?.copyWith(
                              fontSize: 18.sp,
                              color: genderController.text == "Male"
                                  ? context.colors.primary
                                  : context.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          genderController.text = "Female";
                          ref.read(authRepoProvider).updateProfile(
                              {"gender": genderController.text}, null);
                          setState(() {});
                          AppRouter.back();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          child: GenericTranslateWidget( 
                            "Female",
                            style: context.textStyle.displayMedium?.copyWith(
                              fontSize: 18.sp,
                              color: genderController.text == "Female"
                                  ? context.colors.primary
                                  : context.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            readOnly: true,
            controller: genderController,
            hasIcon: true,
          ),
          // GenericTranslateWidget( 
          //   "Phone",
          //   style: context.textStyle.displayMedium!.copyWith(
          //       fontSize: 14.sp,
          //       color: AppColors.lightIconColor.withValues(alpha: 0.5),
          //       fontWeight: FontWeight.w500),
          // ),
          // 12.ph,
          TextFieldUnderGround(
            hintText: "Phone",
            title: "Phone",
            readOnly: true,
            onTap: () {
              // final TextEditingController phoneNumberController =
              //     TextEditingController(text: p);
              showDialog(
                context: context,
                builder: (context) {
                  return Form(
                    key: formKey,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final isLoad = ref.watch(authRepoProvider).updateApiResponse.status == Status.loading;
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                AppRouter.back();
                              },
                              child: GenericTranslateWidget( 
                                "Cancel",
                                style: context.textStyle.displayMedium!
                                    .copyWith(fontSize: 18.sp),
                              ),
                            ),
                            isLoad 
                                ? const CircularProgressIndicator()
                                : TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        try {
                                        final isoCode = IsoCode.values.firstWhere(
                                          (c) =>
                                              c.name ==
                                              initialCountryCode.toUpperCase(),
                                          orElse: () => IsoCode.US, // fallback
                                        );
                        
                                        final parsed = PhoneNumber.parse(
                                          phoneNumberController.text,
                                          destinationCountry: isoCode,
                                        );
                        
                                        if (parsed.isValid()) {
                                          ref.read(authRepoProvider).updateProfile({
                                            "phone": parsed.international,
                                          }, null).whenComplete((){
                                            AppRouter.back();
                                          });
                                        } else {
                                          Helper.showMessage(
                                              "Please enter a valid phone number");
                                        }
                                      } catch (e) {
                                        Helper.showMessage(
                                            "Phone number format is invalid.");
                                      }
                                      }
                                      
                                    },
                                    child: GenericTranslateWidget( 
                                      "Save",
                                      style: context.textStyle.displayMedium!
                                          .copyWith(
                                              color: AppColors.primaryColor,
                                              fontSize: 18.sp),
                                    ),
                                  ),
                          ],
                          content: IntlPhoneField(
                            disableLengthCheck: false,
                            controller: phoneNumberController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false, signed: false),
                            validator: (value) {
                              if (value!.number.isEmpty) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.r, horizontal: 14.r),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide:
                                    BorderSide(color: AppColors.borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide:
                                    BorderSide(color: AppColors.borderColor),
                              ),
                              hintText: "Phone",
                              hintStyle: context.inputTheme.hintStyle!.copyWith(
                                  color: Colors.black.withValues(alpha: 0.5)),
                            ),
                            initialCountryCode: initialCountryCode,
                            onCountryChanged: (value) {
                              // countryCode = "+${value.dialCode}";
                              initialCountryCode = value.code;
                            },
                            onChanged: (phone) {
                              phoneNumberController.text = phone.number;
                              // countryCode = phone.countryCode;
                            },
                          ),
                        );
                      }
                    ),
                  );
                },
              );
            },
            controller: TextEditingController(text: user?.phoneNo),
            hasIcon: true,
          ),

          // IntlPhoneField(
          //   // disableLengthCheck: true,

          //   controller: phoneNumberController,
          //   readOnly: true,
          //   style:
          //       context.textStyle.displayMedium!.copyWith(fontSize: 22.sp),
          //   flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 0),
          //   showDropdownIcon: false,

          //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //   keyboardType: const TextInputType.numberWithOptions(
          //       decimal: false, signed: false),

          //   decoration: InputDecoration(
          //     suffixIcon: Container(
          //       width: 10.r,
          //       height: 10.r,
          //       padding: EdgeInsets.all(16.r),
          //       child: SvgPicture.asset(Assets.editProfile),
          //     ),
          //     fillColor: Colors.transparent,
          //     filled: true,
          //     isDense: true,
          //     contentPadding:
          //         EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.r),
          //     focusedBorder: const UnderlineInputBorder(
          //       borderSide: BorderSide(color: Colors.blue, width: 2.0),
          //     ),
          //     enabledBorder: UnderlineInputBorder(
          //       borderSide: BorderSide(
          //           color:
          //               AppColors.lightIconColor.withValues(alpha: 0.05)),
          //     ),
          //     hintText: "Phone",
          //     hintStyle: context.textStyle.displayMedium?.copyWith(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w500,
          //         color: AppColors.lightIconColor.withValues(alpha: 0.5)),
          //   ),
          //   initialCountryCode: initialCountryCode,
          //   onCountryChanged: (value) {
          //       // countryCode = "+${value.dialCode}";
          //       initialCountryCode = value.code;
          //     },
          //   onChanged: (phone) {
          //     phoneNumberController.text = phone.number;
          //     // countryCode = phone.countryCode;
          //   },

          //   onSubmitted: (phone) {
          //     try {
          //       final isoCode = IsoCode.values.firstWhere(
          //         (c) => c.name == initialCountryCode.toUpperCase(),
          //         orElse: () => IsoCode.US, // fallback
          //       );

          //       final parsed = PhoneNumber.parse(
          //        phoneNumberController.text,
          //         destinationCountry: isoCode,
          //       );

          //       if (parsed.isValid()) {
          //         ref.read(authRepoProvider).updateProfile({
          //           "phone": parsed.international,
          //         }, null);
          //       } else {
          //         Helper.showMessage("Please enter a valid phone number");
          //       }
          //     } catch (e) {
          //       Helper.showMessage("Phone number format is invalid.");
          //     }
          //     // ref.read(authRepoProvider).updateProfile(
          //     //                 {"phone": "$countryCode${phoneNumberController.text}"}, null);
          //   },
          // ),

          24.ph,
          TextFieldUnderGround(
            hintText: "xyz@gmail.com",
            title: "Email",
            controller: emailController,
            readOnly: true,
            hasIcon: false,
          ),
          // const TextFieldUnderGround(
          //   hintText: "Password",
          //   title: "Password",
          // ),
          GenericTranslateWidget( 
            "Delete Account",
            style: context.textStyle.displayMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.deleteButtonColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldUnderGround extends ConsumerWidget {
  const TextFieldUnderGround(
      {super.key,
      this.hintText,
      this.text,
      this.title,
      this.hasIcon,
      this.onTap,
      this.readOnly,
      this.controller,
      this.validator,
      this.keyboardType,
      this.inputFormatters,
      this.onChanged});

  final String? hintText;
  final String? text;
  final String? title;
  final bool? hasIcon;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GenericTranslateWidget( 
          title ?? "",
          style: context.textStyle.displayMedium!.copyWith(
              fontSize: 14.sp,
              color: AppColors.lightIconColor.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500),
        ),
        12.ph,
        TextFormField(
          controller: controller,
          textAlign: TextAlign.left,
          onTapOutside: (c) {
            AppRouter.keyboardClose();
          },
          onTap: onTap,
          onTapUpOutside: (c) {
            AppRouter.keyboardClose();
          },
          readOnly: readOnly ?? false,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: context.textStyle.displayMedium!.copyWith(fontSize: 22.sp),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
            fillColor: Colors.transparent,
            hintText: Helper.getCachedTranslation(ref: ref, text: hintText ?? "Enter"),
            suffixIcon: title == "Password"
                ? GenericTranslateWidget( 
                    "Change",
                    style: context.textStyle.displayMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  )
                : (hasIcon == true
                    ? Container(
                        width: 10.r,
                        height: 10.r,
                        padding: EdgeInsets.all(16.r),
                        child: SvgPicture.asset(Assets.editProfile),
                      )
                    : null),
            // Display icon if hasIcon is true
            hintStyle: context.textStyle.displayMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.lightIconColor.withValues(alpha: 0.5)),

            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.lightIconColor.withValues(alpha: 0.05)),
            ),
            focusedBorder: !(readOnly ?? true)
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            AppColors.lightIconColor.withValues(alpha: 0.05)),
                  )
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
        ),
        24.ph,
      ],
    );
  }
}

// Usage example:
