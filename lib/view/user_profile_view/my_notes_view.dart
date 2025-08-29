import 'package:tcm/utils/app_extensions.dart';

import '../../export_all.dart';


class MyNotesView extends ConsumerStatefulWidget {
  const MyNotesView({super.key});

  @override
  ConsumerState<MyNotesView> createState() => _MyNotesViewConsumerState();
}

class _MyNotesViewConsumerState extends ConsumerState<MyNotesView> {
  late final ScrollController scrollController;
  late final TextEditingController searchTextEditController;
  late final FocusNode focusNode;
  @override
  void initState() {
    scrollController = ScrollController();
    focusNode = FocusNode();
    searchTextEditController = TextEditingController();
    Future.microtask(() {
      ref.read(noteProvider.notifier).getNotes(
            inputCursor: null,
            limit: 10,
            searchText: null
          );
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Future.microtask(() {
          String? cursor = ref.watch(noteProvider).cursor;
          // String status = ref.watch(productDataProvider).status;
          ref.read(noteProvider.notifier).getNotes(
                inputCursor: null,
                limit: 10,
                searchText: searchTextEditController.text == "" ? null : searchTextEditController.text 
              );
                });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(languageChangeNotifierProvider).currentLanguage.code;
    final provider = ref.watch(noteProvider);
    final status = provider.getNoteApiResponse.status;
    final List<int> checkList = List.from(provider.notes.where((note) => note.isSelect).map((note) => note.id));
    if(checkList.isNotEmpty && focusNode.hasFocus){
      focusNode.unfocus();

    }
    
    return CommonScreenTemplateWidget(
        title: "My Note",
        leadingWidget: const CustomBackButtonWidget(),
        bottomWidget: Padding(
          padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(provider.notes.isNotEmpty)...[
                    SizedBox(
                      height: 54.h,
                      child: Column(
                                      
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      // spacing: 2,
                                      children: [
                                       
                                       
                                       InkWell(
                      onTap: (){
                        ref.read(noteProvider).selectAll();
                      },
                      child: Container(
                              width:25.r,
                              height: 25.r,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: provider.allSelect ? AppColors.primaryGradinet : null,
                                  border:
                                      !provider.allSelect ? Border.all(color: Colors.black) : null),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 17.r,
                              ),
                            ),
                                        ),
                                     
                                        GenericTranslateWidget( "All", style: context.textStyle.bodyMedium,)
                                      ],
                                    ),
                    ),
                  ],
              
              Expanded(
                child: CustomButtonWidget(
                  color:checkList.isNotEmpty?Colors.grey:null ,

                  title: "Add Note", onPressed: checkList.isEmpty? () {
                  AppRouter.push(const AddNoteView());
                }: null),
              ),
            ],
          ),
        ),
        onRefresh: () async {
          ref.read(noteProvider.notifier).getNotes(
                inputCursor: null,
                limit: 10,
                searchText: null
              );
        },
        actionWidget: provider.notes.isNotEmpty? GestureDetector(
          onTap: () {
            
            if(checkList.isNotEmpty){
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
                                        final isLoad = provider.deleteNoteApiResponse.status;
                                        return isLoad == Status.loading
                                            ? const CircularProgressIndicator()
                                            : TextButton(
                                                onPressed: () {
                                                  provider.deleteNote(ids: checkList);
                                                  
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
                                          "Are you sure to delete selected ${checkList.length > 1 ? "notes" : "note" } ?",
                                          style: context.textStyle.displayMedium!
                                              .copyWith(fontSize: 20.sp),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
          
            }
            else{
              Helper.showMessage("Please select any items");
            }
             },
          child: Container(
            width: 31.r,
            height: 31.r,
            padding: EdgeInsets.all(6.r),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: SvgPicture.asset(
              Assets.deleteIcon,
            ),
          ),
        ) : null,
        child: Column(
          spacing: 20.h,
          children: [
            if(checkList.isEmpty)
            Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: AppStyles.screenHorizontalPadding
              ),
              child: CustomSearchBarWidget(
                controller: searchTextEditController,
                focusNode: focusNode,
                isArabic: languageCode == "ar",
                hintText: Helper.getCachedTranslation(ref: ref, text: "Search a note"),onChanged: (text) {
                    if (text.length >= 2) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        ref.read(noteProvider).getNotes(inputCursor: null, limit: 10, searchText: text);
                      });
                    } else if (text == "") {
                      Future.delayed(const Duration(milliseconds: 500), () {
                       ref.read(noteProvider).getNotes(inputCursor: null, limit: 10, searchText: null);
                      });
                    }
                
              },),
            ),
            Expanded(
              child: AsyncStateHandler(
                  emptyMessage: "No record found!",
                  status: status,
                  dataList: provider.notes,
                  itemBuilder: (context, index) {
                     if (status == Status.loadingMore &&
                                    index == provider.notes.length) {
                                  return const CustomLoadingWidget();
                                } else {
                                  final item = provider.notes[index];
              
                                  // Convert createdAt String to DateTime
                                  DateTime currentDate = item.createdAt;
              
                                  // Get previous date (if exists)
                                  DateTime? previousDate =
                                      index > 0 ? provider.notes[index - 1].createdAt : null;
              
                                  // Show date header if it's the first item or a new day
                                  bool showDateHeader = currentDate.day != previousDate!.day ||
                                      currentDate.month != previousDate.month ||
                                      currentDate.year != previousDate.year;
              
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (showDateHeader) ...[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 5),
                                          child: GenericTranslateWidget( 
                                            Helper.getReadableDateHeader(currentDate),
                                            style: context.textStyle.displayMedium!
                                                .copyWith(fontSize: 16.sp),
                                          ),
                                        ),
                                      ],
                                      CustomListWidget(
                      iconPayment: null,
                      leadingWidget: GestureDetector(
                      onTap: (){
                        ref.read(noteProvider).selectNote(index);
                      },
                      child: Container(
                        width:30.r,
                        height: 30.r,
                        margin: EdgeInsets.only(
                          top: 10.r
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: item.isSelect ? AppColors.primaryGradinet : null,
                            border:
                                !item.isSelect ? Border.all(color: Colors.black) : null),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 17.r,
                        ),
                      )),
                      title: item.title,
                      subtitle: GenericTranslateWidget( item.description,maxLines: 1,overflow: TextOverflow.ellipsis,),
                      showLeading: false,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              visualDensity: const VisualDensity(
                                  horizontal: -4.0, vertical: -4.0),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                AppRouter.push( AddNoteView(
                                  note: item,
                                ));
                              },
                              icon: SvgPicture.asset(Assets.editIcon)),
                          
                        ],
                      ),
                    )
                                    ],
                                  );}
                    
              
                   
                  },
                  onRetry: () {
                    ref.read(noteProvider.notifier).getNotes(
                          inputCursor: null,
                          limit: 10,
                          searchText: searchTextEditController.text == ""? null : searchTextEditController.text
                        );
                  }),
            ),
          ],
        ));
  }
}
