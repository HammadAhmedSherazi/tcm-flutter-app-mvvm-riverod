import 'package:intl/intl.dart';
import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

// import '../widgets/multiple_capture_camera_screen.dart';

class AdProductView extends StatefulWidget {
  CategoryDataModel? category;
  CategoryDataModel? subCategory;
  final ProductDetailDataModel? product;
  final int? index;
  AdProductView(
      {super.key,
      required this.category,
      required this.subCategory,
      this.index,
      this.product});

  @override
  State<AdProductView> createState() => _AdProductViewState();
}

class _AdProductViewState extends State<AdProductView> {
  int quantity = 1;
  String condition = "";
  DateTime ? checkInDate ;
  DateTime ? checkOutDate ;
  TimeOfDay? checkInTime ;
  TimeOfDay ?checkOutTime ;
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController adTitletextController = TextEditingController();
  TextEditingController brandtextController = TextEditingController();

  List<File> productImages = [];
  File? receiptImage;
  final int descriptionMaxLength = 1000, titleMaxLength = 100;
  static const int maxTotalSize = 3 * 1024 * 1024;
  // 3MB in bytes
  Future<void> selectReceipt() async {
    try {
      // FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowMultiple: false, // Allow multiple images
      //   allowedExtensions: ['jpg', 'png', 'jpeg'],
      // );

      final image = await ImageSelector.selectImages(
        context: context,
        maxImages: 1,
        compressImageFn: Helper.compressImage,
      );

      if (image.isNotEmpty) {
        final File selectedFile = File(image.single.path);
        if (selectedFile.lengthSync() <= maxTotalSize) {
          receiptImage = await Helper.compressImage(selectedFile);
          setState(() {});
        } else {
          Helper.showMessage("Total file size should not exceed 3MB!");
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  final NumberFormat _numberFormat =
      NumberFormat("#,##0.00"); // Format to 2 decimal places

  void formatInput() {
    String text = priceTextController.text.trim();

    if (text.isEmpty) return;

    double? value = double.tryParse(text);
    if (value != null) {
      priceTextController.value = TextEditingValue(
        text: _numberFormat.format(value), // Formats to 2 decimal places
        selection:
            TextSelection.collapsed(offset: _numberFormat.format(value).length),
      );
    }
  }

  // Future<void> selectProductImages() async {
  //   try {
  //     if (productImages.length >= 5) {
  //       Helper.showMessage("Maximum 5 images allowed");
  //       return;
  //     }

  //     final FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowMultiple: true,
  //       allowedExtensions: ['jpg', 'png', 'jpeg'],
  //     );

  //     if (result == null) return;

  //     final List<File> validFiles = [];
  //     int remainingSlots = 5 - productImages.length;

  //     for (final platformFile in result.files) {
  //       if (remainingSlots <= 0) break;

  //       final File originalFile = File(platformFile.path!);
  //       final int fileSize = await originalFile.length();

  //       if (fileSize > maxTotalSize) {
  //         Helper.showMessage("'${platformFile.name}' exceeds 3MB limit");
  //         continue;
  //       }

  //       // Compress Image
  //       final File? compressedFile = await Helper.compressImage(originalFile);
  //       if (compressedFile != null) {
  //         validFiles.add(compressedFile);
  //         remainingSlots--;
  //       }
  //     }

  //     if (validFiles.isNotEmpty) {
  //       productImages.addAll(validFiles);
  //       setState(() {}); // Update UI
  //     }

  //     final int totalSelected = result.files.length;
  //     final int addedCount = validFiles.length;
  //     if (addedCount < totalSelected) {
  //       final int skipped = totalSelected - addedCount;
  //       Helper.showMessage("Added $addedCount images ($skipped skipped)");
  //     }
  //   } catch (e) {
  //     Helper.showMessage("Error selecting images: ${e.toString()}");
  //   }
  // }

  // void _showPicker(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     showDragHandle: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) => SafeArea(
  //       child: Wrap(
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.photo_library),
  //             title: const GenericTranslateWidget( 'Gallery'),
  //             onTap: () {
  //               selectProductImages();
  //               AppRouter.back();
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.photo_camera),
  //             title: const GenericTranslateWidget( 'Camera'),
  //             onTap: () async {
  //               Navigator.pop(context);
  //               final result = await Navigator.push<List<File>>(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (_) => const MultiCaptureCameraScreen(),
  //                 ),
  //               );
  //               if (result != null && result.isNotEmpty) {
  //                 if (productImages.length >= 5) {
  //                   Helper.showMessage("Maximum 5 images allowed");
  //                   return;
  //                 }
  //                 final List<File> validFiles = [];
  //                 int remainingSlots = 5 - productImages.length;

  //                 for (final platformFile in result) {
  //                   if (remainingSlots <= 0) break;

  //                   final File originalFile = File(platformFile.path);
  //                   final int fileSize = await originalFile.length();

  //                   if (fileSize > maxTotalSize) {
  //                     Helper.showMessage("$platformFile exceeds 3MB limit");
  //                     continue;
  //                   }

  //                   // Compress Image
  //                   final File? compressedFile =
  //                       await Helper.compressImage(originalFile);
  //                   if (compressedFile != null) {
  //                     validFiles.add(compressedFile);
  //                     remainingSlots--;
  //                   }
  //                 }

  //                 if (validFiles.isNotEmpty) {
  //                   productImages.addAll(validFiles);
  //                   setState(() {}); // Update UI
  //                 }

  //                 final int totalSelected = result.length;
  //                 final int addedCount = validFiles.length;
  //                 if (addedCount < totalSelected) {
  //                   final int skipped = totalSelected - addedCount;
  //                   Helper.showMessage(
  //                       "Added $addedCount images ($skipped skipped)");
  //                 }
  //                 // Use the images here
  //               }
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.product != null) {
      quantity = widget.product!.quantity!;
      condition = widget.product!.condition!;
      checkInDate = DateTime.parse(widget.product!.checkIn!).toLocal();
      checkInTime =
          TimeOfDay(hour: checkInDate!.hour, minute: checkInDate!.minute);
      checkOutDate = DateTime.parse(widget.product!.checkOut!).toLocal();
     
      checkOutTime =
          TimeOfDay(hour: checkOutDate!.hour, minute: checkOutDate!.minute);
      descriptionTextController =
          TextEditingController(text: widget.product!.productDescription!);
      priceTextController =
          TextEditingController(text: widget.product!.productPrice!.toString());
      adTitletextController =
          TextEditingController(text: widget.product!.productName!);
      brandtextController = TextEditingController(text: widget.product!.brand);
      receiptImage = widget.product!.buyingReceipt!.isNotEmpty
          ? File(widget.product!.buyingReceipt!.first)
          : null;
      if (widget.product!.productSampleImages!.isNotEmpty) {
        for (var i = 0; i < widget.product!.productSampleImages!.length; i++) {
          productImages.add(File(widget.product!.productSampleImages![i]));
        }
      }
      widget.subCategory = widget.product!.category;
      descriptionTextController.addListener(() {
        String text = descriptionTextController.text;
        if (text.length > descriptionMaxLength) {
          text = text.substring(0, descriptionMaxLength);
          descriptionTextController.selection = TextSelection.fromPosition(
            TextPosition(offset: descriptionMaxLength),
          );

          Helper.showMessage(
              "Maximum length of $descriptionMaxLength reached.");
        }
      });
      adTitletextController.addListener(() {
        String text = adTitletextController.text;
        if (text.length > titleMaxLength) {
          text = text.substring(0, titleMaxLength);
          adTitletextController.selection = TextSelection.fromPosition(
            TextPosition(offset: titleMaxLength),
          );

          Helper.showMessage("Maximum length of $titleMaxLength reached.");
        }
      });
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: CommonScreenTemplateWidget(
          title: "Ad Detail",
          leadingWidget: const CustomBackButtonWidget(),
          child: ListView(
            padding: EdgeInsets.only(
                left: AppStyles.screenHorizontalPadding,
                right: AppStyles.screenHorizontalPadding,
                bottom: 40.r),
            children: [
              if (widget.subCategory != null) ...[
                GenericTranslateWidget( 
                  "Category",
                  style: context.textStyle.displayMedium!
                      .copyWith(fontSize: 18.sp),
                ),
                10.ph,
                CategoryTitleWidget(
                  parentCategory: widget.category,
                  subCategory: widget.subCategory,
                ),
              ],
              10.ph,
              if (productImages.isNotEmpty) ...[
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    productImages.length,
                    (index) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () => AppRouter.push(
                            FullImageView(
                              imagePath: productImages[index].path,
                            ),
                          ),
                          child: Container(
                            width: 50.r,
                            height: 50.r,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                    image: productImages[index]
                                            .path
                                            .contains('http')
                                        ? NetworkImage(
                                            productImages[index].path)
                                        : FileImage(
                                            productImages[index],
                                          ),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                            top: -20,
                            right: -20,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  productImages.removeAt(index);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  size: 18,
                                  color: Colors.red,
                                )))
                      ],
                    ),
                  ),
                ),
                10.ph
              ],
              UploadProductImagesWidget(
                onTap: () async {
                  if (productImages.length > 5) {
                    Helper.showMessage("Maximum 5 images allowed");
                    return;
                  }
                  // selectProductImages();
                  // _showPicker(context);
                  final List<File> images = await ImageSelector.selectImages(
                    context: context,
                    maxImages: 5 - productImages.length,
                    compressImageFn:
                        Helper.compressImage, // your compression method
                  );

                  if (images.isNotEmpty && productImages.length < 5) {
                    setState(() {
                      productImages.addAll(images);
                    });
                  }
                },
              ),
              20.ph,
              const TitleHeadingWidget(
                title: "Condition",
              ),
              12.ph,
              Row(
                children: [
                  SelectChip(
                    isCheck: condition == "New",
                    title: "New",
                    onTap: () {
                      condition = "New";
                      setState(() {});
                    },
                  ),
                  5.pw,
                  SelectChip(
                    isCheck: condition == "Used",
                    title: "Used",
                    onTap: () {
                      condition = "Used";
                      setState(() {});
                    },
                  ),
                ],
              ),
              20.ph,
              const TitleHeadingWidget(
                title: "Brand",
              ),
              12.ph,
              Consumer(
                builder: (context, ref, child) {
                  return CustomTextFieldWidget(ref:ref,
                    hintText: "Enter a brand",
                    controller: brandtextController,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                    ],
                  );
                }
              ),
              20.ph,
              const TitleHeadingWidget(
                title: "Unit",
              ),
              12.ph,
              Row(
                children: [
                  Container(
                    height: 30.h,
                    padding: EdgeInsets.all(1.r),
                    decoration: BoxDecoration(
                        color: const Color(0xffEFEDEC),
                        borderRadius: BorderRadius.circular(421.r)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (quantity > 0) {
                              quantity--;
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 30.r,
                            width: 30.r,
                            padding: EdgeInsets.all(3.r),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: SvgPicture.asset(
                              Assets.minusIcon,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.r),
                          child: GenericTranslateWidget( "$quantity"),
                        ),
                        GestureDetector(
                          onTap: () {
                            quantity++;
                            setState(() {});
                          },
                          child: Container(
                            height: 30.r,
                            width: 30.r,
                            padding: EdgeInsets.all(3.r),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: SvgPicture.asset(
                              Assets.plusIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              20.ph,
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleHeadingWidget(
                        title: "Check-In",
                      ),
                      12.ph,
                      CheckInOutDateTimeWidget(
                        date: setDateGenericTranslateWidget( checkInDate ?? DateTime.now()),
                        time: setTimeGenericTranslateWidget( checkInDate ?? DateTime.now(), checkInTime ?? TimeOfDay.now()),
                        selectDate: () {
                          showDatePicker(
                            context: context,
                            initialDate: checkInDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: AppStyles.datePickerTheme,
                                child: child ?? Container(),
                              );
                            },
                          ).then((date) {
                            if (date != null) {
                              if (Helper.validateDateDifference(
                                  startDate: checkInDate ?? DateTime.now(),
                                  endDate: checkOutDate ?? DateTime.now())) {
                                checkInDate = date;
                               
                              }
                            }
                            else{
                              checkInDate = DateTime.now();
                            }
                             setState(() {});
                          });
                        },
                        selectTime: () {
                          showTimePicker(
                            context: context,
                            initialTime: checkInTime ?? TimeOfDay.now(),
                            builder: (context, child) => Theme(
                                data: AppStyles.datePickerTheme, child: child!),
                          ).then((time) {
                            
                              checkInTime = time ?? TimeOfDay.now();
                            
                             setState(() {});
                          });
                        },
                      ),
                    ],
                  )),
                  19.pw,
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleHeadingWidget(
                        title: "Check-Out",
                      ),
                      12.ph,
                      CheckInOutDateTimeWidget(
                        enable: checkInDate != null && checkInTime != null,
                        date: setDateGenericTranslateWidget( checkOutDate ?? DateTime.now()),
                        time: setTimeGenericTranslateWidget( checkOutDate ?? DateTime.now(), checkOutTime ?? TimeOfDay.now()),
                        selectDate: () {
                          if(checkInDate == null || checkInTime == null){
                            Helper.showMessage("Please select first check-in date and time");
                            return;
                          }
                          showDatePicker(
                            context: context,
                            initialDate: checkOutDate != null? checkOutDate!.isBefore(DateTime.now())
                                ? DateTime.now()
                                : checkOutDate : DateTime.now(), // Start with today's date
                            firstDate:
                                DateTime.now(), // Prevent selecting past dates
                            lastDate: DateTime(2101),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: AppStyles.datePickerTheme,
                                child: child ?? Container(),
                              );
                            },
                          ).then((date) {
                            if (date != null) {
                              if (Helper.validateDateDifference(
                                  startDate: checkInDate ?? DateTime.now(),
                                  endDate: checkOutDate ?? DateTime.now())) {
                                checkOutDate = date;
                                
                              }
                            }
                             else{
                              checkOutDate = DateTime.now();
                            }
                            setState(() {});
                          });
                        },
                        selectTime: () {
                          if(checkInDate == null || checkInTime == null){
                            Helper.showMessage("Please select first check-in date and time");
                            return;
                          }
                          showTimePicker(
                            context: context,
                            initialTime: checkOutTime ?? TimeOfDay.now(),
                            builder: (context, child) => Theme(
                                data: AppStyles.datePickerTheme, child: child!),
                          ).then((time) {
                            if (time != null) {
                              // final now = TimeOfDay.now();

                              // Convert to DateTime for comparison
                              final nowDateTime = DateTime.now();
                              final date = checkOutDate ?? DateTime.now();
                              final selectedDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );

                              if (selectedDateTime.isBefore(nowDateTime)) {
                                Helper.showMessage(
                                    "You cannot select a past time");
                              } else {
                                checkOutTime = time;
                                setState(() {});
                              }
                            }
                            else{
                              final nowDateTime = DateTime.now();
                              final date = checkOutDate ?? DateTime.now();
                              final defaultTime = TimeOfDay.now();
                              final selectedDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                defaultTime.hour,
                                defaultTime.minute,
                              );

                              if (selectedDateTime.isBefore(nowDateTime)) {
                                Helper.showMessage(
                                    "You cannot select a past time");
                              } else {
                                checkOutTime = defaultTime;
                                setState(() {});
                              }
                            }
                          });
                        },
                      ),
                    ],
                  )),
                ],
              ),
              20.ph,
              const TitleHeadingWidget(
                title: "Buying Receipt",
              ),
              12.ph,
              if (receiptImage != null) ...[
                Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () => AppRouter.push(
                            FullImageView(
                              imagePath: receiptImage!.path,
                            ),
                          ),
                          child: Container(
                            width: 50.r,
                            height: 50.r,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                    image: receiptImage!.path.contains('http')
                                        ? NetworkImage(receiptImage!.path)
                                        : FileImage(
                                            receiptImage!,
                                          ),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                            top: -20,
                            right: -20,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  receiptImage = null;
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  size: 18,
                                  color: Colors.red,
                                )))
                      ],
                    ),
                  ],
                ),
                10.ph,
              ],
              GestureDetector(
                onTap: () {
                  selectReceipt();
                },
                child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 14.r),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.borderColor,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GenericTranslateWidget( 
                        "Upload Purchasing Receipt",
                        style: context.textStyle.bodyMedium!.copyWith(
                            color: Colors.black.withValues(alpha: 0.5)),
                      ),
                      SvgPicture.asset(
                        Assets.addDocumentIcon,
                        width: 20.r,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.5),
                            BlendMode.srcIn),
                      )
                    ],
                  ),
                ),
              ),
              20.ph,
              const Divider(),
              20.ph,
              const TitleHeadingWidget(
                title: "Ad Title",
              ),
              12.ph,
              Consumer(
                builder: (context, ref, child) {
                  return CustomTextFieldWidget(ref:ref,
                    hintText: "Enter title",
                    controller: adTitletextController,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a title";
                      } else if (value.length < 3) {
                        return 'Title must be at least 3 characters';
                      } else if (value.length > titleMaxLength) {
                        return 'Title must be less than $titleMaxLength characters';
                      }
                      return null;
                    },
                  );
                }
              ),
              20.ph,
              const TitleHeadingWidget(
                title: "Description",
              ),
              12.ph,
              Consumer(
                builder: (context, ref, child) {
                  return CustomTextFieldWidget(ref:ref,
                    hintText: "Describe the item you are selling",
                    maxline: 4,
                    minLines: 4,
                    controller: descriptionTextController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a description";
                      } else if (Helper.convertToHtml(value.trim()).length < 3) {
                        return "Description must be at least 3 characters";
                      } else if (Helper.convertToHtml(value.trim()).length >
                          descriptionMaxLength) {
                        return 'Description must be less than $descriptionMaxLength characters';
                      }
                      return null;
                    },
                  );
                }
              ),
              20.ph,
              const TitleHeadingWidget(
                title: "Select Location",
              ),
              12.ph,
              Consumer(
                builder: (_, WidgetRef ref, __) {
                  final location =
                      ref.watch(currentLocationProvider).currentLocation;
                  return LocationWidget(
                    lat: widget.product == null
                        ? location.lat
                        : widget.product!.locationData!.lat,
                    long: widget.product == null
                        ? location.lon
                        : widget.product!.locationData!.lon,
                    isSetLoaction: true,
                  );
                },
              ),
              20.ph,
              const Divider(),
              20.ph,
              const TitleHeadingWidget(
                title: "Price",
              ),
              12.ph,
              Consumer(
                builder: (context, ref, child) {
                  return CustomTextFieldWidget(ref:ref,
                      hintText: "Enter Price",
                      controller: priceTextController,
                      // onChanged: (value) {
                      //   formatInput();
                      // },
                      validator: (value) {
                        final price = double.tryParse(value ?? '');
                  
                        if (price == null || price <= 0) {
                          return 'Enter a valid number';
                        }
                        if (price > 999999.99) return 'Price exceeds maximum limit';
                  
                        if (value == null || value.isEmpty) {
                          return "Please enter a price";
                        }
                        final RegExp decimalRegex = RegExp(
                            r'^\d+(\.\d{1,2})?$'); // Allows up to 2 decimal places
                        if (!decimalRegex.hasMatch(value)) {
                          return "Enter a valid decimal number (e.g., 20.00)";
                        }
                        return null;
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                        PriceInputFormatter(maxValue: 999999.99),
                        NoZeroLeadingFormatter()
                        // SinglePeriodEnforcer()
                      ]);
                }
              ),
              50.ph,
              Consumer(builder: (context, ref, child) {
                final isLoad =
                    ref.watch(productDataProvider).createAdApiResponse.status;
                return CustomButtonWidget(
                    title: widget.product != null ? "Save" : "Next",
                    isLoad: isLoad == Status.loading,
                    onPressed: () {
                      if(checkInDate == null || checkInTime  == null)
                      {
                        Helper.showMessage("Please select check-in date and time");
                        return;
                      }
                      if(checkOutDate == null || checkOutTime  == null)
                      {
                        Helper.showMessage("Please select check-out date and time");
                        return;
                      }

                      ref.read(bottomIndexProvider.notifier).setIndex(0);
                      final location =
                          ref.watch(currentLocationProvider).currentLocation;
                      DateTime checkInDateTime = DateTime(
                        checkInDate!.year,
                        checkInDate!.month,
                        checkInDate!.day,
                        checkInTime!.hour,
                        checkInTime!.minute,
                      ).toUtc();
                      DateTime checkOutDateTime = DateTime(
                        checkOutDate!.year,
                        checkOutDate!.month,
                        checkOutDate!.day,
                        checkOutTime!.hour,
                        checkOutTime!.minute,
                      ).toUtc();
                      if (receiptImage != null &&
                          productImages.isNotEmpty &&
                          formKey.currentState!.validate() &&
                          condition != "" &&
                          quantity > 0) {
                        if (widget.product != null) {
                          final List<String> imageStringList =
                              List.from(productImages
                                  .where(
                                    (element) => element.path.contains('http'),
                                  )
                                  .map((e) => e.path));
                          final List<File> imageList =
                              List.from(productImages.where(
                            (element) => !(element.path.contains('http')),
                          ));
                          Map<String, dynamic> data = {
                            "id": widget.product!.id!,
                            "check_in": Helper.formatDateTime(checkInDateTime),
                            "check_out":
                                Helper.formatDateTime(checkOutDateTime),
                            "condition": condition,
                            "buying_receipt":
                                receiptImage!.path.contains('http')
                                    ? [receiptImage!.path]
                                    : [],
                            "images":
                                imageStringList.isEmpty ? [] : imageStringList,
                            "description": Helper.convertToHtml(
                                descriptionTextController.text.trim()),
                            "location": {
                              "address_line": location.placeName,
                              "city": location.cityName,
                              "country": "",
                              "lat": location.lat,
                              "lon": location.lon,
                              "state": ""
                            },
                            "price": double.tryParse(priceTextController.text),
                            "title": adTitletextController.text.trim(),
                            "unit": quantity,
                            "brands": brandtextController.text.isEmpty
                                ? null
                                : brandtextController.text.trim(),
                          };
                          appLog("Data $data");
                          ref.read(productDataProvider).updateAd(
                              data,
                              imageList.isNotEmpty ? imageList : null,
                              !(receiptImage!.path.contains('http'))
                                  ? [receiptImage!]
                                  : null,
                              widget.index!);
                        } else {
                          Map<String, dynamic> data = {
                            "category_id": widget.subCategory!.id,
                            "check_in": Helper.formatDateTime(checkInDateTime),
                            "brands": brandtextController.text.isEmpty
                                ? null
                                : brandtextController.text.trim(),
                            "check_out":
                                Helper.formatDateTime(checkOutDateTime),
                            "condition": condition,
                            "description": Helper.convertToHtml(
                                descriptionTextController.text.trim()),
                            "location": {
                              "address_line": location.placeName,
                              "city": location.cityName,
                              "country": "",
                              "lat": location.lat,
                              "lon": location.lon,
                              "state": ""
                            },
                            "price": double.tryParse(priceTextController.text),
                            "title": adTitletextController.text.trim(),
                            "unit": quantity
                          };
                          appLog("Data $data");
                          ref
                              .read(productDataProvider)
                              .createAd(data, productImages, [receiptImage!]);
                        }
                      } else {
                        if (productImages.isEmpty) {
                          Helper.showMessage("Please select product images");
                        } else if (receiptImage == null) {
                          Helper.showMessage("Please select receipt image");
                        } else if (condition == "") {
                          Helper.showMessage("Please select condition");
                        } else if (quantity == 0) {
                          Helper.showMessage("Please select quantity");
                        }
                      }
                      // AppRouter.push(const AdPreviewView());
                    });
              }),
              20.ph
            ],
          )),
    );
  }
}

class LocationWidget extends StatefulWidget {
  final double lat;
  final double long;
  final bool? isSetLoaction;

  const LocationWidget(
      {super.key,
      required this.lat,
      required this.long,
      this.isSetLoaction = false});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 118.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CustomGoogleMapWidget(
              lat: widget.lat,
              long: widget.long,
            ),
          ),
        ),
        Container(
          height: 118.h,
          decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10.r)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.isSetLoaction!) {
                  AppRouter.push(const SelectLocationView());
                } else {
                  Helper.openMap(widget.lat, widget.long);
                }
              },
              child: Container(
                height: 32.h,
                width: 112.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(500.r)),
                child: GenericTranslateWidget( 
                  "Location",
                  style: context.textStyle.displayMedium!.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class CheckInOutDateTimeWidget extends StatelessWidget {
  final VoidCallback selectDate;
  final VoidCallback selectTime;
  final String date;
  final String time;
  final bool enable;

  const CheckInOutDateTimeWidget(
      {super.key,
      required this.date,
      required this.time,
      required this.selectDate,
      this.enable = true,
      required this.selectTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.borderColor,
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GenericTranslateWidget( 
                "Date:",
                style: context.textStyle.bodyMedium,
              ),
              GestureDetector(
                onTap: selectDate,
                child: Container(
                  height: 29.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 6.r),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500.r),
                      color: enable ? const Color(0xffEAF8FF) : Colors.grey.shade200,
                      border: Border.all(
                        color: AppColors.borderColor,
                      )),
                  child: GenericTranslateWidget( 
                    date,
                    style: enable ? context.textStyle.displayMedium : context.textStyle.displayMedium!.copyWith(
                      color: Colors.grey
                    ),
                  ),
                ),
              )
            ],
          ),
          4.ph,
          const Divider(),
          4.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GenericTranslateWidget( 
                "Time:",
                style: context.textStyle.bodyMedium,
              ),
              GestureDetector(
                onTap: selectTime,
                child: Container(
                  height: 29.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 6.r),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500.r),
                      color:  enable ? const Color(0xffEAF8FF) : Colors.grey.shade200 ,
                      border: Border.all(
                        color: AppColors.borderColor,
                      )),
                  child: GenericTranslateWidget( 
                    time,
                    style: enable ? context.textStyle.displayMedium : context.textStyle.displayMedium!.copyWith(
                      color: Colors.grey
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class SelectChip extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const SelectChip(
      {super.key,
      required this.isCheck,
      required this.title,
      required this.onTap});

  final bool isCheck;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 29.h,
        padding: EdgeInsets.only(left: 10.r, right: 10.r, top: 3.r),
        decoration: BoxDecoration(
            color: !isCheck ? AppColors.secondaryColor1 : null,
            gradient: isCheck ? AppColors.primaryGradinet : null,
            borderRadius: BorderRadius.circular(500.r),
            border: !isCheck ? Border.all(color: AppColors.borderColor) : null),
        child: GenericTranslateWidget( 
          title,
          style: context.textStyle.bodySmall!
              .copyWith(color: isCheck ? Colors.white : null),
        ),
      ),
    );
  }
}

class TitleHeadingWidget extends StatelessWidget {
  final String title;
  const TitleHeadingWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GenericTranslateWidget( 
      title,
      style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
    );
  }
}

class UploadProductImagesWidget extends StatelessWidget {
  final VoidCallback onTap;
  const UploadProductImagesWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 169.h,
        padding: EdgeInsets.symmetric(vertical: 15.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.borderColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(Assets.uploadGalleryImageIcon),
            Container(
              width: 125.w,
              height: 36.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500.r),
                  color: AppColors.secondaryColor1,
                  border: Border.all(color: AppColors.borderColor)),
              child: GenericTranslateWidget( 
                "Add Images",
                style: context.textStyle.bodySmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 90.r),
              child: GenericTranslateWidget( 
                "3MB maximum file size accepted in the following formats .jpg .jpeg png .gif",
                textAlign: TextAlign.center,
                style: context.textStyle.bodySmall!.copyWith(
                  color: Colors.black.withValues(alpha: 0.8),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTitleWidget extends StatelessWidget {
  const CategoryTitleWidget(
      {super.key, required this.parentCategory, required this.subCategory});

  final CategoryDataModel? parentCategory;
  final CategoryDataModel? subCategory;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4.0),
      horizontalTitleGap: 15.r,
      leading: Container(
        height: 62.r,
        width: 62.r,
        decoration: BoxDecoration(
            color: context.colors.onInverseSurface,
            borderRadius: BorderRadius.circular(5000.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5000.r),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: -20,
                bottom: -1,
                child: ClipRRect(
                  clipBehavior: Clip.none,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(500.r)),
                  child: DisplayNetworkImage(
                    imageUrl: parentCategory == null
                        ? subCategory!.imageUrl
                        : parentCategory!.imageUrl,
                    width: 70.r,
                    height: 40.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      title: GenericTranslateWidget( 
        parentCategory != null ? parentCategory!.title : subCategory!.title,
        style: context.textStyle.bodyMedium!
            .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      subtitle: parentCategory != null
          ? GenericTranslateWidget( 
              subCategory!.title,
              style: context.textStyle.bodyMedium,
            )
          : null,
    );
  }
}

setDateGenericTranslateWidget( DateTime date) {
  return DateFormat("d MMM yyyy").format(date).toLowerCase();
}

setTimeGenericTranslateWidget( DateTime date, TimeOfDay time) {
  DateTime dateTime =
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
  return DateFormat("h:mm a").format(dateTime);
}

class SinglePeriodEnforcer extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    // Allow only one period
    if ('.'.allMatches(newText).length <= 1) {
      return newValue;
    }
    return oldValue;
  }
}

class PriceInputFormatter extends TextInputFormatter {
  final double maxValue;

  PriceInputFormatter({required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Prevent multiple decimals
    if ('.'.allMatches(text).length > 1) return oldValue;

    // Limit decimal precision
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts[1].length > 2) return oldValue;
    }

    // Prevent overly large numbers
    final parsed = double.tryParse(text);
    if (parsed != null && parsed > maxValue) return oldValue;

    return newValue;
  }
}

class NoZeroLeadingFormatter extends TextInputFormatter {
  // Regular expression to allow numbers starting from 1-9, and allow decimals up to 2 digits
  final RegExp _regExp = RegExp(r'^[1-9]\d*(\.\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Allow empty input to enable typing
    if (text.isEmpty) {
      return newValue;
    }

    // Disallow if the input starts with 0 and is not just a 0
    if (text.startsWith('0') && text.length > 1 && !text.startsWith('0.')) {
      return oldValue;
    }

    // If the number starts from 1-9 and is followed by valid digits or decimal
    if (!_regExp.hasMatch(text)) {
      return oldValue;
    }

    return newValue;
  }
}
