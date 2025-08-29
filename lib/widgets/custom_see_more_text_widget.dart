import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class TextWithSeeMore extends StatefulWidget {
  final String text;
  final int maxLength;

  const TextWithSeeMore(
      {super.key, required this.text, required this.maxLength});

  @override
  TextWithSeeMoreState createState() => TextWithSeeMoreState();
}

class TextWithSeeMoreState extends State<TextWithSeeMore> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String displayText = widget.text;
    String? buttonText;

    // If the text is longer than the max length and not expanded, truncate it
    if (displayText.length > widget.maxLength && !_isExpanded) {
      displayText = '${displayText.substring(0, widget.maxLength)}...';
      buttonText = 'See more...';
    } else {
      buttonText = 'See less...';
    }

    return Wrap(
      children: [
        GenericTranslateWidget( 
          displayText,
          style: context.textStyle.bodyMedium,
        ),
        if (displayText.length > widget.maxLength)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // Toggle the expanded state
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GenericTranslateWidget( 
                buttonText,
                style: context.textStyle.displayMedium!
                    .copyWith(color: AppColors.primaryColor),
              ),
            ),
          ),
      ],
    );
  }
}
