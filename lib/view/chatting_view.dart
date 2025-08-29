import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class ChattingView extends ConsumerStatefulWidget {
  final bool isPaid;
  final UserDataModel? user;
  final ProductDetailDataModel? ad;
  final bool? isButtonEnable;
  final int? chatId;

  const ChattingView(
      {super.key,
      this.isPaid = false,
      this.chatId,
      this.ad,
      this.user,
      this.isButtonEnable = false});

  @override
  ConsumerState<ChattingView> createState() => _ChattingViewConsumerState();
}

class _ChattingViewConsumerState extends ConsumerState<ChattingView> {
  late final TextEditingController controller;
  late final ScrollController scrollController;
  List<File> images = [];
  Future<void> selectProductImages() async {
    controller.clear();
    try {
      // Check current count before selection
      // if (images.length >= 5) {
      //   Helper.showMessage("Maximum 5 images allowed");
      //   return;
      // }

      // final FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowMultiple: false,
      //   allowedExtensions: ['jpg', 'png', 'jpeg'],
      // );

      // if (result == null) return;

      // final List<File> validFiles = [];
      // int remainingSlots = 5 - images.length;

      // for (final platformFile in result.files) {
      //   // Stop processing if we've filled all available slots
      //   if (remainingSlots <= 0) break;

      //   final file = File(platformFile.path!);

      //   // Check individual file size
      //   final fileSize = await file.length(); // Async size check
      //   if (fileSize > maxTotalSize) {
      //     Helper.showMessage("'${platformFile.name}' exceeds 3MB limit");
      //     continue;
      //   }

      //   validFiles.add(file);
      //   remainingSlots--;
      // }

      // // Add all valid files at once
      // if (validFiles.isNotEmpty) {
      //   images.addAll(validFiles);
      //   setState(() {});
      // }

      // Show message if some files couldn't be added
      // final totalSelected = result.files.length;
      // final addedCount = validFiles.length;
      // if (addedCount < totalSelected) {
      //   final skipped = totalSelected - addedCount;
      //   Helper.showMessage(
      //       "Added $addedCount images ($skipped skipped due to limits)");
      // }

      final result = await ImageSelector.selectImages(
        context: context,
        maxImages: 1,
        compressImageFn: Helper.compressImage,
      );
      if (result.isEmpty) return;
      images.addAll(result);
      setState(() {
        
      });
    } catch (e) {
      Helper.showMessage("Error selecting images: ${e.toString()}");
    }
  }

  @override
  void initState() {
    controller = TextEditingController();
    scrollController = ScrollController();
    if (widget.chatId != null) {
      Future.delayed(Duration.zero, () {
        ref
            .read(chatRepoProvider)
            .getMessageList(limit: 20, cursor: null, id: widget.chatId!);
      });
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          Future.delayed(Duration.zero, () {
            String? cursor = ref.watch(chatRepoProvider).messageListCursor;

            ref
                .watch(chatRepoProvider)
                .getMessageList(limit: 10, cursor: cursor, id: widget.chatId!)
                .whenComplete(() {
              scrollController
                  .jumpTo(scrollController.position.minScrollExtent + 20);
            });
                    });
        }
      });
    } else {
      Future.delayed(Duration.zero, () {
        ref.read(chatRepoProvider).setResponse();
      });
    }
    super.initState();
  }

  Future<void> scrollUp(BuildContext context) async {
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiResponse =
        ref.watch(chatRepoProvider).getChatMessageApiResponse.status;
    final provider = ref.watch(chatRepoProvider);
    final List<MessageDataModel> list = apiResponse == Status.loading
            ? List.generate(
                8,
                (index) => MessageDataModel(
                  id: -1,
                  message: "sahdfahsfd",
                  time: "2025-02-20T06:21:47.601Z",
                  isSender: index % 2 == 0,
                ),
              )
            : provider.messages
        // List.from(provider.messageMap.entries.map(
        //     (e) => e.value,
        //   ))
        ;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor1,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height + 40.h),
          child: ChatTopWidget(
            imageUrl: widget.user?.picture ?? "",
            name: widget.user?.userName ?? "",
            showMoreOpt: provider.chatId != null,
            onOptionTap: () {
              final chatId = ref.watch(chatRepoProvider).chatId;
              if(chatId != null){
                showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        AppRouter.back();
                      },
                      child: GenericTranslateWidget( 
                        "No",
                        style: context.textStyle.displayMedium!
                            .copyWith(fontSize: 18.sp),
                      ),
                    ),
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final isLoad = ref
                            .watch(chatRepoProvider)
                            .deleteChatApiResponse
                            .status;
                        return isLoad == Status.loading
                            ? const CircularProgressIndicator()
                            : TextButton(
                                onPressed: () {
                                  ref.read(chatRepoProvider).deleteAdChatQuery(
                                      id: chatId);
                                },
                                child: GenericTranslateWidget( 
                                  "Yes",
                                  style: context.textStyle.displayMedium!
                                      .copyWith(fontSize: 18.sp),
                                ),
                              );
                      },
                    ),
                  ],
                  content: Row(
                    children: [
                      Expanded(
                        child: GenericTranslateWidget( 
                          "Are you sure to delete this chat?",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontSize: 20.sp),
                        ),
                      )
                    ],
                  ),
                ),
              );
          
              }
                },
            onBackTap: null,
          )),
      body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: Padding(
            padding: EdgeInsets.only(
                left: AppStyles.screenHorizontalPadding,
                right: AppStyles.screenHorizontalPadding,
                top: AppStyles.screenHorizontalPadding),
            child: Column(
              children: [
                BuyingProductTitleWidget(
                  productImage: widget.ad?.productImage ?? "",
                  productPrice: "${widget.ad?.productPrice}",
                  productTitle: "${widget.ad?.productName}",
                  isButtonEnable:
                      !widget.isButtonEnable! && widget.ad?.status == "Active",
                  isPaid: widget.isPaid,
                  onTap: widget.isPaid
                      ? () {
                          // AppRouter.back();
                        }
                      : () {
                          AppRouter.push(CheckoutView(product: widget.ad));
                        },
                ),
                Expanded(
                    child: apiResponse == Status.error
                        ? CustomErrorWidget(onPressed: () {
                            ref.read(chatRepoProvider).getMessageList(
                                limit: 20, cursor: null, id: widget.chatId!);
                          })
                        : list.isNotEmpty
                            ? Skeletonizer(
                                enabled: apiResponse == Status.loading,
                                child: ListView.builder(
                                  reverse: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(vertical: 20.r),
                                  itemCount: apiResponse == Status.loadingMore
                                      ? list.length + 1
                                      : list.length,
                                  itemBuilder: (context, index) {
                                    final item = index < list.length
                                        ? list[index]
                                        : null;
                                    final currentDate = item != null
                                        ? DateTime.parse(item.time)
                                        : null; // Assuming time is stored as String
                                    final previousDate = index < list.length - 1
                                        ? DateTime.parse(list[index + 1].time)
                                        : null;

                                    bool showDateHeader = currentDate != null &&
                                            previousDate == null ||
                                        currentDate?.day != previousDate?.day ||
                                        currentDate?.month !=
                                            previousDate?.month ||
                                        currentDate?.year != previousDate?.year;

                                    return apiResponse == Status.loadingMore &&
                                            index == list.length
                                        ? const CustomLoadingWidget()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              if (showDateHeader)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.r),
                                                  child: GenericTranslateWidget( 
                                                    Helper.formatDate(
                                                        currentDate!),
                                                    style: context
                                                        .textStyle.bodySmall!
                                                        .copyWith(
                                                            fontSize: 10.sp),
                                                  ),
                                                ),
                                              ChatBubbleWidget(
                                                  item: item!,
                                                  isSender: item.isSender)
                                              // item!.isSender
                                              //     ? SenderMessageWidget(
                                              //         item: item,
                                              //       )
                                              //     : ReceiverMessageWidget(
                                              //         item: item,
                                              //         userImage: widget
                                              //                 .user?.picture ??
                                              //             ""),
                                            ],
                                          );
                                  },
                                ))
                            : const SizedBox.shrink()),
                if (widget.ad?.status == "Active")
                  ChattingSendBoxWidget(
                    textEditingController: controller,
                    hintText: Helper.getCachedTranslation(ref: ref, text: "Send a message..."),
                    files: images,
                    onGallerySelect: () {
                      selectProductImages();
                    },
                    removeImage: () {
                      images.clear();
                      setState(() {});
                    },
                    onSendTap: () {
                      if (controller.text != "") {
                        if (widget.ad != null && widget.ad!.id! > -1) {
                          ref.read(chatRepoProvider).createAdChat(
                              message: controller.text,
                              adId: widget.ad!.id!,
                              id: widget.chatId,
                              file: null);
                          controller.clear();
                        }
                      }
                      if (images.isNotEmpty) {
                        ref.read(chatRepoProvider).createAdChat(
                            message: controller.text,
                            adId: widget.ad!.id!,
                            id: widget.chatId,
                            file: images.first);
                        images.clear();
                      }
                    },
                  ),
                if (widget.ad?.status != "Active")
                  Center(
                    child: GenericTranslateWidget( widget.ad?.status == "Sold"
                        ? "This Product is Sold Out"
                        : "This Product is Expired"),
                  )
              ],
            ),
          )),
    );
  }
}

class BuyingProductTitleWidget extends StatelessWidget {
  final String productImage;
  final String productTitle;
  final String productPrice;
  final bool isButtonEnable;
  final VoidCallback? onTap;
  final bool? isPaid;
  const BuyingProductTitleWidget(
      {super.key,
      this.isButtonEnable = false,
      this.isPaid = false,
      required this.productImage,
      required this.productPrice,
      required this.productTitle,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: DisplayNetworkImage(
            imageUrl: productImage,
            width: 83.r,
            height: 81.r,
          ),
        ),
        10.pw,
        Expanded(
            child: SizedBox(
          height: 81.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GenericTranslateWidget( 
                productTitle,
                overflow: TextOverflow.ellipsis,
                maxLines: isButtonEnable ? 1 : 2,
                style: context.textStyle.displayMedium,
              ),
              GenericTranslateWidget( 
                "\$$productPrice",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: context.textStyle.headlineMedium!.copyWith(
                    height: 0.9, fontWeight: FontWeight.w700, fontSize: 20.sp),
              ),
              if (isButtonEnable) ...[
                3.ph,
                Row(
                  children: [
                    isPaid!
                        ? GestureDetector(
                            onTap: onTap,
                            child: Container(
                              padding: EdgeInsets.all(1.r),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(500.r),
                                  gradient: AppColors.primaryGradinet),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10.r,
                                    right: 10.r,
                                    top: 10.r,
                                    bottom: 2.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(500.r),
                                ),
                                child: GenericTranslateWidget( 
                                  "Payment Paid",
                                  textAlign: TextAlign.center,
                                  style: context.textStyle.displaySmall!
                                      .copyWith(
                                          height: 0.3,
                                          foreground: AppColors.gradientPaint),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: onTap,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10.r,
                                  right: 10.r,
                                  top: 10.r,
                                  bottom: 2.r),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(500.r),
                                  border: Border.fromBorderSide(BorderSide(
                                      color: context.colors.onSurfaceVariant))),
                              child: GenericTranslateWidget( 
                                "Buy Now",
                                textAlign: TextAlign.center,
                                style: context.textStyle.displaySmall!.copyWith(
                                  height: 0.3,
                                ),
                              ),
                            ),
                          ),
                  ],
                )
              ],
              const Spacer()
            ],
          ),
        )),
      ],
    );
  }
}

// class SenderMessageWidget extends StatelessWidget {
//   final MessageDataModel item;
//   const SenderMessageWidget({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 5.r),
//               constraints: BoxConstraints(
//                   minWidth: 0.0, maxWidth: context.screenwidth * 0.8),
//               decoration: BoxDecoration(
//                   color: context.colors.primary,
//                   borderRadius: BorderRadius.circular(20.r)),
//               child: item.isMedia
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 80.r,
//                           width: 80.r,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5.r),
//                               color: Colors.white),
//                         ),
//                         4.ph,
//                         GenericTranslateWidget( 
//                           item.message,
//                           style: context.textStyle.bodyMedium!
//                               .copyWith(color: Colors.white),
//                         ),
//                       ],
//                     )
//                   : GenericTranslateWidget( 
//                       item.message,
//                       style: context.textStyle.bodyMedium!
//                           .copyWith(color: Colors.white),
//                     ),
//             ),
//             GenericTranslateWidget( 
//               item.isDelivered ? Helper.setTime(item.time) : "Sending...",
//               style: context.textStyle.bodyMedium!.copyWith(fontSize: 10.sp),
//             ),
//             10.ph
//           ],
//         )
//       ],
//     );
//   }
// }

class ReceiverMessageWidget extends StatelessWidget {
  final MessageDataModel item;
  final String userImage;
  const ReceiverMessageWidget(
      {super.key, required this.item, required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserProfileWidget(radius: 20.r, imageUrl: userImage),
        5.pw,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
              constraints: BoxConstraints(
                  minWidth: 0.0, maxWidth: context.screenwidth * 0.8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.r)),
              child: GenericTranslateWidget( 
                item.message,
                style: context.textStyle.bodyMedium!,
              ),
            ),
            GenericTranslateWidget( 
              Helper.setTime(item.time),
              style: context.textStyle.bodyMedium!.copyWith(fontSize: 10.sp),
            ),
            10.ph
          ],
        )
      ],
    );
  }
}

class SenderMessageWidget extends StatelessWidget {
  final MessageDataModel item;
// Callback for retrying failed messages

  const SenderMessageWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 5.r),
              constraints: BoxConstraints(
                minWidth: 0.0,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: item.isMedia
                  ? _buildMediaContent(context)
                  : _buildTextMessage(context),
            ),
            _buildStatus(context),
            10.ph
          ],
        )
      ],
    );
  }

  /// Builds the message content for media (single, multiple images)
  Widget _buildMediaContent(BuildContext context) {
    if (item.mediaUrls!.length > 4) {
      // Show only first 3 images + "View All" overlay
      return GestureDetector(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 4.r,
              runSpacing: 4.r,
              children: item.mediaUrls!.take(3).map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    url,
                    height: 100.r,
                    width: 100.r,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            Container(
              alignment: Alignment.center,
              height: 100.r,
              width: 100.r,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: GenericTranslateWidget( 
                "+${item.mediaUrls!.length - 3}",
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
            ),
          ],
        ),
      );
    } else {
      // Show images normally
      return GestureDetector(
        onTap: () {},
        child: Wrap(
          spacing: 4.r,
          runSpacing: 4.r,
          children: item.mediaUrls!.map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                url,
                height: 100.r,
                width: 100.r,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.white),
              ),
            );
          }).toList(),
        ),
      );
    }
  }

  /// Builds text-only message content
  Widget _buildTextMessage(BuildContext context) {
    return GenericTranslateWidget( 
      item.message,
      style: context.textStyle.bodyMedium!.copyWith(color: Colors.white),
    );
  }

  /// Builds message status UI (sending, sent, failed)
  Widget _buildStatus(BuildContext context) {
    if (item.isFailed) {
      return Row(
        children: [
          Icon(Icons.error, color: Colors.red, size: 14.sp),
          4.pw,
          GestureDetector(
            onTap: () {},
            child: GenericTranslateWidget( 
              "Failed to send. Tap to retry.",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 10.sp, color: Colors.red),
            ),
          ),
        ],
      );
    } else {
      return GenericTranslateWidget( 
        item.isDelivered ? Helper.setTime(item.time) : "Sending...",
        style: context.textStyle.bodyMedium!.copyWith(fontSize: 10.sp),
      );
    }
  }
}

class ChatBubbleWidget extends StatelessWidget {
  final MessageDataModel item;
  final bool isSender;
  final String? userImage;
  final VoidCallback? onRetry;

  const ChatBubbleWidget({
    super.key,
    required this.item,
    required this.isSender,
    this.userImage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender) ...[
          UserProfileWidget(radius: 20.r, imageUrl: userImage ?? ""),
          5.pw,
        ],
        Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: item.isMedia
                  ? null
                  : EdgeInsets.symmetric(
                      horizontal: !item.isMedia ? 12.r : 5.r, vertical: 5.r),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: item.isMedia
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: context.colors.primaryContainer)
                  : BoxDecoration(
                      color: isSender ? context.colors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: isSender ? null : Border.all(color: Colors.black),
                    ),
              child: item.isMedia
                  ? showImage(context)
                  : _buildTextMessage(context),
            ),
            _buildStatus(context),
            10.ph
          ],
        ),
      ],
    );
  }

  Widget showImage(BuildContext context) {
    return GestureDetector(
        onTap: () => _openFullScreenGallery(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  image: DecorationImage(
                      image: item.isDelivered
                          ? NetworkImage(
                              "${BaseApiServices.imageURL}${item.message}")
                          : FileImage(File(item.message)))),
            ),
            if (!item.isDelivered) ...[
              const CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ],
        ));
  }

  /// Builds media content (single, multiple images, full-screen viewer)
  Widget buildMediaContent(BuildContext context) {
    // if (item.mediaUrls!.length > 4) {
    return GestureDetector(
        onTap: () => _openFullScreenGallery(context),
        child: Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: item.message.contains('http')
                      ? NetworkImage(
                          "${BaseApiServices.imageURL}${item.message}")
                      : FileImage(File(item.message)))),
        )
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Wrap(
        //       spacing: 4.r,
        //       runSpacing: 4.r,
        //       children: item.mediaUrls!.take(3).map((url) {
        //         return _imageWidget(url);
        //       }).toList(),
        //     ),
        //     Container(
        //       alignment: Alignment.center,
        //       height: 100.r,
        //       width: 100.r,
        //       decoration: BoxDecoration(
        //         color: Colors.black45,
        //         borderRadius: BorderRadius.circular(8.r),
        //       ),
        //       child: GenericTranslateWidget( 
        //         "+${item.mediaUrls!.length - 3}",
        //         style: TextStyle(color: Colors.white, fontSize: 18.sp),
        //       ),
        //     ),
        //   ],
        // ),
        );
    // }
    // else {
    //   return GestureDetector(
    //     onTap: () => _openFullScreenGallery(context),
    //     child: Wrap(
    //       spacing: 4.r,
    //       runSpacing: 4.r,
    //       children: item.mediaUrls!.map((url) => _imageWidget(url)).toList(),
    //     ),
    //   );
    // }
  }

  /// Widget for displaying an image
  Widget imageWidget(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        url,
        height: 100.r,
        width: 100.r,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 50, color: Colors.white),
      ),
    );
  }

  /// Opens the full-screen image viewer
  void _openFullScreenGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageView(
            imageUrls: ["${BaseApiServices.imageURL}${item.message}"],
            initialIndex: 0),
      ),
    );
  }

  /// Builds text-only message content
  Widget _buildTextMessage(BuildContext context) {
    return GenericTranslateWidget( 
      item.message,
      style: context.textStyle.bodyMedium!.copyWith(
        color: isSender ? Colors.white : Colors.black,
      ),
    );
  }

  /// Builds message status UI (sending, sent, failed)
  Widget _buildStatus(BuildContext context) {
    if (isSender) {
      if (item.isFailed) {
        return Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 14.sp),
            4.pw,
            GestureDetector(
              onTap: onRetry,
              child: GenericTranslateWidget( 
                "Failed. Tap to retry.",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10.sp, color: Colors.red),
              ),
            ),
          ],
        );
      } else {
        return GenericTranslateWidget( 
          item.isDelivered ? Helper.setTime(item.time) : "Sending...",
          style: context.textStyle.bodyMedium!.copyWith(fontSize: 10.sp),
        );
      }
    } else {
      return GenericTranslateWidget( 
        Helper.setTime(item.time),
        style: context.textStyle.bodyMedium!.copyWith(fontSize: 10.sp),
      );
    }
  }
}
