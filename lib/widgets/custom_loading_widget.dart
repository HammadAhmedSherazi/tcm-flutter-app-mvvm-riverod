import 'package:tcm/utils/app_extensions.dart';

import '../export_all.dart';


class CustomLoadingWidget extends StatelessWidget {
  final Color? color;

  const CustomLoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
   
    return Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation(color ?? context.colors.primary),
      ),
    );
  }
}