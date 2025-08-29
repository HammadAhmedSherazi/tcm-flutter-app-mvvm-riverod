import 'package:tcm/utils/app_extensions.dart';
import '../../export_all.dart';


class AddNoteView extends StatefulWidget {
  final NoteDataModel? note;
  const AddNoteView({super.key, this.note});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  late final TextEditingController titleTextEditController;
  late final TextEditingController descriptionTextEditController;
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleTextEditController = TextEditingController(text: widget.note!.title);
      descriptionTextEditController =
          TextEditingController(text: widget.note!.description);
    } else {
      titleTextEditController = TextEditingController();
      descriptionTextEditController = TextEditingController();
    }
    titleTextEditController.addListener((){
      if(titleTextEditController.text.length > titleMaxLength){
        String text = titleTextEditController.text;
        if (text.length > titleMaxLength) {
          text = text.substring(0, titleMaxLength);
          titleTextEditController.selection = TextSelection.fromPosition(
            TextPosition(offset: titleMaxLength),
          );
          Helper.showMessage("Maximum length of $titleMaxLength reached.");
        }
      }
    });
    descriptionTextEditController.addListener(() {
      if(descriptionTextEditController.text.length >
          descriptionMaxLength) {
         String text = descriptionTextEditController.text;
        if (text.length > descriptionMaxLength) {
      text = text.substring(0, descriptionMaxLength);
      descriptionTextEditController.selection = TextSelection.fromPosition(
      TextPosition(offset: descriptionMaxLength),
      );

      Helper.showMessage("Maximum length of $descriptionMaxLength reached.");}
      }
    });
  }

  final int descriptionMaxLength = 500, titleMaxLength = 100;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CommonScreenTemplateWidget(
        leadingWidget: const CustomBackButtonWidget(),
        bottomWidget: Padding(
          padding: EdgeInsets.all(AppStyles.screenHorizontalPadding),
          child: Consumer(
            builder: (_, WidgetRef ref, __) {
              final isLoad = ref.watch(noteProvider).addNoteApiResponse.status == Status.loading;
              return CustomButtonWidget(title: "Done", onPressed: () {
                if(formKey.currentState!.validate()){
                   if(widget.note == null){
                  ref.read(noteProvider).addNote(title: titleTextEditController.text, description: descriptionTextEditController.text);
                }
                else{
                  ref.read(noteProvider).updateNote(title: titleTextEditController.text, description: descriptionTextEditController.text, id: widget.note!.id);

                }
                }
               
              }, isLoad: isLoad,);
            },
          ),
        ),
        title: widget.note != null?"Update Note" :  "Add Note",
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: AppStyles.screenHorizontalPadding),
            children: [
              Consumer(
                builder: (context, ref, child) {
                  return CustomTextFieldWidget(ref:ref,
                    controller: titleTextEditController,
                    hintText: "Enter a title",
                    maxline: 1,
                    minLines: 1,
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
              Consumer(
                builder: (context, ref, child) {
                  return CustomTextFieldWidget(ref:ref,
                    controller: descriptionTextEditController,
                    hintText: "Enter a description",
                    maxline: 4,
                    minLines: 4,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter description";
                      } else if (Helper.convertToHtml(value.trim()).length >
                          descriptionMaxLength) {
                        return 'Description must be less than $descriptionMaxLength characters';
                      }
                      return null;
                    },
                  );
                }
              ),
            ],
          ),
        ));
  }
}
