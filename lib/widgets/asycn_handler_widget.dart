import '../export_all.dart';

class AsyncStateHandler<T> extends StatelessWidget {
  final Status status;
  final List<T> dataList;
  final Widget Function(BuildContext, int) itemBuilder;
  final VoidCallback onRetry;
  final String? emptyMessage;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final Widget? loadingWidget;
  final Widget ? customSuccessWidget;
  final T? data;

  const AsyncStateHandler({
    super.key,
    required this.status,
    required this.dataList,
    required this.itemBuilder,
    required this.onRetry,
    this.emptyMessage,
    this.scrollController,
    this.padding,
    this.loadingWidget,
    this.data,
    this.customSuccessWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (status == Status.error && data == null) {
      return CustomErrorWidget(onPressed: onRetry);
    }

    if (status == Status.loading && data == null) {
      return loadingWidget ?? const CustomLoadingWidget();
    }

    if (status == Status.completed) {
      if (dataList.isEmpty) {
        return ShowEmptyItemDisplayWidget(message: emptyMessage ?? "No items found!");
      }

      return  customSuccessWidget  ??  ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          if (status == Status.loadingMore && index == dataList.length) {
            return const CustomLoadingWidget();
          } else {
            return itemBuilder(context, index);
          }
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: status == Status.loadingMore ? dataList.length + 1 : dataList.length,
      );
    }

    return const SizedBox.shrink(); // Fallback
  }
}
