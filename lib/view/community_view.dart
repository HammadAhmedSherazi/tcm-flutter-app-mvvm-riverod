
import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class CommunityView extends ConsumerStatefulWidget {
  const CommunityView({super.key});

  @override
  ConsumerState<CommunityView> createState() => _CommunityViewConsumerState();
}

class _CommunityViewConsumerState extends ConsumerState<CommunityView> {
  final TextEditingController postTextEditController = TextEditingController();
  late final ScrollController scrollController;
  // static const int maxTotalSize = 3 * 1024 * 1024;

  @override
  void initState() {
    scrollController = ScrollController();

    Future.microtask( () {
      ref.read(productDataProvider.notifier).onDispose();
      ref
          .read(communityRepoProvider)
          .getPost(cursor: null, limit: 10, myPost: false);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(communityRepoProvider).postCursor;
          Status status =
              ref.watch(communityRepoProvider).getPostApiResponse.status;

          if (status != Status.loadingMore) {
            ref
                .read(communityRepoProvider)
                .getPost(cursor: cursor, limit: 5, myPost: false);
          }
        });
      }
    });
    // postTextEditController = TextEditingController();
    super.initState();
  }

  Future<void> selectProductImages(PostDataModel? post, int? index,
      BuildContext context, bool isOpen) async {
    try {
      final selectImages = ref.watch(communityRepoProvider).selectImages;
      if (selectImages.length >= 5) {
        String msg = Helper.getCachedTranslation(ref: ref, text: "Maximum 5 images allowed");
        Helper.showMessage(msg);
        return;
      }

      // final FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowMultiple: true,
      //   allowedExtensions: ['jpg', 'png', 'jpeg'],
      // );

      // if (result == null) return;

      // final List<File> validFiles = [];
      // // int remainingSlots = 5 - productImages.length;

      // for (final platformFile in result.files) {
      //   // if (remainingSlots <= 0) break;

      //   final File originalFile = File(platformFile.path!);
      //   final int fileSize = await originalFile.length();

      //   if (fileSize > maxTotalSize) {
      //     Helper.showMessage("'${platformFile.name}' exceeds 3MB limit");
      //     continue;
      //   }

      //   // Compress Image
      //   final File? compressedFile = await Helper.compressImage(originalFile);
      //   if (compressedFile != null) {
      //     ref.read(communityRepoProvider).addImage([compressedFile.path]);

      //     // remainingSlots--;
      //   }
      // }

      // if (validFiles.isNotEmpty) {
      //   ref
      //       .read(communityRepoProvider)
      //       .addImage(List.from(validFiles.map((e) => e.path)));
      //   // Update UI
      // }

      final List<File> images = await ImageSelector.selectImages(
        context: context,
        maxImages: 5,
        compressImageFn: Helper.compressImage, // your compression method
      );

      if (images.isNotEmpty && selectImages.length < 5) {
        ref
            .read(communityRepoProvider)
            .addImage(List.from(images.map((e) => e.path)));
      }
      if (context.mounted && isOpen) {
        openSheet(context, post, index);
      }

      // final int totalSelected = result.files.length;
      // final int addedCount = validFiles.length;
      // if (addedCount < totalSelected) {
      //   final int skipped = totalSelected - addedCount;
      //   Helper.showMessage("Added $addedCount images ($skipped skipped)");
      // }
    } catch (e) {
      Helper.showMessage("Error selecting images: ${e.toString()}");
    }
  }

  void openSheet(BuildContext context, PostDataModel? post, int? index) {
    if (post != null) {
      ref.read(communityRepoProvider).addImage(post.postImages!);
    }
    final TextEditingController postTextController = post == null
        ? TextEditingController()
        : TextEditingController(text: post.postText);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important for height customization
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.9, // Opens at half screen
            minChildSize: 0.9, // Minimum size when dragged down
            maxChildSize: 0.9, // Maximum size when dragged up
            expand: false,

            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Prevents unwanted stretching
                  children: [
                    /// **Close Button at the Top Right**
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Empty space for alignment
                        IconButton(
                          visualDensity: const VisualDensity(
                              vertical: -4.0, horizontal: -4.0),
                          icon: const Icon(Icons.close, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),

                        GenericTranslateWidget( 
                          post == null ? "Create Post" : "Edit Post",
                          style: context.textStyle.displayMedium!
                              .copyWith(fontSize: 18.sp),
                        ),
                        30.pw
                      ],
                    ),

                    /// **Text Field**
                    Expanded(
                      child: TextFormField(
                        maxLines: 5,
                         onTapOutside: (c){
                            AppRouter.keyboardClose();
                          },
                        controller: postTextController,
                        decoration: InputDecoration(
                          hintText: Helper.getCachedTranslation(ref: ref, text: "What’s on your mind?") ,
                          hintStyle: context.textStyle.bodyMedium!.copyWith(
                            color:
                                context.colors.onSurfaceVariant.withAlpha(180),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final images =
                            ref.watch(communityRepoProvider).selectImages;
                        return Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 8.r,
                          spacing: 8.r,
                          children: List.generate(
                            images.length,
                            (index) => Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    AppRouter.push(
                                      FullImageView(
                                        imagePath: images[index],
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.r),
                                    child: images[index].contains('http')
                                        ? DisplayNetworkImage(
                                            imageUrl: images[index],
                                            height: 62.r,
                                            width: 73.r,
                                          )
                                        : Container(
                                            height: 62.r,
                                            width: 73.r,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: FileImage(
                                                        File(images[index])),
                                                    fit: BoxFit.cover)),
                                          ),
                                  ),
                                ),
                                Positioned(
                                    top: -20,
                                    right: -20,
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          ref
                                              .read(communityRepoProvider)
                                              .removeImage(index);
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          size: 18,
                                          color: Colors.red,
                                        )))
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const Divider(),

                    /// **Add Images Row**
                    GestureDetector(
                      onTap: () {
                        selectProductImages(post, index, context, false);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.chatGalleryIcon,
                            width: 30.r,
                            height: 30.r,
                          ),
                          10.pw,
                          Expanded(
                            child: GenericTranslateWidget( 
                              "Add Images",
                              style: context.textStyle.bodyMedium,
                            ),
                          )
                        ],
                      ),
                    ),
                    20.ph,

                    /// **Post Button**
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final images =
                            ref.watch(communityRepoProvider).selectImages;
                        final List<String> files =
                            List.from(images.where((element) {
                          return !element.contains('http');
                        }));
                        final List<String> urlPath =
                            List.from(images.where((element) {
                          return element.contains('http');
                        }));
                        return CustomButtonWidget(
                          title: post == null ? "Post" : "Update",
                          onPressed: () {
                            if (post != null) {
                              ref.read(communityRepoProvider).updatePost(
                                  content: postTextController.text,
                                  id: post.id,
                                  newImages: List.generate(
                                    files.length,
                                    (index) {
                                      return File(files[index]);
                                    },
                                  ),
                                  oldImages: urlPath,
                                  index: index!);
                            } else {
                              ref.read(communityRepoProvider).createPost(
                                  content: postTextController.text,
                                  images: images.isEmpty
                                      ? null
                                      : List.generate(
                                          files.length,
                                          (index) => File(files[index]),
                                        ));
                            }
                          },
                          isLoad: ref
                                  .watch(communityRepoProvider)
                                  .createPostApiResponse
                                  .status ==
                              Status.loading,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // void openMoreOptions(
  //     BuildContext context, bool isMyPost, PostDataModel post, int index) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             if (isMyPost) ...[
  //               ListTile(
  //                 leading: const Icon(Icons.edit),
  //                 title: const GenericTranslateWidget( "Edit Post"),
  //                 onTap: () {
  //                   AppRouter.back();
  //                   ref.read(communityRepoProvider).clearImage();
  //                   openSheet(context, post, index);
  //                 },
  //               ),
  //               ListTile(
  //                 leading: const Icon(Icons.delete, color: Colors.red),
  //                 title: const GenericTranslateWidget( "Delete Post",
  //                     style: TextStyle(color: Colors.red)),
  //                 onTap: () {
  //                   showDialog(
  //                     context: context,
  //                     builder: (context) => AlertDialog(
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(30.r)),
  //                       actions: [
  //                         TextButton(
  //                           onPressed: () {
  //                             AppRouter.back();
  //                           },
  //                           child: GenericTranslateWidget( 
  //                             "No",
  //                             style: context.textStyle.displayMedium!
  //                                 .copyWith(fontSize: 18.sp),
  //                           ),
  //                         ),
  //                         Consumer(
  //                           builder: (_, WidgetRef ref, __) {
  //                             final isLoad = ref
  //                                 .watch(communityRepoProvider)
  //                                 .createPostApiResponse
  //                                 .status;
  //                             return isLoad == Status.loading
  //                                 ? const CircularProgressIndicator()
  //                                 : TextButton(
  //                                     onPressed: () {
  //                                       ref
  //                                           .read(communityRepoProvider)
  //                                           .deletePost(
  //                                               id: post.id, index: index);
  //                                     },
  //                                     child: GenericTranslateWidget( 
  //                                       "Yes",
  //                                       style: context.textStyle.displayMedium!
  //                                           .copyWith(fontSize: 18.sp),
  //                                     ),
  //                                   );
  //                           },
  //                         ),
  //                       ],
  //                       content: Row(
  //                         children: [
  //                           Expanded(
  //                             child: GenericTranslateWidget( 
  //                               "Are you sure to delete this post?",
  //                               style: context.textStyle.displayMedium!
  //                                   .copyWith(fontSize: 20.sp),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ],
  //             if (!isMyPost) ...[
  //               ListTile(
  //                 leading: const Icon(Icons.warning, color: Colors.red),
  //                 title: const GenericTranslateWidget( "Report Post",
  //                     style: TextStyle(color: Colors.red)),
  //                 onTap: () {
  //                   // Handle delete action
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ]
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(communityRepoProvider);
    final status = provider.getPostApiResponse.status;
    final isLoad = status == Status.loading;
    final posts = isLoad
        ? List.generate(
            5,
            (index) => PostDataModel(
                id: -1,
                user: UserDataModel(
                    id: -1,
                    userName: "sagdjgasjdga",
                    picture: 'shagdhjghjdg',
                    fname: "wdass",
                    lname: "hsjdhajkdh"),
                postText: "hajshdjahsjkhasj" * 15,
                postImages: [],
                reactionCount: 0),
          )
        : provider.posts;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor1,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height +
            40.h), // Set your desired height here
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppStyles.screenHorizontalPadding,
          ),
          decoration: AppStyles.appBarStyle,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                      child: GenericTranslateWidget( 
                    "Community",
                    style: context.textStyle.displayMedium!
                        .copyWith(fontSize: 18.sp),
                  )),
                  // const CustomMessageBadgetWidget()
                ],
              ),
              10.ph,
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(communityRepoProvider)
              .getPost(cursor: null, limit: 10, myPost: false);
        },
        child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: Column(
              children: [
                Container(
                  height: 55.h,
                  margin: EdgeInsets.only(
                      left: AppStyles.screenHorizontalPadding,
                      right: AppStyles.screenHorizontalPadding,
                      top: AppStyles.screenHorizontalPadding,
                      bottom: AppStyles.screenHorizontalPadding + 10),
                  padding: EdgeInsets.symmetric(horizontal: 15.r),
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color.fromRGBO(0, 0, 0, 0.05),
                        width: 1,
                      )),
                  child: Row(
                    children: [
                      UserProfileWidget(
                          radius: 18.r,
                          imageUrl:
                              ref.watch(authRepoProvider).userData!.picture),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          onTapOutside: (c){
                            AppRouter.keyboardClose();
                          },
                          onTap: () {
                            ref.read(communityRepoProvider).clearImage();
                            openSheet(context, null, null);
                          },
                          decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10.r),
                              hintText: Helper.getCachedTranslation(ref: ref, text: "What’s on your mind?"),
                              hintStyle: context.textStyle.bodyMedium!.copyWith(
                                  color: context.colors.onSurfaceVariant
                                      .withValues(alpha: 0.7))),
                          controller: postTextEditController,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(communityRepoProvider).clearImage();
                          selectProductImages(null, null, context, true);
                        },
                        child: SvgPicture.asset(
                          Assets.chatGalleryIcon,
                          width: 20.r,
                          height: 20.r,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: status == Status.error
                      ? CustomErrorWidget(onPressed: () {
                          ref
                              .read(communityRepoProvider)
                              .getPost(cursor: null, limit: 10, myPost: false);
                        })
                      : status == Status.completed && posts.isEmpty
                          ? const ShowEmptyItemDisplayWidget(
                              message: "No Posts Founds")
                          : Skeletonizer(
                              enabled: isLoad,
                              child: ListView.builder(
                                padding: EdgeInsets.only(bottom: 40.r),
                                controller: scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: status == Status.loadingMore
                                    ? posts.length + 1
                                    : posts.length,
                                itemBuilder: (context, index) {
                                  return status == Status.loadingMore &&
                                          index == posts.length
                                      ? const CustomLoadingWidget()
                                      : PostWidget(
                                          data: posts[index],
                                          isUserShow: true,
                                          onLongPress: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (_) => EmojiReactionBar(
                                                onReactionSelected: (emoji) {
                                                  // Handle selection
                                                  ref
                                                      .read(
                                                          communityRepoProvider)
                                                      .likePost(
                                                          react: emoji,
                                                          index: index);
                                                  AppRouter.back();
                                                },
                                                emojis: Helper.emojiOptions,
                                              ),
                                            );
                                          },
                                          onTapLike: () {
                                            ref
                                                .read(communityRepoProvider)
                                                .likePost(
                                                    react: posts[index]
                                                                .myReaction !=
                                                            null
                                                        ? null
                                                        : '❤️',
                                                    index: index);
                                          },
                                          onCommentTap: () {
                                            AppRouter.push(CommentView(
                                                index: index,
                                                id: posts[index].id));
                                          },
                                          onEdit: () {
                                            ref
                                                .read(communityRepoProvider)
                                                .clearImage();
                                            openSheet(
                                                context, posts[index], index);
                                          },
                                          onDelete: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.r)),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      AppRouter.back();
                                                    },
                                                    child: GenericTranslateWidget( 
                                                      "No",
                                                      style: context.textStyle
                                                          .displayMedium!
                                                          .copyWith(
                                                              fontSize: 18.sp),
                                                    ),
                                                  ),
                                                  Consumer(
                                                    builder:
                                                        (_, WidgetRef ref, __) {
                                                      final isLoad = ref
                                                          .watch(
                                                              communityRepoProvider)
                                                          .createPostApiResponse
                                                          .status;
                                                      return isLoad ==
                                                              Status.loading
                                                          ? const CircularProgressIndicator()
                                                          : TextButton(
                                                              onPressed: () {
                                                                ref
                                                                    .read(
                                                                        communityRepoProvider)
                                                                    .deletePost(
                                                                        id: posts[index]
                                                                            .id,
                                                                        index:
                                                                            index);
                                                              },
                                                              child: GenericTranslateWidget( 
                                                                "Yes",
                                                                style: context
                                                                    .textStyle
                                                                    .displayMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            18.sp),
                                                              ),
                                                            );
                                                    },
                                                  ),
                                                ],
                                                content: Row(
                                                  children: [
                                                    Expanded(
                                                      child: GenericTranslateWidget( 
                                                        "Are you sure to delete this post?",
                                                        style: context.textStyle
                                                            .displayMedium!
                                                            .copyWith(
                                                                fontSize:
                                                                    20.sp),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          // onMoreOptTap: () {
                                          // PopupMenuButton<String>(
                                          //   onSelected: (value) {
                                          //     if (value == 'edit') {
                                          //       openSheet(context,
                                          //           posts[index], index);
                                          //     } else if (value == 'delete') {
                                          //       // Handle delete action
                                          //     }
                                          //   },
                                          //   itemBuilder:
                                          //       (BuildContext context) =>
                                          //           <PopupMenuEntry<String>>[
                                          //     const PopupMenuItem<String>(
                                          //       value: 'edit',
                                          //       child: ListTile(
                                          //         leading: Icon(
                                          //           Icons.edit,
                                          //         ), // Edit Icon
                                          //         title: GenericTranslateWidget( 'Edit'),
                                          //       ),
                                          //     ),
                                          //     const PopupMenuItem<String>(
                                          //       value: 'delete',
                                          //       child: ListTile(
                                          //         leading: Icon(Icons.delete,
                                          //             color: Colors
                                          //                 .red), // Delete Icon
                                          //         title: GenericTranslateWidget( 'Delete'),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // );
                                          // openMoreOptions(
                                          //     context,
                                          //     posts[index].isMyPost!,
                                          //     posts[index],
                                          //     index);
                                          // },
                                        );
                                },
                              )),
                ),
              ],
            )),
      ),
    );
  }
}

// ignore: must_be_immutable
class PostWidget extends StatelessWidget {
  final bool? isUserShow;
  final PostDataModel data;
  final VoidCallback? onCommentTap;
  final VoidCallback? onTapLike;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function()? onLongPress;
  PostWidget(
      {super.key,
      this.isUserShow = false,
      required this.data,
      this.onCommentTap,
      this.onTapLike,
      this.onEdit,
      this.onLongPress,
      this.onDelete});

  List<String> emojis = [
    Assets.heartEmoji,
    Assets.sadEmoji,
    Assets.smileEmoji,
    Assets.pointingFingerEmoji
  ];
  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, dynamic>> topReactions = [];
    if (data.reactions != null && data.reactions!.isNotEmpty) {
      final sortedReactions =
          List<MapEntry<String, dynamic>>.from(data.reactions!.entries);
      sortedReactions.sort((a, b) => b.value.compareTo(a.value));
      topReactions = sortedReactions.take(3).toList();
    }
    return Container(
      // height: 281.h,
      padding: EdgeInsets.symmetric(
          horizontal: AppStyles.screenHorizontalPadding, vertical: 17.r),
      margin: EdgeInsets.only(bottom: 10.r),
      color: AppColors.scaffoldColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUserShow!) ...[
            Row(
              children: [
                UserProfileWidget(radius: 25.r, imageUrl: data.user!.picture),
                10.pw,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( 
                      data.user!.userName,
                      style:
                          context.textStyle.labelMedium!.copyWith(height: 0.9),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GenericTranslateWidget( 
                          data.createdAt != null
                              ? data.createdAt!.timeAgo()
                              : "hsajk",
                          style: context.textStyle.bodySmall!
                              .copyWith(color: AppColors.primaryColor),
                        ),
                        GenericTranslateWidget( 
                          " • ",
                          style: context.textStyle.bodyMedium!
                              .copyWith(fontSize: 16.sp),
                        ),
                        SvgPicture.asset(
                          Assets.worldIcon,
                          width: 12.r,
                        )
                      ],
                    )
                  ],
                )),
                if (data.isMyPost ?? false)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        onDelete!();
                      } else if (value == 'edit') {
                        onEdit!();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 1.7,
                          minVerticalPadding: 0.0,
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -4.0),
                          leading: SvgPicture.asset(Assets.editIcon),
                          title: const GenericTranslateWidget( 'Edit'),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 1.7,
                          minVerticalPadding: 0.0,
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -4.0),
                          leading: SvgPicture.asset(Assets.deleteIcon2),
                          title: const GenericTranslateWidget( 'Delete'),
                        ),
                      ),
                    ],
                    icon: const Icon(
                        Icons.more_horiz_outlined), // Icon for opening the menu
                    padding: EdgeInsets.zero,
                  )

                // IconButton(
                //   onPressed: onMoreOptTap,
                //   icon: const Icon(Icons.more_horiz_outlined),
                //   padding: EdgeInsets.zero,
                //   visualDensity: const VisualDensity(horizontal: -4.0),
                // )
              ],
            ),
            10.ph
          ],
          TextWithSeeMore(
            maxLength: 200,
            text: data.postText!,
          ),
          // Row(
          //   children: [
          //     Transform.rotate(
          //         angle: -10.2,
          //         child: Icon(
          //           Icons.link,
          //           size: 15.r,
          //           color: AppColors.primaryColor,
          //         )),
          //     Expanded(
          //         child: GenericTranslateWidget( 
          //       data.attachmentLink!,
          //       style: context.textStyle.displayMedium!.copyWith(
          //           color: AppColors.primaryColor,
          //           decoration: TextDecoration.underline),
          //     ))
          //   ],
          // ),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8.r,
            spacing: 8.r,
            children: List.generate(
              data.postImages!.length,
              (index) => GestureDetector(
                onTap: () {
                  AppRouter.push(FullScreenImageView(
                      imageUrls: data.postImages!, initialIndex: index));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: DisplayNetworkImage(
                    imageUrl: data.postImages![index],
                    height: 62.r,
                    width: 73.r,
                  ),
                ),
              ),
            ),
          ),
          5.ph,
          const Divider(),
          Row(
            children: [
// Row(
//   children: [
//     if (topReactions.isNotEmpty) ...[
//       if (topReactions.length > 1)
              // Stack(
              //   clipBehavior: Clip.none,
              //   children: List.generate(topReactions.length, (index) {
              //     final emoji = topReactions[index].key;
              //     return Positioned(
              //       right: -13.0 * index,
              //       child: ReactionIconWidget(emoji: emoji),
              //     );
              //   }),
              // )
//       else
//         Row(
//           children: [
//             ReactionIconWidget(
//               emoji: topReactions.first.key,
//             ),
//             5.pw,
//             GenericTranslateWidget( 
//               data.reactionCount.toString(),
//               style: context.textStyle.labelSmall!
//                   .copyWith(letterSpacing: 0.3),
//             ),
//           ],
//         )
//     ]
//   ],
// ),
              if (topReactions.isNotEmpty) ...[
                if (topReactions.length > 1)
                  Stack(
                    clipBehavior: Clip.none,
                    children: topReactions.length > 2
                        ? [
                            ReactionIconWidget(
                              emoji: topReactions[0].key,
                            ),
                            Positioned(
                              right: -13,
                              child: ReactionIconWidget(
                                emoji: topReactions[1].key,
                              ),
                            ),
                            Positioned(
                              right: -28,
                              child: ReactionIconWidget(
                                emoji: topReactions[2].key,
                              ),
                            ),
                          ]
                        : [
                            ReactionIconWidget(
                              emoji: topReactions[0].key,
                            ),
                            Positioned(
                              right: -13,
                              child: ReactionIconWidget(
                                emoji: topReactions[1].key,
                              ),
                            ),
                          ],
                  ),
                Row(
                  children: [
                    if (topReactions.length > 2) 35.pw,
                    if (topReactions.length > 1 && topReactions.length < 3)
                      20.pw,
                    if ((topReactions.length < 2)) ...[
                      ReactionIconWidget(
                        emoji: topReactions.first.key,
                      ),
                      5.pw,
                    ],
                    GenericTranslateWidget( 
                      data.reactionCount.toString(),
                      style: context.textStyle.labelSmall!
                          .copyWith(letterSpacing: 0.3),
                    ),
                  ],
                ),
              ],

              const Spacer(),
              GestureDetector(
                onLongPress: onLongPress,
                onTap: onTapLike,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    data.myReaction == null
                        ? SvgPicture.asset(
                            Assets.likeIcon,
                            width: 20.r,
                            // height: 18.r,
                          )
                        : GenericTranslateWidget( 
                            data.myReaction!,
                            style: TextStyle(fontSize: 18.sp),
                          ),
                    5.pw,
                    GenericTranslateWidget( 
                      Helper.getEmojiLabel(data.myReaction),
                      style: context.textStyle.labelSmall!
                          .copyWith(letterSpacing: 0.3),
                    )
                  ],
                ),
              ),
              15.pw,
              GestureDetector(
                onTap: onCommentTap,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.commentIcon,
                      width: 20.r,
                      // height: 18.r,
                    ),
                    5.pw,
                    GenericTranslateWidget( data.commentCount.toString(),
                        style: context.textStyle.labelSmall!
                            .copyWith(letterSpacing: 0.3))
                  ],
                ),
              ),
              12.pw,
              IconButton(
                  visualDensity:
                      const VisualDensity(horizontal: -4.0, vertical: -4.0),
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    Assets.uploadIcon,
                    width: 20.r,
                  ))
            ],
          )
        ],
      ),
    );
  }
}

class ReactionIconWidget extends StatelessWidget {
  final String emoji;
  final double? radius;
  const ReactionIconWidget({super.key, required this.emoji, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius ?? 22.r,
      height: radius ?? 22.r,
      padding: Platform.isIOS ? EdgeInsets.only(
        left: 3.r
      ) : EdgeInsets.all(2.r),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: AppColors.reactionIconColor, shape: BoxShape.circle),
      // child: emoji != "" ? SvgPicture.asset(emoji) : null,
      child: GenericTranslateWidget( emoji, textAlign: TextAlign.center, style: TextStyle(
        height: Platform.isIOS ? 1.4.r : null
      ),),
    );
  }
}

extension on DateTime {
  String timeAgo() {
    DateTime now = DateTime.now();

    Duration diff = now.difference(this);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hr ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} weeks ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} month ago';
    } else {
      return '${(diff.inDays / 365).floor()} year ago';
    }
  }
}

class EmojiReactionBar extends StatelessWidget {
  final List<String> emojis;
  final ValueChanged<String> onReactionSelected;

  const EmojiReactionBar({
    super.key,
    required this.emojis,
    required this.onReactionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30.r),
      padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: emojis.map((emoji) {
          return GestureDetector(
            onTap: () => onReactionSelected(emoji),
            child: GenericTranslateWidget( 
              emoji,
              style: TextStyle(fontSize: 30.sp),
            ),
          );
        }).toList(),
      ),
    );
  }
}
