import 'package:tcm/export_all.dart';
import 'package:tcm/utils/app_extensions.dart';

class LanguageChangeWidget extends ConsumerWidget {
  const LanguageChangeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageNotifier = ref.watch(languageChangeNotifierProvider);
    final currentLanguage = languageNotifier.currentLanguage;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: AppRouter.navKey.currentContext!,
          showDragHandle: true, // This shows the draggable bar at the top
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          builder: (context) {
            return Column(
              children: [
                GenericTranslateWidget("Select a Language", style: context.textStyle.displayLarge,),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppStyles.screenHorizontalPadding
                  ),
                  itemCount: languageNotifier.languages.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final lang = languageNotifier.languages[index];
                    final isSelected = index == languageNotifier.currentIndex;
                
                    return ListTile(
                      title: Text(lang.name, textAlign: TextAlign.center, style: context.textStyle.displayMedium!.copyWith(
                        color: isSelected ? context.colors.primary : Colors.black,
                        fontSize: 18.sp
                      ),),
                     
                      onTap: () {
                        languageNotifier.setLanguageIndex(index);
                         // close the sheet
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
     
      },
      child: Row(
         spacing: 2.w,
        children: [
          Icon(Icons.language, size: 20.r, color: Colors.black,),
      
          Text(
            currentLanguage.code.toUpperCase(),
            style: context.textStyle.displayMedium,
          ),
        ],
      ),
    );
  
  }
}