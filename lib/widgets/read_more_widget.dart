import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';

class ReadMoreWidget extends StatefulWidget {
  const ReadMoreWidget({super.key, required this.items});

  final List<String> items;

  @override
  State<ReadMoreWidget> createState() => _ReadMoreWidget();
}

class _ReadMoreWidget extends State<ReadMoreWidget> {
  late List<String> displayedItems;
  bool showMore = false;
  int lastItemIndex = 0;
  int count = 0;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.items.length; i++) {
      count += widget.items[i].length;
      if (count > 100) {
        lastItemIndex = i;
        showMore = true;
        setState(() {});
        break;
      }
    }
    // Check if more items are available
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void toggleShowMore() {
    setState(() {
      showMore = !showMore; // Toggle the showMore state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          showMore ? lastItemIndex : widget.items.length,
          (index) => Padding(
            padding: EdgeInsets.only(left: 10.r),
            child: (index == widget.items.length - 1 &&
                    count > 100 &&
                    !showMore)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericTranslateWidget( 
                        "•",
                        style: context.textStyle.bodyMedium!,
                      ),
                      10.pw,
                      Expanded(
                          child: Wrap(
                        children: [
                          GenericTranslateWidget( 
                            widget.items[index],
                            style: context.textStyle.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleShowMore();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: GenericTranslateWidget( 
                                showMore ? "See more..." : "See less...",
                                style: context.textStyle.displayMedium!
                                    .copyWith(color: AppColors.primaryColor),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericTranslateWidget( 
                        "•",
                        style: context.textStyle.bodyMedium!,
                      ),
                      10.pw,
                      Expanded(
                          child: GenericTranslateWidget( 
                        widget.items[index],
                        style: context.textStyle.bodyMedium,
                      )),
                    ],
                  ),
          ),
        ),
        if (showMore && count > 100) ...[
          Padding(
            padding: EdgeInsets.only(left: 10.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GenericTranslateWidget( 
                  "•",
                  style: context.textStyle.bodyMedium!,
                ),
                10.pw,
                Expanded(
                    child: Wrap(
                  children: [
                    GenericTranslateWidget( 
                      widget.items[lastItemIndex],
                      style: context.textStyle.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        toggleShowMore();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GenericTranslateWidget( 
                          showMore ? "See more..." : "See less...",
                          style: context.textStyle.displayMedium!
                              .copyWith(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          )
        ],
      ],
    );
  }
}
