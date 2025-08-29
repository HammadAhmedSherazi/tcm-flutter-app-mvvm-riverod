

import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';

class CommentView extends ConsumerStatefulWidget {
  final int id;
  final int index;
  const CommentView({super.key, required this.index, required this.id});

  @override
  ConsumerState<CommentView> createState() => _CommentViewConsumerState();
}

class _CommentViewConsumerState extends ConsumerState<CommentView> {
  late final ScrollController scrollController;
  late final TextEditingController controller;
  @override
  void initState() {
    scrollController = ScrollController();
    controller = TextEditingController();
    Future.delayed(Duration.zero, () {
      ref
          .read(communityProvider.notifier).getComments(limit: 10, cursor: null, postId: widget.id);
       
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero, () {
          String? cursor = ref.watch(communityProvider).commentCursor;

          ref
              .read(communityProvider.notifier)
              .getComments(limit: 5, cursor: cursor, postId: widget.id);
             
                });
      }
    });
    super.initState();
  }

  void smoothScrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500), // Adjust duration as needed
      curve: Curves.easeInOut, // Smooth animation
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(communityProvider);
    final status = provider.getPostCommentApiResponse.status;
    final isLoad = status == Status.loading;
    final post = provider.posts[widget.index];
    final user = provider.userData;
    final comments = isLoad
        ? List.generate(
            3,
            (index) => CommentModel(
                id: -1,
                postId: -1,
                userId: -1,
                comment: "jsgajdg",
                user: UserDataModel(
                    id: -1, picture: "hsahdga", userName: "agshdgashjdgx")),
          )
        : provider.comments;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor1,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(128.h),
          child: ChatTopWidget(
            imageUrl: post.user!.picture,
            name: post.user!.userName,
            onOptionTap: () {},
            onBackTap: null,
          )),
      body: RefreshIndicator(
        onRefresh: () async {
        ref
          .read(communityProvider.notifier).getComments(limit: 10, cursor: null, postId: widget.id);
        },
        child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: Column(
              children: [
                PostWidget(
                  data: post,
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => EmojiReactionBar(
                        onReactionSelected: (emoji) {
                          // Handle selection
                          ref
          .read(communityProvider.notifier).likePost(react: emoji, index: widget.index);
                          AppRouter.back();
                        },
                        emojis: Helper.emojiOptions,
                      ),
                    );
                  },
                  onTapLike: () {
                       ref
          .read(communityProvider.notifier).likePost(
                        react: post.myReaction != null ? null : '❤️',
                        index: widget.index);
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppStyles.screenHorizontalPadding,
                      vertical: AppStyles.screenHorizontalPadding - 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: GenericTranslateWidget( 
                        "All Comment",
                        style: context.textStyle.labelMedium!
                            .copyWith(fontSize: 16.sp),
                      ))
                    ],
                  ),
                ),
                Expanded(
                    child: status == Status.error
                        ? CustomErrorWidget(onPressed: () {
                            ref
          .read(communityProvider.notifier).getComments(limit: 10, cursor: null, postId: widget.id);
                          })
                        : status == Status.completed && comments.isEmpty
                            ? const SizedBox.shrink()
                            : Skeletonizer(
                                enabled: isLoad,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return status == Status.loadingMore &&
                                            index == comments.length
                                        ? const CustomLoadingWidget()
                                        : CommentDisplayWidget(
                                            comment: comments[index],
                                            user: user,
                                            widget: widget,
                                            commentIndex: index,
                                          );
                                  },
                                  itemCount: status == Status.loadingMore
                                      ? comments.length + 1
                                      : comments.length,
                                ))),
                ChattingSendBoxWidget(
                  hintText: "Add comment",
                  onGallerySelect: () {},
                  isImagePickEnable: false,
                  textEditingController: controller,
                  leadingWidget:
                      UserProfileWidget(radius: 20.r, imageUrl: user!.picture),
                  onSendTap: () {
                    if (controller.text.isNotEmpty) {
                        ref
          .read(communityProvider.notifier).createComment(
                          comment: controller.text,
                          postId: widget.id,
                          index: widget.index);
                      controller.clear();
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}

class CommentDisplayWidget extends StatelessWidget {
  const CommentDisplayWidget(
      {super.key,
      required this.comment,
      required this.user,
      required this.widget,
      required this.commentIndex});

  final CommentModel comment;
  final UserDataModel? user;
  final CommentView widget;
  final int commentIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: AppStyles.screenHorizontalPadding,
          right: AppStyles.screenHorizontalPadding,
          bottom: 20.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserProfileWidget(radius: 20.r, imageUrl: comment.user!.picture),
          10.pw,
          Expanded(
            child: Container(
              padding: user!.id == comment.user!.id
                  ? EdgeInsets.only(left: 10.r, right: 10.r, bottom: 10.r)
                  : EdgeInsets.all(10.r),
              constraints:
                  BoxConstraints(maxHeight: double.infinity, minHeight: 71.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                  border:
                      Border.all(color: const Color.fromRGBO(0, 0, 0, 0.10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text( 
                          comment.user!.userName,
                          style: context.textStyle.labelSmall!
                              .copyWith(letterSpacing: 0.4),
                        ),
                      ),
                      if (user!.id == comment.user!.id)
                        IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(
                              horizontal: -4.0, vertical: -4.0),
                          onPressed: () {
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
                                          .watch(communityProvider)
                                          .createPostApiResponse
                                          .status;
                                      return isLoad == Status.loading
                                          ? const CircularProgressIndicator()
                                          : TextButton(
                                              onPressed: () {
                                                ref
          .read(communityProvider.notifier).deletePostComment(
                                                        id: comment.id,
                                                        index: commentIndex,
                                                        postIndex:
                                                            widget.index);
                                              },
                                              child: GenericTranslateWidget( 
                                                "Yes",
                                                style: context
                                                    .textStyle.displayMedium!
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
                                        "Are you sure to delete?",
                                        style: context.textStyle.displayMedium!
                                            .copyWith(fontSize: 20.sp),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: GenericTranslateWidget( 
                            "Delete",
                            style: context.textStyle.displaySmall!.copyWith(
                                decoration: TextDecoration.underline,
                                color: context.colors.primary),
                          ),
                        )
                      // PopupMenuButton<String>(
                      //   menuPadding: EdgeInsets.zero,
                      //   padding: EdgeInsets
                      //       .zero, // Remove extra padding around the button

                      //   onSelected: (value) {
                      //     if (value == 'delete') {
                      //       showDialog(
                      //         context: context,
                      //         builder: (context) => AlertDialog(
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius:
                      //                   BorderRadius.circular(30.r)),
                      //           actions: [
                      //             TextButton(
                      //               onPressed: () {
                      //                 AppRouter.back();
                      //               },
                      //               child: GenericTranslateWidget( 
                      //                 "No",
                      //                 style: context.textStyle.displayMedium!
                      //                     .copyWith(fontSize: 18.sp),
                      //               ),
                      //             ),
                      //             Consumer(
                      //               builder: (_, WidgetRef ref, __) {
                      //                 final isLoad = ref
                      //                     .watch(communityRepoProvider)
                      //                     .createPostApiResponse
                      //                     .status;
                      //                 return isLoad == Status.loading
                      //                     ? const CircularProgressIndicator()
                      //                     : TextButton(
                      //                         onPressed: () {
                      //                           ref
                      //                               .read(
                      //                                   communityRepoProvider)
                      //                               .deletePostComment(
                      //                                   id: comment.id,
                      //                                   index: commentIndex,
                      //                                   postIndex:
                      //                                       widget.index);
                      //                         },
                      //                         child: GenericTranslateWidget( 
                      //                           "Yes",
                      //                           style: context
                      //                               .textStyle.displayMedium!
                      //                               .copyWith(
                      //                                   fontSize: 18.sp),
                      //                         ),
                      //                       );
                      //               },
                      //             ),
                      //           ],
                      //           content: Row(
                      //             children: [
                      //               Expanded(
                      //                 child: GenericTranslateWidget( 
                      //                   "Are you sure to delete?",
                      //                   style: context
                      //                       .textStyle.displayMedium!
                      //                       .copyWith(fontSize: 20.sp),
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //   },
                      //   itemBuilder: (BuildContext context) =>
                      //       <PopupMenuEntry<String>>[
                      //     const PopupMenuItem<String>(
                      //       value: 'delete',
                      //       child: ListTile(
                      //         contentPadding: EdgeInsets.zero,
                      //         horizontalTitleGap: 1.7,
                      //         minVerticalPadding: 0.0,
                      //         visualDensity: VisualDensity(
                      //             horizontal: -4.0, vertical: -4.0),
                      //         leading: Icon(
                      //           Icons.delete,
                      //           color: Colors.red,
                      //           size: 20,
                      //         ),
                      //         title: GenericTranslateWidget( 'Delete'),
                      //       ),
                      //     ),
                      //   ],
                      //   icon: const Icon(Icons
                      //       .more_horiz_outlined), // Icon for opening the menu
                      // )
                    ],
                  ),
                  GenericTranslateWidget( 
                    comment.comment,
                    style: context.textStyle.bodyMedium,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatTopWidget extends StatelessWidget {
  final VoidCallback? onBackTap;
  final VoidCallback onOptionTap;
  final String name;
  final String imageUrl;
  final bool? showMoreOpt;
  const ChatTopWidget(
      {super.key,
      this.onBackTap,
      required this.imageUrl,
      required this.name,
      required this.onOptionTap,
      this.showMoreOpt = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(
          left: AppStyles.screenHorizontalPadding - 5,
          right: AppStyles.screenHorizontalPadding - 5,
          // top: 40.r,
          bottom: AppStyles.screenHorizontalPadding),
      decoration: AppStyles.appBarStyle,
      child: Row(
        children: [
          CustomBackButtonWidget(
            onTap: onBackTap,
          ),
          15.pw,
          UserProfileWidget(radius: 30.r, imageUrl: imageUrl),
          6.pw,
          Expanded(
              child: GenericTranslateWidget( 
            name,
            style: context.textStyle.labelMedium!.copyWith(fontSize: 16.sp),
          )),
          if (showMoreOpt!)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  onOptionTap();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 1.7,
                    minVerticalPadding: 0.0,
                    visualDensity:
                        VisualDensity(horizontal: -4.0, vertical: -4.0),
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                    title: GenericTranslateWidget( 'Delete'),
                  ),
                ),
              ],
              icon: const Icon(
                  Icons.more_horiz_outlined), // Icon for opening the menu
              padding: EdgeInsets.zero,
            )
          // PopupMenuButton(itemBuilder: itemBuilder,icon: Icon(
          //       Icons.more_horiz_outlined,
          //       size: 21.r,
          //     ),)
//           GestureDetector(
//   onTap: () {
//     showMenu(
//       context: context,
//       position: RelativeRect.fromLTRB(100, 100, 0, 0),
//       items: [
//         PopupMenuItem(child: GenericTranslateWidget( "Edit"), value: "Edit",),
//         PopupMenuItem(child: GenericTranslateWidget( "Delete"), value: "Delete"),
//       ],
//     ).then((value) {
//       if (value != null) print("$value selected");
//     });
//   },
//   child: Icon(Icons.more_horiz_outlined, size: 21),
// )
          // IconButton(
          //     padding: EdgeInsets.zero,
          //     visualDensity: const VisualDensity(horizontal: -4.0),
          //     onPressed: onOptionTap,
          //     icon: Icon(
          //       Icons.more_horiz_outlined,
          //       size: 21.r,
          //     )),
        ],
      ),
    );
  }
}

class ChattingSendBoxWidget extends StatelessWidget {
  final VoidCallback onGallerySelect;
  final VoidCallback onSendTap;
  final String hintText;
  final TextEditingController? textEditingController;
  final List<File>? files;
  final VoidCallback? removeImage;
  final Widget? leadingWidget;
  final bool isImagePickEnable;

  const ChattingSendBoxWidget(
      {super.key,
      required this.onGallerySelect,
      this.textEditingController,
      required this.onSendTap,
      this.removeImage,
      this.files,
      this.leadingWidget,
      this.isImagePickEnable = true,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 93.h,
      padding: EdgeInsets.symmetric(
          horizontal: AppStyles.screenHorizontalPadding, vertical: 10.r),
      decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          border: Border(
              top: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.10)))),
      // color: Colors.red,
      // width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (files != null && files!.isNotEmpty) ...[
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {
                    AppRouter.push(
                      FullImageView(
                        imagePath: files!.first.path,
                      ),
                    );
                  },
                  child: Container(
                    height: 80.r,
                    width: 80.r,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        image: DecorationImage(
                            image: FileImage(files!.first), fit: BoxFit.cover)),
                  ),
                ),
                Positioned(
                    top: -20,
                    right: -20,
                    child: IconButton(
                        onPressed: removeImage,
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        )))
              ],
            )
          ],
          Row(
            children: [
              if (isImagePickEnable) ...[
                IconButton(
                    visualDensity: const VisualDensity(horizontal: -4.0),
                    padding: EdgeInsets.zero,
                    onPressed: onGallerySelect,
                    icon: SvgPicture.asset(Assets.chatGalleryIcon)),
                8.pw,
              ],
              if (leadingWidget != null) ...[
                leadingWidget!,
                8.pw,
              ],
              Expanded(
                child: SizedBox(
                  height: 36.h,
                  child: TextField(
                    controller: textEditingController,
                    onTapOutside: (c){
                            AppRouter.keyboardClose();
                          },
                    decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: context.inputTheme.hintStyle,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 15.r),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.05)),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(20.r),
                                right: Radius.circular(20.r))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.05)),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(20.r),
                                right: Radius.circular(20.r))),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.05)),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(20.r),
                                right: Radius.circular(20.r)))),
                  ),
                ),
              ),
              10.pw,
              CustomMenuIconShape(
                width: 38.r,
                height: 38.r,
                icon: Assets.sendIcon,
                onTap: onSendTap,
                padding: 5.r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
