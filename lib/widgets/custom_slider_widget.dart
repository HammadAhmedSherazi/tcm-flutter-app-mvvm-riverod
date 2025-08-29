import 'dart:async';


import '../export_all.dart';


class CustomSliderWidget extends StatefulWidget {
  final List<String>? data;
  final double height;
  final Duration? duration;
  const CustomSliderWidget(
      {super.key, required this.data, required this.height, this.duration});

  @override
  State<CustomSliderWidget> createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  int _currentIndex = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration ?? const Duration(seconds: 3),
        (timer) async {
      if (mounted) {
        setState(() {
          if (_currentIndex + 1 == widget.data!.length) {
            _currentIndex = 0;
          } else {
            _currentIndex = _currentIndex + 1;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.data![_currentIndex].contains("http")
            ? CachedNetworkImage(
                imageUrl: widget.data![_currentIndex],
                width: double.infinity,
                height: widget.height,
                fit: BoxFit.fill,
                key: ValueKey<int>(_currentIndex),
                errorWidget: (context, url, error) => Image.asset(
                  Assets.placeholderImage,
                  fit: BoxFit.cover,
                ),
                placeholder: (context, url) =>
                    Image.asset(Assets.placeholderImage, fit: BoxFit.cover),
              )
            : Image.asset(
                widget.data![_currentIndex],
                width: double.infinity,
                height: widget.height,
                fit: BoxFit.fill,
                key: ValueKey<int>(_currentIndex),
              ));
  }
}
